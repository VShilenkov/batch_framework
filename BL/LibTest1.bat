::@echo off

set "t1=%time%"

REM 1. Prepare the BatchLibrary for the start command
call BatchLib.bat


REM 2. Start of the Batchlib, acquisition of the command line parameters, swtich to the temporary LibTest1.BLibTmp.bat
<:%BL.Start%

rem  Importing libraries ...
call :bl.import "bl_DateTime.bat"
call :bl.import "bl_String.bat"

set "t2=%time%"
call :bl.DateTime.timeDiff   duration "%t1%" "%t2%"
echo libraries loaded, duration %duration%ms


REM echo !lf!Counter demo
REM for /L %%n in (1,1,10) DO (
   REM call :bl.dateTime.sleep 1
   REM <nul set /p ".=!del!!cr!%%n"
REM )
REM echo(

REM set str=abcdefghijkl
REM call :bl.string.length result %str%
REM echo The length of str="%str%" is %result%