YDBUTILS2
	;
	;
	;
	Q
	;
RunShellCommand(Command,Return)
	N DEV,COUNTER,STR S COUNTER=0
	S DEV="RunShellCommmandPipe"_$J
	O DEV:(command=Command:readonly)::"PIPE"
	U DEV F  Q:$ZEOF=1  R STR:2 S Return($I(COUNTER))=STR Q:'$T
	C DEV I $G(Return(COUNTER))="" K Return(COUNTER)
	Q
	;
DirectoryExists(path)
	N RET,COMMMAND
	S COMMAND="[ -d """_path_""" ] && echo ""exists"""
	D RunShellCommand(COMMAND,.RET)
	I $G(RET(1))="exists" Q 1
	Q 0
	;
CreateDirectoryTree(path)
	N RET,COMMMAND
	S COMMAND="mkdir -p "_path
	D RunShellCommand(COMMAND,.RET)
	I $$DirectoryExists(path) Q 1
	Q 0
	;
GetRoutineList(RTNS,PATTERN)
	N %ZR
	I $G(PATTERN)="" S PATTERN="*"
	D SILENT^%RSEL(PATTERN)
	M RTNS=%ZR K %ZR
	Q