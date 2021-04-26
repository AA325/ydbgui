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
	s @R@("GTOTAL")=$G(C,0)
	Q
	;
POPULATEGLOBALS(I,O)
	;
	N R S R=$NA(O("data"))
	N G S G=$G(I("data","GLBL"))
	N S S S=$G(I("data","SIZE")) I S="" S S=100
	N SR S SR=$G(I("data","SEARCH"))
	I G="" S @R@("STATUS")="false" Q
	I '$D(@G) S @R@("STATUS")="false" Q
	I SR="",$O(@G@(""))="" D SETNODE Q
	I SR]"",$O(@G@(""))="",G[SR D SETNODE Q
	N A,C,CNT S CNT=0,C=0
	S A="" F  S A=$O(@G@(A)) Q:A=""  D
	. I SR]"",$NA(@G@(A))'[SR Q
	. I S,$I(CNT),C<S,$I(C) D SETNODES I 1
	. E  I 'S,$I(CNT),$I(C) D SETNODES
	I S,CNT>S S @R@("MESSAGE")=C_" node(s) out of "_CNT
	E  S @R@("MESSAGE")=C_" node(s)"
	I $D(@R@("NODES")) S @R@("STATUS")="true"
	E  S @R@("STATUS")="false"
	Q
	;
SETNODE
	S @R@("NODES",1,"expandable")="false"
	S @R@("NODES",1,"label")=G
	S @R@("NODES",1,"nodeKey")=G
	S @R@("NODES",1,"icon")="text_snippet"
	S @R@("NODES",1,"selectable")="true"
	S @R@("MESSAGE")="1 node(s)"
	S @R@("STATUS")="true"
	Q	
	;
SETNODES
	S @R@("NODES",C,"label")=$NA(@G@(A))
	S @R@("NODES",C,"nodeKey")=$NA(@G@(A))
	I $O(@G@(A,""))]"" S @R@("NODES",C,"lazy")="true"
	E  S @R@("NODES",C,"expandable")="false"
	I $D(@G@(A))=1 S @R@("NODES",C,"icon")="text_snippet"
	I $D(@G@(A))=10 S @R@("NODES",C,"icon")="folder"
	I $D(@G@(A))=11 S @R@("NODES",C,"icon")="source"
	S @R@("NODES",C,"selectable")="true"
	Q
	;