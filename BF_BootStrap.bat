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

:BF.BootStrap.Prepare_INIT
REM -> BF.BootStrap.Prepare_INIT

SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1
SET /A __RETURN=%__RETURN_UNKNOWN%

:BF.BootStrap.Prepare_BEGIN
REM -> BF.BootStrap.Prepare_BEGIN

SET BF_Start=#":<NUL ( SETLOCAL EnableDelayedExpansion#"^
#"& CALL SET "BF.System.CmdLine=%%CMDCMDLINE%%"#"^
#"& CALL SET "BF.Param[0]=%%~f0"#"^
#"& CALL SET "BF.Param.String=%%*")#"^
#"& "%~f0" /INTERNAL_START#"^
#"& FOR /F "UseBackQ Tokens=1,* Delims==" %%i IN (`SET BF`) DO SET "%%i="#"

:BF.BootStrap.Prepare_END

SET /A __RETURN=%__RETURN_SUCCESS%

:BF.BootStrap.Prepare_RETURN
REM <- BF.BootStrap.Prepare
(
   ENDLOCAL
   SET "BF_Start=%BF_Start:#"=%"
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

:: Validate parameter(s)
IF [%BF.Param[0]%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   GOTO :BF.BootStrap.Main_RETURN
)

:: Set varible(s)
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

FOR /F "UseBackQ Delims== Tokens=1,*" %%i IN (`SET __`) DO (
   (
      ECHO :: %%i : %%j
      ECHO.
   ) >> %BF.Tmp.File%
)

FOR /F "UseBackQ Delims== Tokens=1,*" %%i IN (`SET BF`) DO (
   (
      ECHO :: %%i : %%j
      ECHO.
   ) >> %BF.Tmp.File%
)

TYPE "%~f0" >> %BF.Tmp.File%

IF EXIST "%BF.Exec.File%" (DEL "%BF.Exec.File%" 1>NUL 2>NUL)

REN "%BF.Tmp.File%" "%BF.Tmp.Name%%BF.Script.Ext%"

CALL %BF.Exec.File%
CALL :BF.BootStrap.ClearLocal

:BF.BootStrap.Main_END
SET /A __RETURN=%ERRORLEVEL%

::DEL "%BF.Exec.File%" 1>NUL 2>NUL

:BF.BootStrap.Main_RETURN
REM <- BF.BootStrap.Main
(
   ENDLOCAL
   EXIT /B %__RETURN%
)

:BF.BootStrap.Init
REM -> BF.BootStrap.Init

FOR %%P IN (%BF.Param.String%) DO (
   REM TODO Parse input params
   ECHO %%P
)


REM <- BF.BootStrap.Init
GOTO :eof

:BF.BootStrap.Include
REM -> BF.BootStrap.Include
:: Open scope
SETLOCAL EnableDelayedExpansion

:BF.BootStrap.Include_INIT

:: Return codes
SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1
SET /A __RETURN_MISSED_PARAM=2
SET /A __RETURN_FILE_NOT_FOUND=3

:: Return varible
SET /A __RETURN=%__RETURN_UNKNOWN%

:: Validate varible(s)
SET "__Include.File=%~1"

IF [%__Include.File%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   GOTO :BF.BootStrap.Include_RETURN
)

SET "__Include.Function.Init=%~n1.Init"
SET "__Include.Function.Init=!__Include.Function.Init:_=.!"

:BF.BootStrap.Include_BEGIN

IF NOT EXIST "%__Include.File%" (
   SET /A __RETURN=%__RETURN_FILE_NOT_FOUND%
   GOTO :BF.BootStrap.Include_RETURN
)

TYPE "%__Include.File%" >> "%~dpf0"


:BF.BootStrap.Include_END

SET /A __RETURN=%__RETURN_SUCCESS%

:BF.BootStrap.Include_RETURN
REM <- BF.BootStrap.Include
(
   ENDLOCAL
   IF NOT [%__RETURN%] EQU [%__RETURN_FILE_NOT_FOUND%] (
      CALL :%__Include.Function.Init%
      SET __RETURN=%ERRORLEVEL%
   )
   EXIT /B %__RETURN%
)

:BF.BootStrap.ClearLocal
SET /A __=0
FOR /F "UseBackQ Tokens=1,* Delims==" %%i IN (`SET __`) DO SET "%%i="

EXIT /B 0
