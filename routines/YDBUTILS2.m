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
DirectoryExists(PATH)
	N RET,COMMMAND
	S COMMAND="[ -d """_PATH_""" ] && echo ""exists"""
	D RunShellCommand(COMMAND,.RET)
	I $G(RET(1))="exists" Q 1
	Q 0
	;
FileExists(PATH)
	N RET,COMMMAND
	S COMMAND="[ -f """_PATH_""" ] && echo ""exists"""
	D RunShellCommand(COMMAND,.RET)
	I $G(RET(1))="exists" Q 1
	Q 0
	;
CreateDirectoryTree(PATH)
	N RET,COMMMAND
	S COMMAND="mkdir -p "_PATH
	D RunShellCommand(COMMAND,.RET)
	I $$DirectoryExists(PATH) Q 1
	Q 0
	;
GetRoutineList(RTNS,PATTERN)
	N %ZR
	I $G(PATTERN)="" S PATTERN="*"
	D SILENT^%RSEL(PATTERN)
	M RTNS=%ZR K %ZR
	Q
	;
ReadFileByLine(FILE,RET)
	N SRC,LINE,COUNTER
	S SRC=FILE
	O SRC:(readonly)
	F  U SRC R LINE:2 Q:$ZEOF  Q:'$T  D
	. I $E(LINE,$L(LINE))=$C(13) S LINE=$E(LINE,1,$L(LINE)-1)
	. I $E(LINE,$L(LINE))=$C(10) S LINE=$E(LINE,1,$L(LINE)-1)
	. S RET($I(COUNTER))=LINE
	C SRC
	Q
	;
ReadFileByChunk(FILE,CHUNK,RET)
	N SRC,LINE,COUNTER
	S SRC=FILE
	O SRC:(readonly:fixed:recordsize=CHUNK)
	F  U SRC R LINE:2 Q:$ZEOF  Q:'$T  D
	. S RET($I(COUNTER))=LINE
	C SRC
	Q
	;