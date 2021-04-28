%YDBWEBRTNS
	;
	;
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
