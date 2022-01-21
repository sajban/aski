(define prefixExtended
  {string --> string}
  S -> (@s "extended-" S))

(define ->extendedKLambda
  {string --> string}
  FileName -> (let extendedFileName (prefixExtended FileName)
		 (bootstrap extendedFileName)))

(let extendedShenFiles ["main.shen" "types.shen" "declarations.shen"]
   (map (fn ->extendedKLambda) extendedShenFiles))
