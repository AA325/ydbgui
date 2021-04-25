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
PING(I,O)
	S O("data","RESULT")="PONG"
	Q