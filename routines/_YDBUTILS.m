%YDBUTILS ; Ahmed Abdelrazek ; 05/07/2021 ; YottaDB Utilities Entry Point
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
	;
RunShellCommand(COMMAND,RET) 	D RunShellCommand^%YDBUTILS2(.COMMAND,.RET) Q
DirectoryExists(PATH) 			Q $$DirectoryExists^%YDBUTILS2(.PATH)
CreateDirectoryTree(PATH) 		Q $$CreateDirectoryTree^%YDBUTILS2(.PATH)
GetRoutineList(RTNS,PATTERN) 	D GetRoutineList^%YDBUTILS2(.RTNS,.PATTERN) Q
GetGlobalList(GLBLS,PATTERN)	D GetGlobalList^%YDBUTILS2(.GLBLS,.PATTERN) Q
FileExists(PATH)				Q $$FileExists^%YDBUTILS2(.PATH)
ReadFileByLine(FILE,RET)		D ReadFileByLine^%YDBUTILS2(.FILE,.RET) Q
ReadFileByChunk(FILE,CHUNK,RET) D ReadFileByChunk^%YDBUTILS2(.FILE,.CHUNK,.RET) Q
WriteFile(FILE,DATA)			D WriteFile^%YDBUTILS2(.FILE,.DATA) Q
UP(STR)							Q $$UP^%YDBUTILS2(.STR)
LOW(STR)						Q $$LOW^%YDBUTILS2(.STR)
RoutinePaths(RET)				D RoutinePaths^%YDBUTILS1(.RET) Q
DeleteFile(FILE)				D DeleteFile^%YDBUTILS1(.FILE) Q
	;							
	;