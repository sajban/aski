 (define generateKLambdaFile
   File -> (let KLFile (shen.klfile File)
                Code (read-file File)
                Open (open KLFile out)
                KL (map (/. X (shen.shen->kl-h X)) Code)
		Write (shen.write-kl KL Open)
              KLFile))

(let ExtendedShenFiles
    ["extended-types.shen" "extended-declarations.shen" "main.shen"]
  (map (fn generateKLambdaFile) ExtendedShenFiles))
