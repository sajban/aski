{
  description = "aski";

  inputs = {
    KLambdaBootstrap = {
      url = path:./KLambdaBootstrap;
      flake = false;
    };
    ShenCoreBootstrap = {
      url = path:./ShenCoreBootstrap;
      flake = false;
    };
    ShenCore = {
      url = path:./ShenCore;
      flake = false;
    };
    ShenCoreTests = {
      url = path:./ShenCoreTests;
      flake = false;
    };
    ShenExtendedBootstrap = {
      url = path:./ShenExtendedBootstrap;
      flake = false;
    };
    ShenExtended = {
      url = path:./ShenExtended;
      flake = false;
    };
    ShenExtendedTests = {
      url = path:./ShenExtendedTests;
      flake = false;
    };
    LispCore = {
      url = path:./LispCore;
      flake = false;
    };
    LispCorePrimitives = {
      url = path:./LispCorePrimitives;
      flake = false;
    };
    LispExtendedPrimitives = {
      url = path:./LispExtendedPrimitives;
      flake = false;
    };
    AskiCore = {
      url = path:./AskiCore;
      flake = false;
    };
    AskiFleik = {
      url = path:./AskiFleik;
      flake = false;
    };
  };

  outputs =
    { self
    , KLambdaBootstrap
    , LispCore
    , LispCorePrimitives
    , LispExtendedPrimitives
    , ShenCoreBootstrap
    , ShenCore
    , ShenExtendedBootstrap
    , ShenExtended
    , AskiCore
    , AskiFleik
    , ...
    }@inputs:
    let
      inherit (builtins) concatStringsSep readFile mapAttrs;

      shenSourcesSha256s = {
        "S31.03" = "0637jvbyyxf8yfa6z446f90lb9sh92qrx3i7hc25pj4chk5q2pwx";
        "stLib1.0" = "0dbism9m6rjpbbjy0zgcwk9gkapax1104srqxkpw84kvn2cnrbay";
      };

      mkShenSource = version: sha256:
        let
          fetchFromUrl = url:
            fetchTarball { inherit url sha256; };
        in
        {
          shenlanguage-org = fetchFromUrl
            "https://www.shenlanguage.org/Download/${version}.zip";

          github-sajban = fetchFromUrl
            "https://github.com/sajban/aski/archive/refs/tags/${version}.tar.gz";
        };

      shenSources = mapAttrs mkShenSource shenSourcesSha256s;

      mkMkAski = { kor, stdenv, sbcl, writeText }:
        { src
        , version ? kor.mkImplicitVersion src
        , corePrimitives ? (LispCorePrimitives + /primitives.lsp)
        , extendedPrimitives ? (LispExtendedPrimitives + /primitives.lsp)
        , lispMakeCore ? (LispCore + /make.lsp)
        , lispBackend ? (LispCore + /backend.lsp)
        , ShenCoreTests ? inputs.ShenCoreTests
        , ShenExtendedTests ? inputs.ShenExtendedTests
        }:
        let
          lispPrimitives = writeText "allPrimitives.lsp"
            (concatStringsSep "\n" [
              (readFile corePrimitives)
              (readFile extendedPrimitives)
            ]);

          lispMakeExtension = ''
            (LOAD "${sbcl}/lib/sbcl/contrib/uiop.fasl")
          '';

          lispMakeExtended = writeText "make.lsp"
            (builtins.concatStringsSep "\n"
              [ lispMakeExtension (readFile lispMakeCore) ]);

          lispMake = lispMakeExtended;

          ShenLoadTests = writeText "make.lsp"
            ''
              (cd ${ShenCoreTests})
              (load "runme.shen")
              (cd ${ShenExtendedTests})
              (load "init.shen")
            '';

        in
        stdenv.mkDerivation {
          pname = "aski";
          inherit version src;
          postPatch = ''
            mkdir KLambda
            mv ./*.kl ./KLambda/
            ln -s ${lispPrimitives} ./primitives.lsp
            ln -s ${lispBackend} ./backend.lsp
          '';
          buildInputs = [ sbcl ];
          buildPhase = ''
            sbcl --load ${lispMake}
          '';
          installPhase = ''
            install -m755 -D ./aski $out/bin/aski
          '';
          dontStrip = true; # (blockedBy staticLinking)
          doCheck = true;
          checkPhase = ''
            ./aski ${ShenLoadTests}
          '';
        };

      mkMkAskiNext = { deryveicyn }:
        { src, version, askiFleik ? (AskiFleik + /fleik.aski) }:
        deryveicyn {
          name = "aski";
          inherit src version askiFleik;
        };

      mkMkKLambda = { kor, stdenv, aski }:
        { src
        , extendedSrc ? ShenExtended
        , withBootstrap ? false
        , version ? kor.mkImplicitVersion src
        , shenMakeKLambda ? (ShenCoreBootstrap + /makeKLambda.shen)
        , shenMakeExtendedKLambda ? (ShenExtendedBootstrap + /makeKLambda.shen)
        }:
        let
          askiExecutable =
            if withBootstrap then aski.bootstrap
            else aski.current;

        in
        stdenv.mkDerivation {
          pname = "klambda";
          inherit version src;
          buildInputs = [ askiExecutable ];
          patchPhase = ''
            cp ${extendedSrc}/*.shen ./
          '';
          buildPhase = ''
            aski ${shenMakeKLambda}
            aski ${shenMakeExtendedKLambda}
          '';
          installPhase = ''
            mkdir $out
            install -m644 -D ./*.kl $out
          '';
          doCheck = false;
        };

      currentVersion = "alphaPrime";
      nextVersion = "alphaSecond";

    in
    {
      inherit shenSources;

      SobUyrldz = {
        mkAski = {
          modz = [ "pkgs" ];
          lamdy = mkMkAski;
        };

        mkAskiNext = {
          modz = [ "pkdjz" ];
          lamdy = mkMkAskiNext;
        };

        bootstrap = {
          src = KLambdaBootstrap;
          lamdy = { mkAski, src }:
            mkAski { inherit src; };
        };

        mkKLambda = {
          modz = [ "pkgs" "uyrld" ];
          lamdy = mkMkKLambda;
        };

        currentKLambda = {
          src = ShenCore;
          lamdy = { mkKLambda, src }:
            mkKLambda {
              inherit src;
              extendedSrc = ShenExtended;
              version = currentVersion;
              withBootstrap = true;
            };
        };

        current = {
          lamdy = { mkAski, currentKLambda }:
            mkAski {
              src = currentKLambda;
              version = currentVersion;
            };
        };

        nextKLambda = {
          src = ShenCore;
          lamdy = { mkKLambda, src }:
            mkKLambda {
              inherit src;
              version = nextVersion;
            };
        };

        next = {
          lamdy = { mkAskiNext, nextKLambda }:
            mkAskiNext {
              src = nextKLambda;
              version = nextVersion;
            };
        };

      };

    };
}
