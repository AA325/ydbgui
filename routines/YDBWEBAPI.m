YDBWEBAPI
	;
	;
	;
	Q
	;
API(%Q,%R,%A)
	N %J
	S %R("mime")="application/json"
	S %R("header","Access-Control-Allow-Origin")="*"
	S %R("header","Access-Control-Allow-Headers")="Origin, X-Requested-With, Content-Type, Accept"
	I '$D(@%Q("body")) Q
	N %RR D DECODE^YDBWEB(%Q("body"),"%RR")
	N %ROUTINE S %ROUTINE=%RR("routine")
	K %RR("routine") K %J
	D @(%ROUTINE_"(.%RR,.%J)")
	K @%R D ENCODE^YDBWEB("%J",%R)
	Q
	;
EXAMPLE(I,O)
	;S OUTPUT=$NA(O("data","data"))
	;F I=1:1:10 S @OUTPUT@(I)=I("data","param")_" HAIDER => "_I
	S O("data","data")="abc"
	Q
	;