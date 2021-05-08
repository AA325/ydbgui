%YDBWEBPRSC ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Running Processes GUI
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
GETPROCESSLIST(I,O)
	N R S R=$NA(O("data"))
	N A D RunShellCommand^%YDBUTILS("$ydb_dist/yottadb -run ^%YDBWEBZSY "_$J,.A)
	I '$D(A) S @R@("STATUS")="false" Q
	N B,PID,PN,DV,RTN,CTM,I
	S B="" F  S B=$O(A(B)) Q:B=""  D
	. S PID=$P(A(B),$C(9))
	. S PN=$P(A(B),$C(9),2)
	. S DV=$P(A(B),$C(9),3)
	. S RTN=$P(A(B),$C(9),4)
	. S CTM=$P(A(B),$C(9),5)
	. I $I(I) D
	. . S @R@("PROCESSES",I,"PID")=PID
	. . S @R@("PROCESSES",I,"PN")=PN
	. . S @R@("PROCESSES",I,"DV")=DV
	. . S @R@("PROCESSES",I,"RTN")=RTN
	. . S @R@("PROCESSES",I,"CTM")=CTM
	S @R@("STATUS")="true"
	Q
	;	
ISPROCESSALIVE(I,O)
	N R S R=$NA(O("data"))
	N PID S PID=$G(I("data","PID")) I PID="" S @R@("STATUS")="false" Q
	I PID'?1.N S @R@("STATUS")="false" Q
	I '$ZGETJPI(PID,"isprocalive") S @R@("STATUS")="false" Q
	S @R@("STATUS")="true" 
	Q
	;
PROCESSDETAILS(I,O)
	N R S R=$NA(O("data"))
	N PID S PID=$G(I("data","PID")) I PID="" S @R@("STATUS")="false" Q
	I PID'?1.N S @R@("STATUS")="false" Q
	I '$ZGETJPI(PID,"isprocalive") S @R@("STATUS")="false" Q
	N A D RunShellCommand^%YDBUTILS("$ydb_dist/yottadb -run PROCESSDETAILS^%YDBWEBZSY "_PID,.A)
	M @R@("DETAILS")=A K ^A M ^A=A
	K A D RunShellCommand^%YDBUTILS("$ydb_dist/yottadb -run PROCESSDETAILS^%YDBWEBZSY "_PID_" "_"V",.A)
	M @R@("VARIABLES")=A
	K A D RunShellCommand^%YDBUTILS("$ydb_dist/yottadb -run PROCESSDETAILS^%YDBWEBZSY "_PID_" "_"I",.A)
	M @R@("IVARIABLES")=A
	S @R@("STATUS")="true" 
	Q
	;
KILLPROCESS(I,O)
	N R S R=$NA(O("data"))
	N PID S PID=$G(I("data","PID")) I PID="" S @R@("STATUS")="false" Q
	I PID'?1.N S @R@("STATUS")="false" Q
	I '$ZGETJPI(PID,"isprocalive") S @R@("STATUS")="false" Q
	N A D RunShellCommand^%YDBUTILS("$ydb_dist/mupip STOP "_PID)
	S @R@("STATUS")="true"
	Q
	;
	;