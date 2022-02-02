(package shen []

 (define symbolsFromArityTable
   ArityTable -> (symbolsFromArityTable-h ArityTable []))

 (define symbolsFromArityTable-h
   [] Symbols -> Symbols
   [Symbol Arity | Table] PreviousSymbols
     -> (let Symbols (adjoin Symbol PreviousSymbols)
	  (symbolsFromArityTable-h Table Symbols))
   _ [] -> (simple-error "implementation error in symbolsFromArityTable"))
 
 (define add-primitives
   ArityTable
     -> (let Symbols (symbolsFromArityTable ArityTable)
	     PreviousExternals (trap-error
				(get shen external-symbols)
				(/. E []))
	   (do
	    (initialise-arity-table ArityTable)
	    (put shen external-symbols (adjoin Symbols PreviousExternals))
	    (map (fn update-lambda-table) Symbols))))

 (add-primitives
  [compile-lisp-file 1 delete-file 1 load-lisp 1 posix-argv 0 exit 1
			directory-files 1 ensure-directories-exist 1 copy-file 2
			runrogram 1]))
