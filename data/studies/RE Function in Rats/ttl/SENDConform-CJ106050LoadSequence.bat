@echo off
REM ---------------------------------------------------------------------------
REM UCBSysLoadSequence.bat
REM Batch upload to Stardog using SMS files.
REM ---------------------------------------------------------------------------

cd C:\_github\SENDConform\data\studies\RE Function in Rats\ttl

REM Import working 2019-07-22 
REM @echo.
REM @echo @echo MAPPING Graphmeta_CJ16050.csv
REM call stardog-admin virtual import SENDConform Graphmeta-CJ16050-map.TTL Graphmeta-CJ16050.csv

@echo.
@echo MAPPING DM-CJ16050-R.CSV
call stardog-admin virtual import SENDConform DM-CJ16050-R-map.TTL DM-CJ16050-R.CSV

@echo ---------COMPLETED--------------

@echo.
@pause
@echo.
