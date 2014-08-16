call :BL.Init & goto :%%Bl.Start%% & rem rem @echo off

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

pause

echo !lf!Counter demo
for /L %%n in (1,1,10) DO (
   call :bl.dateTime.sleep 1
   <nul set /p ".=!del!!cr!%%n"
)
echo(

set str=abcdefghijkl
call :bl.string.length result %str%
echo The length of str="%str%" is %result%
)
goto :eof
REM ************** BEGIN OF BATCHLIB **************
REM * A "real" batch library system, that allowes to import other batch files into a batch application
REM *
REM * written 2010 by jeb
REM *******************
rem @echo off
setlocal EnableDelayedExpansion
set "param1=%~1"

REM *** Decide if the Library is started for initalization or only for the first prepare
if "!param1!"=="/INTERN_START" goto :bl_InternalStart

if /i "!param1!" EQU "/S" (
   REM ** Secure start, retrieve the parameter in a secure way, it accepts nearly every parameter, but it needs a temporary file
   REM ** TODO: Implement the REM redirect, Problems: access more than %1 ..%9 (shift, detect the end), double expansion of %%
   REM ** Buy it now for only 399Euro :-)
   echo NOT IMPLEMENTED
   EXIT
) ELSE (
   REM ** Basic start, retrieve the parameter in a simple way, it fails with complex parameters like "&"&"&
   REM ** TODO: Accept more than %9 parameters
   set BL.Start=#":< nul ( setlocal EnableDelayedExpansion & set "bl.cmdcmdline=^^!cmdcmdline^^!" & call set "bl.param[0]=%%~f0" & FOR /L %%n IN (1,1,9) DO ( call set "bl.param[%%n]=%%~1" & shift /1 ) )#"^
#"   & "%~f0" /INTERN_START "^^!bl.param[0]^^!"#"
)
(
  ENDLOCAL
  set "BL.Start=%BL.Start:#"=%"
  goto :eof
)

:bl_InternalStart
rem echo Library init from "%param[0]%"

rem Create Temporary Batchfile with library functions

rem Create first line with call to library_init and jump to the application, suppress a line ending for consistent line numbers
> "%~n2.tmp"  <nul set /p ".=call :BL.Init & goto :%%%%Bl.Start%%%% & rem "
rem Append the original batch file
>> "%~n2.tmp" type "%~f2"

REM Append a "good" file stop mark
(
echo(
echo ^)
echo goto :eof
) >> "%~n2.tmp"

rem Append this library
>> "%~n2.tmp" type "%~f0"

del "%~n2.BLibTmp.bat" 2> nul > nul
ren "%~n2.tmp" "%~n2.BLibTmp.bat" > nul

rem Asynchron start, creates a new cmd instance in the same window
rem Required, even if the application exit or crash the library can do the rest
rem (set dummy=) | ( call "%~n1.BLibTmp.bat" "%~2" )

REM Block this, so it is cached and not depends on a file
(
   call "%~n2.BLibTmp.bat"
   rem start "" /wait /b "%~n1.BLibTmp.bat" "%~2"
   REM echo End of application, remove temporary file^(s^)
   set "err=%errorlevel%"
   del "%~n2.BLibTmp.bat" > nul
   exit /b !err!
)
:: End of function

:BL.Init
rem At this moment there is nothing to do
call :BL.DragAndDrop.Parser
goto :eof
:: End of function

:: Imports/append the file to the current batch file
:BL.Import [filename.bat]
(
   setlocal EnableDelayedExpansion
   type "%~1" >> "%~dpf0"
   set "func=%~n1.Init"
   set "func=!func:_=.!"
)
(
   endlocal
   call :%func%
   goto :eof
)
:: End of function

:: Builds a drag & drop filelist, this list should be used, because files like "Drag&drop.bat" passed in the wrong way by windows
:: Therefore a Drag&Drop Batchfile should always end with an EXIT to suppress the execution of further commands after ampersands
rem Take the cmd-line, remove all until the first parameter
:BL.DragAndDrop.Parser
(
   set "$$$.params=!bl.cmdcmdline:~0,-1!"
   set "$$$.params=!$$$.params:*" =!"
   set bl.dragDrop.count=0

   rem Split the parameters on spaces but respect the quotes
   for %%G IN (!$$$.params!) do (
     set /a bl.dragDrop.count+=1
     set "bl.dragDrop[!bl.dragDrop.count!]=%%~G"
   )
   set "$$$.params="
   goto :eof
)
:: End of functionREM *** begin of library BATCHLIB.DateTime **************

REM * STOP here if runs accidental to this point
rem %~ CRITICAL STOP in BATCHLIB.DateTime

::###############################
:bl.DateTime.Init
goto :eof
::End of function

::###############################
:bl.DateTime.Sleep
(
setlocal EnableDelayedExpansion
set /a sleepCnt=%~1+1
ping 127.0.0.1 -n !sleepCnt! 2> nul 1>nul
endlocal
goto :eof
)
::End of function

::###############################
::### WARNING, enclose the time in quotes ", because it can contain comma seperators
:bl.DateTime.timeDiff <resultVar> <start_time> <end_time>
(
  SETLOCAL
  if "%~4" NEQ "" (
    echo ERROR in :bl.DateTime.timeDiff too much parameter
   exit /b 4
  )
  call :bl.DateTime.timeToMs ms_start "%~2"
  call :bl.DateTime.timeToMs ms_end "%~3"
)
set /a diff_ms=ms_end - ms_start
(
  ENDLOCAL
  set %~1=%diff_ms%
  goto :eof
)
::End of function

::###############################
:bl.DateTime.timeToMs <resultVar> <time>
::### WARNING, enclose the time in quotes ", because it can contain comma seperators
::### WARNING it does not convert time in am/pm format, because it's regressive
SETLOCAL
FOR /F "tokens=1,2,3,4 delims=:,.^ " %%a IN ("%~2") DO (
  set /a ms=^(^(^(30%%a%%100^)*60+7%%b^)*60+3%%c-42300^)*1000+^(1%%d0 %% 1000^)
)
(
  ENDLOCAL
  set %~1=%ms%
  goto :eof
)
::End of function

REM **** end of library BATCHLIB.DateTimeREM *** begin of library BATCHLIB.String **************

REM * STOP here if runs accidental to this point
rem %~ CRITICAL STOP in BATCHLIB.String

:BL.String.Init
call :BL.String.CreateLF
call :BL.String.CreateCR
call :BL.String.CreateDEL_ESC
call :BL.String.CreateLatin1Chars
goto :eof
::End of function

::###############################
:BL.String.length <resultVar> <stringVar>
(   
   setlocal EnableDelayedExpansion
    set "s=%~2#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
      if "!s:~%%P,1!" NEQ "" (
         set /a "len+=%%P"
         set "s=!s:~%%P!"
      )
   )
)
(
   endlocal
    set "%~1=%len%"
   exit /b
)
::End of function

:BL.String.CreateLF
:: Creates a variable with one character LF=Ascii-10
:: LF should  be used later only with DelayedExpansion
set LF=^


rem ** The two empty lines are neccessary, spaces are not allowed
rem ** Creates a percent variant "NLM=^LF", but normaly you should use the !LF! variant
set ^"NLF=^^^%lf%%lf%^%lf%%lf%^"
goto :eof

:BL.String.CreateDEL_ESC
:: Creates two variables with one character DEL=Ascii-08 and ESC=Ascii-27
:: DEL and ESC can be used  with and without DelayedExpansion
setlocal
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  ENDLOCAL
  set "DEL=%%a"
  set "ESC=%%b"
  goto :EOF
)
goto :eof

:BL.String.CreateCR
::: CR should  be used only with DelayedExpansion
for /F "usebackq" %%a in (`copy /Z "%~dpf0" nul`) DO (
   set "cr=%%a"
)
goto :eof


:BL.String.CreateCR_OldVariant
::: CR should  be used only with DelayedExpansion
setlocal EnableDelayedExpansion EnableExtensions
set "X=."
for /L %%c in (1,1,13) DO set X=!X:~0,4094!!X:~0,4094!

echo !X!  > %temp%\cr.tmp
echo\>> %temp%\cr.tmp
for /f "tokens=2 usebackq" %%a in ("%temp%\cr.tmp") do (
   endlocal
   set cr=%%a
   rem set x=
   goto :eof
)
goto :eof

:BL.String.CreateLatin1Chars
   chcp 1252 > NUL
   set "char[deg]=°"
   set "char[ae].lower=ä"
   set "char[oe].lower=ö"
   set "char[ue].lower=ü"
   set "char[sz]=ß"
   set "char[AE].upper=Ä"
   set "char[OE].upper=Ö"
   set "char[UE].upper=Ü"
   chcp 850 > NUL
goto :eof

:BL.String.Format <resultVar> <format> [parameters]
REM TODO: Implement an extended format function
   setlocal EnableDelayedExpansion
   set "result="
   set "format.count=1"
   set "formatParam=%~2"

   :__BL.String.Format.Splitter
   if not defined formatParam
   set formatParamLeft=!formatParam:{*=!
   set "format[%format.count%]=!formatParamLeft!"
   set /a format.count+=1
   goto :__BL.String.Format.Splitter

   set "result="
   (
      ENDLOCAL
      goto :eof
)
REM **** end of library BATCHLIB.String