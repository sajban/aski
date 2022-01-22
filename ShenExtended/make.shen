(define ->extendedKLambdaFileName
  S -> (let ExtendedName (@s "extended-" S)
	  (shen.klfile ExtendedName)))

(define ->KLambdaFile
  File -> (let TargetFileName (->extendedKLambdaFileName File)
	     (->RenamedKlambdaFile File TargetFileName)) )

(define ->RenamedKlambdaFile
  File KLambdaFileName
    -> (let Code (read-file File)
	    Open (open KLambdaFileName out)
	    KL (map (/. X (shen.shen->kl-h X)) Code)
	    Write (shen.write-kl KL Open)
	  KLambdaFileName))

(let ExtendedShenFiles ["main.shen" "types.shen" "declarations.shen"]
   (map (fn ->KLambdaFile) ExtendedShenFiles))
