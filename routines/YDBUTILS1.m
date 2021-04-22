YDBUTILS1
	;SIS/LM - Simple System Status and Related Utilities ;05/08/12  13:08
	;;1.0;ZUTILITIES;
	;
	; This routine is free software / public domain.  Use it as you wish. ;
	; The author makes no claim as to the accuracy or suitability of this
	; computer program.  In no event will the author or Sea Island Systems, Inc. ;
	; be liable for any damages, lost effort, inability to deploy, or anything
	; else relating to a decision to use this routine. ;
	;
ZSY	
SS      ;[public] - System Status display - Fall through to here
	L +^ZSY(0):2 I 1
	E  W !,"Please try again." Q
	N I,SIGUSR1,ZPID,ZPS
	S SIGUSR1=10,^ZSY(0)=$J K ^ZSY($J)
	D PLIST($NA(ZPS))
	F I=1:1 Q:'$D(ZPS(I))  D 
	.S ZPID=$$PID(ZPS(I)) I ZPID>0,$ZSIGPROC(ZPID,SIGUSR1)
	.Q
	D HDR F I=1:1:5 H 1 Q:$D(^ZSY($J,$J))
	D INDEX
	D DISPLAY
	K ^ZSY($J) L -^ZSY(0)
	Q
EXAMJOB ;[public] - Interactively examine a process
JOBEXAM ;[public] - Alias
	I $$ENVCK(1) N DIR,DIRUT,X,Y
	E  W !,"Please try again." Q
	F  D  Q:$D(DIRUT)
	.W !
	.S DIR(0)="F^1:30",DIR("A")="Enter process ID"
	.S DIR("?")="Enter a process ID to examine or 'SY' to display System Status."
	.D ^DIR Q:$D(DIRUT)
	.I $$UC(Y)="SY" D ZSY Q
	.D ONEJOB(Y)
	.Q
	W !
	Q
KILLJOB ;[public] - Interactively kill a MUMPS process
RESJOB  ;[public] - Alias
	I $$ENVCK(1) N DIR,DIRUT,X,Y
	E  W !,"Please try again." Q
	F  D  Q:$D(DIRUT)
	.W !
	.S DIR(0)="F^1:30",DIR("A")="Enter process ID"
	.S DIR("?")="Enter the process ID you wish to kill or 'SY' for System Status."
	.D ^DIR Q:$D(DIRUT)
	.I $$UC(Y)="SY" D ZSY Q
	.D ONEKILL(Y)
	.Q
	W !
	Q
ENVCK(ZPARM)    ;[public] - Environment checks for this routine
	;ZPARM=[Optional] Parameter specifying optional checks
	;
	; Returns '1' (TRUE) for environment OK, '0' (FALSE) for check failed. ;
	;
	I $ZV?1"GT.M".E  ;GT.M
	E  W !,"This routine/option requires GT.M." Q:$Q 0 Q
	I $ZINTERRUPT["JOBEXAM^ZU"  ;$ZINTERRUPT
	E  W !,"Invalid value for Intrinsic Special Variable $ZINTERRUPT" Q:$Q 0 Q
	I $T(JOBEXAM+1^ZU)["NTRUPT^ZSY" ;JOBEXAM^ZU
	E  W !,"Missing or invalid configuration in JOBEXAM^ZU" Q:$Q 0 Q
	;^DIR in JOBEXAM and JOBKILL contexts
	I $G(ZPARM)=1,'($T(^DIR)]"")!'($T(^DICD)]"") D  Q:$Q 0 Q
	.W !,"Missing required Fileman routine"
	.Q
	;
	Q:$Q 1 Q
	;
PLIST(ZNAM)     ;[private] - Generate relevant processes list
	; ZNAM=[Optional] $NAME of results array
	;
	S:'$L($G(ZNAM)) ZNAM=$NA(ZNAM) ;Default to call by reference
	N I,ZCMD,ZDEV,Z
	S I=0,ZDEV="procs" O ZDEV:(command="ps -ef|grep $USER":readonly)::"PIPE"
	U ZDEV F  Q:$ZEOF=1  R Z:2 Q:'$T  D:Z]""  ;Do not wait more than two seconds
	.S ZCMD=$P($E(Z,49,999)," ")
	.;S:ZCMD="mumps"!(ZCMD=($ZTRNLNM("gtm_dist")_"/mumps")) I=I+1,@ZNAM@(I)=Z
	. S:Z["mumps"!(Z[($ZTRNLNM("gtm_dist")_"/mumps")) I=I+1,@ZNAM@(I)=Z
	.Q
	C ZDEV
	Q
INDEX   ;[private] - Create a cross-reference for the "V" (variables) subscript
	;
	N I,J,V,X S J=0 F  S J=$O(^ZSY($J,J)) Q:'J  D
	.F I=1:1 Q:'$D(^ZSY($J,J,"V",I))  D
	..S X=$G(^ZSY($J,J,"V",I)),V=$P(X,"="),^ZSY($J,J,"ZV",V)=$P(X,"=",2,99)
	..Q
	.Q
	Q
HDR     ;[private] - Display header
	; SIS/LM 5/8/2013 - Display environment (next 3 lines)
	N UCI,VOL,Y S (UCI,VOL,Y)=""
	I $T(GETENV^%ZOSV)]"" D GETENV^%ZOSV S UCI=$P(Y,"^"),VOL=$P(Y,"^",2)
	W:UCI]"" !?20,"System Status for UCI="_UCI_", VOL="_VOL,!
	; SIS/LM 5/8/2013 - End insert
	W !," $JOB        Device[s]            Routine   "
	W !,"======|======================|=============="
	Q
DISPLAY ;[private] - Display data for each process
	N I,J,ZCNT,ZD,ZPID,ZR,ZRTN S ZCNT=0
	F I=1:1 Q:'$D(ZPS(I))  D  ;For each mumps process
	.S ZPID=$$PID(ZPS(I)),ZR=$NA(^ZSY($J,ZPID))
	.W !,$G(ZPID) ;$JOB (Process ID), Col 1
	.I '$D(@ZR) W ?7,"<data unavailable>" Q  ;No interrupt data
	.S ZD=$P($G(@ZR@("D",1))," ") S:ZD=0 ZD=" no device"
	.W ?7,ZD ;First device, Col 8
	.S ZRTN=$P($P($G(@ZR@("S",4))," "),"^",2)
	.W ?30,ZRTN ;Routine, Col 31
	.F J=2:1 Q:'$D(@ZR@("D",J))  S ZD="" D  ; Additional device(s)
	..S:@ZR@("D",J)["REMOTE=" ZD=$P($P(@ZR@("D",J),"REMOTE=",2)," ")
	..I ZD]"" W !?7,ZD S ZD=""
	.S ZCNT=ZCNT+1
	.Q
	W !!?2,ZCNT_" processes",!
	Q
PID(PS) ;[private] - Process ID from ps return
	;PS=[Required] String containing process ID as second display column
	N I,L,Y S PS=$G(PS),L=$L(PS),Y="" Q:'L Y
	F I=1:1:L Q:$E(PS,I)=" "
	F I=I+1:1:L Q:'($E(PS,I)=" ")
	Q +$E(PS,I,L)
	;
ONEJOB(ZPID)    ;[private] - Display details of selected process
	I '$L($G(ZPID)) W !,"Missing process ID" Q
	L +^ZSY(0):2 E  W !,"Please try later." Q
	S ^ZSY(0)=$J K ^ZSY($J)
	I '$$VALIDATE(ZPID) W !,"Invalid process ID" Q
	N SIGUSR1 S SIGUSR1=10 ;http://www.comptechdoc.org/os/linux/programming/linux_pgsignals.html
	I $ZSIGPROC(ZPID,SIGUSR1) ;GT.M Programmer's Guide Version 4.4 Unix Edition - Page 325
	D WAIT^DICD
	N I,J,X,Z F I=1:1:5 Q:$D(^ZSY($J,ZPID))  H 1
	H 1     I '$D(^ZSY($J,ZPID)) W !,"Process '"_ZPID_"' details not found." Q
	D INDEX M Z=^ZSY($J,ZPID)
	K ^ZSY($J) L -^ZSY(0)
	; Variable Z has process details
	W !!,"Process ID: "_ZPID I '(+$G(Z("D",1))=0) W ?20,$P(Z("D",1)," ")
	W !!,"Stack:",!
	S I="" F J=1:1 S I=$O(Z("S",I),-1) Q:'I  W !,J_".",?4,$P(Z("S",I)," ") Q:Z("S",I)["$ZINTERRUPT"
	I $L($G(Z("ZPOS"))) W !,">> ",Z("ZPOS"),!
	W !!,"Variables:",!
	S X="" F  S X=$O(Z("ZV",X)) Q:X=""  W !,X_"="_Z("ZV",X)
	Q
ONEKILL(ZPID)   ;[private] - Kill selected process
	I '$L($G(ZPID)) W !,"Missing process ID" Q
	I '$$VALIDATE(ZPID) W !,"Invalid process ID" Q
	I ZPID=$J W !,"Not permitted" Q
	I '$$SURE W !,"No action taken" Q
	; SIGKILL - http://www.comptechdoc.org/os/linux/programming/linux_pgsignals.html
	N SIGKILL S SIGKILL=9
	I $ZSIGPROC(ZPID,SIGKILL)
	E  W !,"Kill signal issued",!
	Q
VALIDATE(ZPID)  ;[private] - Validate Process ID
	;
	N Y S Y=0 Q:'$L(ZPID) Y
	N I,ZPS D PLIST(.ZPS)
	F I=1:1 Q:'$D(ZPS(I))  I $$PID(ZPS(I))=$G(ZPID) S Y=1
	Q Y
SURE(B) ;[private] - Confirm action
	;B=[Optional] DIR("B") - Default is NO
	;Return = 1 (YES) or 0 (NO or abort)
	;
	N DIR,DIRUT,X,Y
	S DIR(0)="Y",DIR("A")="Are you sure",DIR("B")=$G(B,"NO")
	D ^DIR Q:$D(DIRUT) 0
	Q +Y
	;
UC(X)   ;
	Q $TR($G(X),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	;
NTRUPT  ;[private] - Interrupt completion - Transfer data to ^ZSY
	N ZSY S ZSY=$G(^ZSY(0)) D:ZSY>0
	.S:%ZPOS["^" ^ZSY(ZSY,$J,"ZPOS")=$S(%ZPOS["GTM$DMOD":%ZPOS,1:$T(@%ZPOS))
	.ZSHOW "DSV":^ZSY(ZSY,$J)
	.Q
	Q