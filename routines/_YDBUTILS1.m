%YDBUTILS1 ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Utilities Routine
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
RoutinePaths(DIR)
	N ZRO,PIECE,I,CNT,PATH
	S ZRO=$ZROUTINES
	S CNT=1
	K DIR
	F  Q:($E(ZRO)'=" ")  S ZRO=$E(ZRO,2,$L(ZRO))
	F I=1:1:$L(ZRO," ") S PIECE=$P(ZRO," ",I) D
	.Q:$P(PIECE,".",2)="so"
	.Q:$P(PIECE,".",2)="o"
	.I PIECE["(",PIECE[")" S PATH=$P($P(PIECE,"(",2),")")
	.I PIECE["(" S PATH=$P(PIECE,"(",2)
	.I PIECE[")" S PATH=$P(PIECE,")")
	.I PIECE'[")",PIECE'["("  S PATH=PIECE
	.I $$DirectoryExists^%YDBUTILS(PATH) S DIR(CNT)=PATH
	.S CNT=CNT+1
	Q
	;
	;
DeleteFile(FILE)
	N RET,COMMMAND
	S COMMAND="rm "_FILE
	D RunShellCommand^%YDBUTILS(COMMAND,.RET)
	Q
	;
	;