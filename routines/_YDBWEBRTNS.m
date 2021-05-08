%YDBWEBRTNS ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Routines Explorer
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
GETROUTINESLIST(I,O)
	N PATTERN
	S PATTERN=$G(I("data","PATTERN"))
	I PATTERN="" S PATTERN="*"
	N RTNS,R S R=$NA(O("data"))
	D GetRoutineList^%YDBUTILS(.RTNS,PATTERN)
	N PATHS,A,C
	S A="" F  S A=$O(RTNS(A)) Q:A=""  D
	. I $I(C) D
	. . S @R@("RLIST",C,"r")=A
	. . S @R@("RLIST",C,"p")=RTNS(A)
	. . I RTNS(A)]"" S PATHS(RTNS(A))=""
	s @R@("RTOTAL")=$G(RTNS,0)
	S A="",C=0 F  S A=$O(PATHS(A)) Q:A=""  D
	. I $I(C) S @R@("PLIST",C)=A
	Q
	;
POPULATEROUTINE(I,O)
	N RTN,PATH,R
	S R=$NA(O("data"))
	S RTN=I("data","RTN")
	S PATH=I("data","PATH")
	N FILE,FULLPATH
	S FULLPATH=PATH
	I $E(RTN)="%" S FULLPATH=FULLPATH_"_"_$E(RTN,2,$L(RTN))_".m"
	E  S FULLPATH=FULLPATH_RTN_".m"
	I $$FileExists^%YDBUTILS(FULLPATH) D  I 1
	. D ReadFileByLine^%YDBUTILS(FULLPATH,.FILE) 
	. S @R@("STATUS")="true"
	E  S @R@("STATUS")="false" Q
	M @R@("CODE")=FILE ZK @R@("CODE")
	Q
	;
SAVEROUTINE(I,O)
	N R,DATA,F,RTN,PATH
	M DATA=I("data","DATA") I '$D(DATA) S @R@("STATUS")="false" Q
	S RTN=$G(I("data","ROUTINE")) I RTN=""  S @R@("STATUS")="false" Q
	S PATH=$G(I("data","PATH")) I PATH=""  S @R@("STATUS")="false" Q
	S R=$NA(O("data"))
	I $E(RTN)="%" S $E(RTN)="_"
	D WriteFile^%YDBUTILS(PATH_RTN_".m",.DATA)
	S @R@("STATUS")="true"
	Q
	;
GETROUTINEPATHS(I,O)
	N A,R
	S R=$NA(O("data"))
	D RoutinePaths^%YDBUTILS(.A)
	I '$D(A) S @R@("STATUS")="false" Q
	M @R@("PATHS")=A S @R@("STATUS")="true"
	Q
	;	
CREATENEWROUTINE(I,O)
	N RTN,PATH,R
	S R=$NA(O("data"))
	S RTN=$G(I("data","ROUTINE")) I RTN="" S @R@("STATUS")="false" Q
	S PATH=$G(I("data","PATH")) I PATH="" S @R@("STATUS")="false" Q
	I $E(RTN)="%" S $E(RTN)="_"
	I $$FileExists^%YDBUTILS(PATH_"/"_RTN_".m") S @R@("STATUS")="false" Q
	I '$$DirectoryExists^%YDBUTILS(PATH) S @R@("STATUS")="false" Q
	N A S A(1)=I("data","ROUTINE")
	D WriteFile^%YDBUTILS(PATH_"/"_RTN_".m",.A)
	S @R@("STATUS")="true" 
	Q
	;
DELETEROUTINE(I,O)
	N R,DATA,F,RTN,PATH
	S RTN=$G(I("data","ROUTINE")) I RTN=""  S @R@("STATUS")="false" Q
	S PATH=$G(I("data","PATH")) I PATH=""  S @R@("STATUS")="false" Q
	S R=$NA(O("data"))
	I $E(RTN)="%" S $E(RTN)="_"
	D DeleteFile^%YDBUTILS(PATH_RTN_".m")
	S @R@("STATUS")="true"
	Q
	;