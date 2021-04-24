YDBUTILS
	;
	;
	;
	Q
	;
RunShellCommand(COMMAND,RET) 	D RunShellCommand^YDBUTILS2(.COMMAND,.RET) Q
DirectoryExists(PATH) 			Q $$DirectoryExists^YDBUTILS2(.PATH)
CreateDirectoryTree(PATH) 		Q $$CreateDirectoryTree^YDBUTILS2(.PATH)
GetRoutineList(RTNS,PATTERN) 	D GetRoutineList^YDBUTILS2(.RTNS,.PATTERN) Q
FileExists(PATH)				Q $$FileExists^YDBUTILS2(.PATH)
ReadFileByLine(FILE,RET)		D ReadFileByLine^YDBUTILS2(.FILE,.RET) Q
ReadFileByChunk(FILE,CHUNK,RET) D ReadFileByChunk^YDBUTILS2(.FILE,.CHUNK,.RET) Q