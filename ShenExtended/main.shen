(package aski []

 (define main
     -> (let Args (cl.posix-argv)
             RunResult (run Args)
           (handleResult RunResult)))

 (define run
   [Exe] -> (trap-error
             (runFromStdInput)
             (fn emitErrorResult))
   [Exe Script] -> (trap-error
                    (runScript Script)
                    (fn emitErrorResult)))

 (define runFromStdInput
     -> (do (eval (stinput))
            [success]))

 (define emitErrorResult
   Error -> [error Error])

 (define runScript
   File -> (let Code (read-file File)
                Evaluation (map (/. X (eval-kl (shen->kl X))) Code)
              [success]))

 (define handleResult
   [error Error] -> (do
                     (pr (error-to-string Error) (stoutput))
                     (shen.exit 1))
   [success] -> (shen.exit 0)))
