%YDBUTILS2 ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Utilities Routine
	; Copyright (C) 2021 YottaDB, LLC
	; Author: Ahmed Abdelrazek
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version. ;
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details. ;
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <https://www.gnu.org/licenses/>. ;
	;
	Q
	;
RunShellCommand(Command,RET)
	N DEV,COUNTER,STR,IO S COUNTER=0
	S IO=$IO
	S DEV="RunShellCommmandPipe"_$J
	O DEV:(shell="/bin/bash":command=Command:readonly)::"PIPE"
	U DEV F  Q:$ZEOF=1  R STR:2 S RET($I(COUNTER))=STR Q:'$T
	C DEV I $G(RET(COUNTER))="" K RET(COUNTER)
	U IO
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
GetRoutineList(%ZR,PATTERN)
	I $G(PATTERN)="" S PATTERN="*"
	D SILENT^%RSEL(PATTERN)
	Q
	;
GetGlobalList(%ZG,PATTERN)
	I $G(PATTERN)="" S PATTERN="*"
	S %ZG=PATTERN
	D GD^%YDBUTILS3(.%ZG)
	ZK %ZG
	Q
	;
ReadFileByLine(FILE,RET)
	N SRC,LINE,COUNTER,IO
	S SRC=FILE,IO=$IO
	O SRC:(readonly)
	F  U SRC R LINE:2 Q:$ZEOF  Q:'$T  D
	. I $E(LINE,$L(LINE))=$C(13) S LINE=$E(LINE,1,$L(LINE)-1)
	. I $E(LINE,$L(LINE))=$C(10) S LINE=$E(LINE,1,$L(LINE)-1)
	. S RET($I(COUNTER))=LINE
	C SRC U IO
	Q
	;
ReadFileByChunk(FILE,CHUNK,RET)
	N SRC,LINE,COUNTER,IO
	S IO=$IO
	S SRC=FILE
	O SRC:(readonly:fixed:recordsize=CHUNK)
	F  U SRC R LINE:2 Q:$ZEOF  Q:'$T  D
	. S RET($I(COUNTER))=LINE
	C SRC
	U IO
	Q
	;
WriteFile(FILE,DATA)
	N IO S IO=$IO
	O FILE:(newversion:chset="M")
	N A S A="" F  S A=$O(DATA(A)) Q:A=""  U FILE W DATA(A),!
	C FILE
	U IO
	Q
	;
UP(STR)	Q $TR(STR,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LO(STR)	Q $TR(STR,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
	;
	;