(DEFUN shen.directoryFiles (Path)
  (UIOP:DIRECTORY-FILES Path))

(DEFUN shen.ensureDirectoriesExist (Path)
  (ENSURE-DIRECTORIES-EXIST Path))

(DEFUN shen.copyFile (FilePath Path)
  (UIOP:COPY-FILE FilePath Path))

(DEFUN shen.runProgram (Command)
  (UIOP:RUN-PROGRAM Command))
