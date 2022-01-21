(DEFUN cl.compile-lisp-file (filepath) (COMPILE-FILE filepath))

(DEFUN cl.delete-file (filepath) (DELETE-FILE filepath))

(DEFUN cl.load-lisp (filepath) (LOAD filepath))

(DEFUN cl.posix-argv () SB-EXT:*POSIX-ARGV*)

(DEFUN cl.exit (code)
  (SB-EXT:EXIT :CODE code))

(DEFUN cl.directoryiles (Path)
       (UIOP:DIRECTORY-FILES Path))

(DEFUN cl.ensure-directories-exist (Path)
  (ENSURE-DIRECTORIES-EXIST Path))

(DEFUN cl.copy-file (FilePath Path)
  (UIOP:COPY-FILE FilePath Path))

(DEFUN cl.run-program (Command)
  (UIOP:RUN-PROGRAM Command))
