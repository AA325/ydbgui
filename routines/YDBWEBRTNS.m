YDBWEBRTNS
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
	D GetRoutineList^YDBUTILS(.RTNS,PATTERN)
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