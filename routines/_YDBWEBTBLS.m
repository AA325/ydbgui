%YDBWEBTBLS  ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Globals Explorer
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
	;
GETTABLESLIST(I,O)
	N PATTERN,COUNT
	S PATTERN=$G(I("data","PATTERN"))
	I PATTERN["*" S PATTERN=$TR(PATTERN,"*")
	N TABLES,TABLE,RETURN S RETURN=$NA(O("data"))
	I $D(^%ydboctoschema) D
	. S TABLE=$E(PATTERN,1,$L(PATTERN)-1) F  S TABLE=$O(^%ydboctoschema(TABLE)) Q:TABLE=""  D
	. . I PATTERN]"",$L(PATTERN)<$L(TABLE),TABLE'[PATTERN Q
	. . I PATTERN]"",$L(PATTERN)>$L(TABLE),PATTERN'[TABLE Q
	. . I PATTERN]"",$L(PATTERN)=$L(TABLE),PATTERN'=TABLE Q
	. . I $I(COUNT)
	. . S @RETURN@("TABLELIST",COUNT,"T")=TABLE
	S @RETURN@("TABLETOTAL")=$G(COUNT,0)
	Q
	;
EXECUTESQL(I,O)
	N STATEMENT
	S STATEMENT=$G(I("data","STATEMENT"))_";"
	N FILECONTENT
	S FILECONTENT(1)=STATEMENT
	N SQLFILE S SQLFILE="OCTO_SQL_"_$J_".sql"
	N SQLRESULT S SQLRESULT="OCTO_SQL_RESULT_"_$J_".txt"
	D DeleteFile^%YDBUTILS(SQLFILE)
	D WriteFile^%YDBUTILS(SQLFILE,.FILECONTENT)
	D RunShellCommand^%YDBUTILS("$ydb_dist/plugin/octo/bin/octo -f "_SQLFILE_" > "_SQLRESULT)
	D DeleteFile^%YDBUTILS(SQLFILE)
	N RESULT
	D ReadFileByChunk^%YDBUTILS(SQLRESULT,4080,.RESULT)
	D DeleteFile^%YDBUTILS(SQLRESULT)
	N LINE,ROW,PIECE,I,FIELD,OUTPUT,MAXDELIMIT
	S PIECE=1,ROW=1,FIELD="",MAXDELIMIT=0
	S LINE="" F  S LINE=$O(RESULT(LINE)) Q:LINE=""  D
	. F I=1:1:$L(RESULT(LINE)) D
	. . I $E(RESULT(LINE),I)=$C(10) S OUTPUT(ROW,PIECE)=FIELD S ROW=ROW+1,PIECE=1,FIELD="" S:MAXDELIMIT<ROW MAXDELIMIT=ROW Q
	. . I $E(RESULT(LINE),I)="|" S OUTPUT(ROW,PIECE)=FIELD S PIECE=PIECE+1,FIELD="" Q
	. . S FIELD=FIELD_$E(RESULT(LINE),I)
	I $D(OUTPUT) D
	. N LAST
	. S LAST=$O(OUTPUT(""),-1) F I=1:1:MAXDELIMIT S OUTPUT(LAST,I)=$G(OUTPUT(LAST,I))
	K ^A M ^A=RESULT
	K ^B M ^B=OUTPUT
	M O("data","RESULT")=OUTPUT
	S O("data","STATUS")="true"
	Q