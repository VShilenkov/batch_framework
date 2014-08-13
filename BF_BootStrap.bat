::Batch Framework

::@ECHO Off

:BF.BootStrap
REM -> BF.BootStrap

IF [%~1] EQU [/INTERNAL_START] (
   GOTO :BF.BootStrap.Main
) ELSE (
   GOTO :BF.BootStrap.Prepare
)
GOTO :EOF

:BF.BootStrap.Prepare
REM -> BF.BootStrap.Prepare
SETLOCAL

:BF.BootStrap.Param_INIT

SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1

:BF.BootStrap.Param_BEGIN

SET /A __RETURN=%__RETURN_UNKNOWN%

SET BF_Start=#":<NUL ( SETLOCAL EnableDelayedExpansion#"^
#"& CALL SET "BF.System.CmdLine=%%CMDCMDLINE%%"#"^
#"& CALL SET "BF.Param[0]=%%~f0"#"^
#"& CALL SET "BF.Param.String=%%*")#"^
#"& "%~f0" /INTERNAL_START#"

:BF.BootStrap.Param_END

SET /A __RETURN=%__RETURN_SUCCESS%

:BF.BootStrap.Param_RETURN
(
   ENDLOCAL
   SET "BF_Start=%BF_Start:#"=%"
   
   REM <- BF.BootStrap.Prepare
   EXIT /B %__RETURN%
)

:BF.BootStrap.Main
REM -> BF.BootStrap.Main

ECHO BF init from %BF.Param[0]%

FOR %%i in ("%BF.Param[0]%") DO (
   SET "BF.Script.Path=%%~dpi"
   SET "BF.Script.Name=%%~ni"
   SET "BF.Exec.Tmp=%%~dpni.tmp"
   SET "BF.Exec.Name=%%~ni.tmp"
)
SET "BF.Exec.Bat=%BF.Exec.Tmp%.bat"


SET /P ".=CALL :BF.BootStrap.Init & GOTO :%%%%BF_Start%%%%" 1>%BF.Exec.Tmp% 0<NUL 

(
   ECHO.
   ECHO.
   TYPE "%BF.Param[0]%" 
) >> %BF.Exec.Tmp%

(
   ECHO.
   ECHO.
   ECHO ::::::::::End of the original script file::::::::::
   ECHO GOTO :eof
   ECHO.
) >> %BF.Exec.Tmp%

TYPE "%~f0" >> %BF.Exec.Tmp%

DEL "%BF.Exec.Bat%" 1>NUL 2>NUL
REN "%BF.Exec.Tmp%" "%BF.Exec.Name%.bat"

CALL %BF.Exec.Bat%
SET "__ERR=%ERRORLEVEL%"
DEL "%BF.Exec.Bat%" 1>NUL 2>NUL
REM <- BF.BootStrap.Main
EXIT /B !__ERR!


:BF.BootStrap.Init
REM -> BF.BootStrap.Init

SET BF
::FOR %%P IN ("%BF.Param.String%") DO ()
REM <- BF.BootStrap.Init
GOTO :eof

:: SET BF_Start=#":<NUL ( SETLOCAL EnableDelayedExpansion#"^
:: ^#"            & (SET "BF.CMDCMDLINE=^^!CMDCMDLINE^^!")#"^
:: ^#"            & (CALL SET "BF.Param[0]=%%~f0")#"^
:: ^#" & (CALL SET /A BF.Param.Count=0)#"^
:: ^#" & (CALL SET "BF.Param.String=%%*")#"^
:: ^#" & FOR %%i IN (^!BF.Param.String^!) DO (#"^
:: ^#" (CALL SET /A "BF.Param.Count=^^!BF.Param.Count^^! + 1")#"^
:: ^#" &(CALL SET "BF.Param[^^!BF.Param.Count^^!]="%%~i"")))#"^
:: ^#" & "%~f0" INTERNAL_START "^^!BF.Param[0]^^!"#"
::#"            & FOR /F "UseBackQ Delims==" %%i IN (`SET BF`) DO SET "%%i="#"