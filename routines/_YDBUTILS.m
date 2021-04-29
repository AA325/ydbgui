%YDBUTILS
	;
	;
	;
	Q
	;
RunShellCommand(COMMAND,RET) 	D RunShellCommand^%YDBUTILS2(.COMMAND,.RET) Q
DirectoryExists(PATH) 			Q $$DirectoryExists^%YDBUTILS2(.PATH)
CreateDirectoryTree(PATH) 		Q $$CreateDirectoryTree^%YDBUTILS2(.PATH)
GetRoutineList(RTNS,PATTERN) 	D GetRoutineList^%YDBUTILS2(.RTNS,.PATTERN) Q
GetGlobalList(GLBLS,PATTERN)	D GetGlobalList^%YDBUTILS2(.GLBLS,.PATTERN) Q
FileExists(PATH)				Q $$FileExists^%YDBUTILS2(.PATH)
ReadFileByLine(FILE,RET)		D ReadFileByLine^%YDBUTILS2(.FILE,.RET) Q
ReadFileByChunk(FILE,CHUNK,RET) D ReadFileByChunk^%YDBUTILS2(.FILE,.CHUNK,.RET) Q
WriteFile(FILE,DATA)			D WriteFile^%YDBUTILS2(.FILE,.DATA) Q
UP(STR)							Q $$UP^%YDBUTILS2(.STR)
LOW(STR)						Q $$LOW^%YDBUTILS2(.STR)
RoutinePaths(RET)				D RoutinePaths^%YDBUTILS1(.RET) Q
DeleteFile(FILE)				D DeleteFile^%YDBUTILS1(.FILE) Q
	;							
