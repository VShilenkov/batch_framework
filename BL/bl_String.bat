REM *** begin of library BATCHLIB.String **************

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