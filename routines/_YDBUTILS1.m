%YDBUTILS1
	;
	;
	;
	Q
	;
RoutinePaths(DIR)
	N ZRO,PIECE,I,CNT,PATH
	S ZRO=$ZROUTINES
	S CNT=1
	KILL DIR
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
	Q 1
	;