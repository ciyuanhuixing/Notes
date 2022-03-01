set hh=%time:~0,2%
if /i %hh% LSS 10 (set hh=0%time:~1,1%)
set dt=%DATE:~0,4%%DATE:~5,2%-%DATE:~8,2%-%hh%%TIME:~3,2%
set file=%dt%-.md

if not exist %file% (
		type nul>%file%
    )
start %file%
