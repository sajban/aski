{
  description = "aski";

  inputs = {
    bootstrapKLambda = {
      url = path:./KLambda;
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
    ShenExtended = {
      url = path:./ShenExtended;
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
    ShenCoreTests = {
      url = path:./ShenCoreTests;
      flake = false;
    };
    AskiCore = {
      url = path:./AskiCore;
      flake = false;
    };
  };

  outputs =
    { self
    , bootstrapKLambda
    , LispCore
    , LispExtendedPrimitives
    , ShenCoreBootstrap
    , ShenCore
    , ShenExtended
    , ShenCoreTests
    , AskiCore
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
        , corePrimitives ? (LispCore + /primitives.lsp)
        , extendedPrimitives ? (LispExtendedPrimitives + /primitives.lsp)
        , lispMakeCore ? (LispCore + /make.lsp)
        , lispBackend ? (LispCore + /backend.lsp)
        , shenCoreTests ? inputs.ShenCoreTests
        , shenMake ? (ShenExtended + /make.shen)
        , withShenMake ? false
        }:
        let
          lispAllPrimitives = writeText "allPrimitives.lsp"
            (concatStringsSep "\n" [
              (readFile corePrimitives)
              (readFile extendedPrimitives)
            ]);

          lispPrimitives = thenlispAllPrimitives;

          lispMakeExtension = ''
            (LOAD "${sbcl}/lib/sbcl/contrib/uiop.fasl")
          '';

          lispMakeExtended = writeText "make.lsp"
            (builtins.concatStringsSep "\n"
              [ lispMakeExtension (readFile lispMakeCore) ]);

          lispMake = lispMakeExtended;

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
            echo '(cd ${shenCoreTests}) (load "runme.shen")' |
            ./aski
          '';
        };

      mkMkAskiNext = { deryveicyn }:
        { src, version, askiUniks ? (AskiCore + /uniks.aski) }:
        deryveicyn {
          name = "aski";
          inherit src version askiUniks;
        };

      mkMkKLambda = { kor, stdenv, aski }:
        { src
        , withBootstrap ? false
        , version ? kor.mkImplicitVersion src
        , shenMakeKLambda ? (ShenCoreBootstrap + /makeKLambda.shen)
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
          buildPhase = ''
            aski ${shenMakeKLambda}
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
          src = bootstrapKLambda;
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
