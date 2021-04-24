YDBWEBGLBLS
	;
	;
	;
	Q
	;
	;
GETGLOBALSLIST(I,O)
	N PATTERN
	S PATTERN=$G(I("data","PATTERN"))
	I PATTERN="" S PATTERN="*"
	N GLBLS,R S R=$NA(O("data"))
	D GetGlobalList^YDBUTILS(.GLBLS,PATTERN)
	N PATHS,A,C
	S A="" F  S A=$O(GLBLS(A)) Q:A=""  D
	. I $I(C) D
	. . S @R@("GLIST",C,"g")=A
	. . I GLBLS(A)]"" S PATHS(GLBLS(A))=""
	s @R@("GTOTAL")=$G(GLBLS,0)
	Q
	;
POPULATEGLOBALS(I,O)
	;
	N R S R=$NA(O("data"))
	S @R@("STATUS")="true"
	Q 