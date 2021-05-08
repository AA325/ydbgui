%YDBWEBAPI ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Web Server API Entry Point
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
API(%Q,%R,%A)
	s $ET="D ERR^%YDBWEBAPI"
	N %J
	S %R("mime")="application/json"
	S %R("header","Access-Control-Allow-Origin")="*"
	S %R("header","Access-Control-Allow-Headers")="Origin, X-Requested-With, Content-Type, Accept"
	I '$D(@%Q("body")) Q
	N %RR D DECODE^%YDBWEB(%Q("body"),"%RR")
	N %ROUTINE S %ROUTINE=%RR("routine")
	K %RR("routine") K %J
	N (%RR,%J,%WTCP,%ROUTINE,%Q,%R,%A,%YDBWEBRESP)
	D @(%ROUTINE_"(.%RR,.%J)")
	K @%R D ENCODE^%YDBWEB("%J",%R)
	U %WTCP
	Q
	;
PING(I,O)
	S O("data","RESULT")="PONG"
	Q
	;
ERR ;
	S @R@("ERROR")=$ZSTATUS
	Q