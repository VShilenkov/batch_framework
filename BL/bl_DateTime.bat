REM *** begin of library BATCHLIB.DateTime **************

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

REM **** end of library BATCHLIB.DateTime