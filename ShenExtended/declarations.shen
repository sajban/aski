(package shen []

 (shen.initialise-arity-table
  [compile-lisp-file 1 delete-file 1 load-lisp 1 launcherArguments 0 exit 1
		     directoryFiles 1 ensureDirectoriesExist 1 copyFile 2
		     runProgram 1])

 (put shen external-symbols
      [compile-lisp-file delete-file load-lisp launcherArguments
			 directoryFiles ensureDirectoriesExist copyFile runProgram])

 (shen.build-lambda-table (external shen)))
