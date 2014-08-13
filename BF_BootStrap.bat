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
SET /A __RETURN=%__RETURN_UNKNOWN%

:BF.BootStrap.Param_BEGIN

SET BF_Start=#":<NUL ( SETLOCAL EnableDelayedExpansion#"^
#"& CALL SET "BF.System.CmdLine=%%CMDCMDLINE%%"#"^
#"& CALL SET "BF.Param[0]=%%~f0"#"^
#"& CALL SET "BF.Param.String=%%*")#"^
#"& "%~f0" /INTERNAL_START#"^
#"& FOR /F "UseBackQ Tokens=1,* Delims==" %%i IN (`SET BF`) DO SET "%%i="#"

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
:: Open scope
SETLOCAL EnableDelayedExpansion

:BF.BootStrap.Main_INIT

:: Return codes
SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1
SET /A __RETURN_MISSED_PARAM=2

:: Return varible
SET /A __RETURN=%__RETURN_UNKNOWN%

:: Validate parameter
IF [%BF.Param[0]%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   GOTO :BF.BootStrap.Main_RETURN
)

SET "BF.Script.File=%BF.Param[0]%"

FOR %%i in ("%BF.Param[0]%") DO (
   SET "BF.Script.Path=%%~dpi"
   SET "BF.Script.Name=%%~ni"
   SET "BF.Script.Ext=%%~xi"
)

SET "BF.Tmp.Ext=.tmp"
SET "BF.Tmp.Name=%BF.Script.Name%_BF"
SET "BF.Tmp.File=%BF.Script.Path%%BF.Tmp.Name%%BF.Tmp.Ext%"

SET "BF.Exec.File=%BF.Script.Path%%BF.Tmp.Name%%BF.Script.Ext%"

:BF.BootStrap.Main_BEGIN

SET /P ".=CALL :BF.BootStrap.Init & GOTO :%%%%BF_Start%%%%" 1>%BF.Tmp.File% 0<NUL 

(
   ECHO.
   ECHO.
   TYPE "%BF.Script.File%" 
) >> %BF.Tmp.File%

(
   ECHO.
   ECHO.
   ECHO ::::::::::End of the original script file::::::::::
   ECHO GOTO :eof
   ECHO.
) >> %BF.Tmp.File%

TYPE "%~f0" >> %BF.Tmp.File%

IF EXIST "%BF.Exec.File%" (DEL "%BF.Exec.File%" 1>NUL 2>NUL)

REN "%BF.Tmp.File%" "%BF.Tmp.Name%%BF.Script.Ext%"

CALL %BF.Exec.File%

:BF.BootStrap.Main_END
SET /A __RETURN=%ERRORLEVEL%

DEL "%BF.Exec.File%" 1>NUL 2>NUL

:BF.BootStrap.Main_RETURN
(
   ENDLOCAL
   REM <- BF.BootStrap.Main
   EXIT /B %__RETURN%
)

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