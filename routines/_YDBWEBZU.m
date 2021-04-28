%YDBWEBZU ;SF/JLI,RWF - For GT.M, TIE ALL TERMINALS TO THIS ROUTINE!! ;2017-01-09  3:51 PM
	;;8.0;KERNEL;**275,419,10001**;Jul 10, 1995;Build 21
	; Submitted to OSEHRA in 2017 by Sam Habiel for OSEHRA
	; Original Routine authored by Department of Veterans Affairs
	; EP JOBEXAM rewritten by Sam Habiel 2016. ;
	;
	;The env var ZINTRRUPT should be set to catch all interrupts. ;
EN ;See that escape processing is off, Conflict with Screenman
	U $P:(NOCENABLE:NOESCAPE)
	N $ESTACK,$ETRAP S $ETRAP="D ERR^%YDBWEBZU	 Q:$QUIT -9 Q"
	S $ZINTERRUPT="I $$JOBEXAM^%YDBWEBZU($ZPOSITION)"
	D COUNT^%YDBWEBXUSCNT(1)
	;
	;
ERR ;Come here on error
	; handle stack overflow errors specifically
	I $P($ZS,",",3)["STACKCRIT"!("STACKOFLOW"[$P($ZS,",",3)) S $ET="Q:$ST>"_($ST-8)_"  G ERR2^%YDBWEBZU" Q
	;
ERR2 ;
	S $ETRAP="D UNWIND^%YDBWEBZU" L  ;Backup Trap
	U $P:NOCENABLE
	Q:$ECODE["<PROG>"
	;
	S $ET="D HALT^%YDBWEBZU"
	;
	I $P($ZS,",",3)'["-CTRLC" S XUERF="" G ^%YDBWEBXUSCLEAN ;419
CTRLC U $P
	W !,"--Interrupt Acknowledged",!
	D KILL1^%YDBWEBXUSCLEAN ;Clean up symbol table
	S $ECODE=",<<POP>>,"
	Q
	;
UNWIND ;Unwind the stack
	Q:$ESTACK>1  G CTRLC2:$ECODE["<<POP>>"
	S $ECODE=""
	Q
	;
CTRLC2 S $ECODE="" G:$G(^%YDBWEB("YDBWEBZSY","XQ",$J,"T"))<2 ^%YDBWEBXUSCLEAN
	S ^%YDBWEB("YDBWEBZSY","XQ",$J,"T")=1,XQY=$G(^(1)),XQY0=$P(XQY,"^",2,99)
	G:$P(XQY0,"^",4)'="M" HALT
	S XQPSM=$P(XQY,"^",1),XQY=+XQPSM,XQPSM=$P(XQPSM,XQY,2,3)
	G:'XQY ^%YDBWEBXUSCLEAN
	S $ECODE="",$ETRAP="D ERR^%YDBWEBZU Q:$QUIT 0 Q"
	U $P:NOESCAPE
	G M1^XQ
	;
HALT I $D(^%YDBWEB("YDBWEBZSY","XQ",$J)) D:$G(DUZ)>0 BYE^%YDBWEBXUSCLEAN
	D COUNT^%YDBWEBXUSCNT(-1)
	HALT
	;
JOBEXAM(%ZPOS) ;
	Q $$JOBEXAM^%YDBWEBZSY(%ZPOS)  ; FOIA improved by Sam
	;
	;
