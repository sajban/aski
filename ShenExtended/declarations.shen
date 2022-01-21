(package shen []

 (shen.initialise-arity-table
  [compile-lisp-file 1 delete-file 1 load-lisp 1 posix-argv 0 exit 1
		     directoryiles 1 ensure-directories-exist 1 copy-file 2
		     runrogram 1])

 (put shen external-symbols
      [compile-lisp-file delete-file load-lisp posix-argv
			 directoryiles ensure-directories-exist copy-file runrogram])

 (shen.build-lambda-table (external shen)))
