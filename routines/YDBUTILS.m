YDBUTILS
	;
	;
	;
	Q
	;
RunShellCommand(Command,Return) D RunShellCommand^YDBUTILS2(.Command,.Return) Q
DirectoryExists(path) 			Q $$DirectoryExists^YDBUTILS2(.path)
CreateDirectoryTree(path) 		Q $$CreateDirectoryTree^YDBUTILS2(.path)
GetRoutineList(RTNS,PATTERN) 	D GetRoutineList^YDBUTILS2(.RTNS,.PATTERN) Q
	;