(package shen []

 (declare compile-lisp-file [string --> string])
 (declare delete-file [string --> boolean])
 (declare load-lisp [string --> boolean])
 (declare launcherArguments [--> [list A]])
 (declare exit [int -->])
 (declare directoryFiles [string --> [list string]])
 (declare ensureDirectoriesExist [string --> boolean])
 (declare copyFile [string --> [string --> boolean]])
 (declare runProgram [[list string] --> [Output --> [ErrorOutput --> ExitCode]]]))
