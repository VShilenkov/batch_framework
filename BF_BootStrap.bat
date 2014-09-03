::@ECHO Off

::------------------------------ :BF.BootStrap ------------------------------::
::---------------------------------------------------------------------------::
:BF.BootStrap
REM -> BF.BootStrap

SET BF.System.CallStack.File="callstack.log"

IF [%~1] EQU [-INTERNAL_START] (
   CALL :CALL BF.BootStrap.Main
) ELSE (
   DEL %BF.System.CallStack.File% 1>NUL 2>NUL
   CALL :CALL BF.BootStrap.Prepare
)

REM <- BF.BootStrap
EXIT /B %ERRORLEVEL%
::---------------------------------------------------------------------------::

::---------------------------------- :CALL ----------------------------------::
::---------------------------------------------------------------------------::
:CALL %function_name% [%args%...]

SET BF

:CALL.INIT

SET BF.System.Function.Name=%~1
SET /A BF.System.Function.Argc=0
SET "BF.System.Function.Argv="

IF [%BF.System.Function.Name%] EQU [] GOTO :CALL.RETURN

FOR %%i IN (%*) DO (

   IF NOT [!BF.System.Function.Argc!] EQU [0] (
      SET "BF.System.Function.Argv=!BF.System.Function.Argv!%%i "
   )
   
   SET /A BF.System.Function.Argc=!BF.System.Function.Argc! + 1
)

:CALL.BEGIN

IF NOT DEFINED BF.System.CallStack.Depth (
   SET /A BF.System.CallStack.Depth=-1
) 

SET /A BF.System.CallStack.Depth=!BF.System.CallStack.Depth! + 1

SET "_tab_string="
IF NOT [%BF.System.CallStack.Depth%] EQU [0] (
   FOR /L %%i IN (1, 1, %BF.System.CallStack.Depth%) DO (
      SET "_tab_string=!_tab_string!-"
   )
)

ECHO %_tab_string%-^>%BF.System.Function.Name% 1>>%BF.System.CallStack.File%

CALL :%BF.System.Function.Name% %BF.System.Function.Argv%

SET "_tab_string="
IF NOT [%BF.System.CallStack.Depth%] EQU [0] (
   FOR /L %%i IN (1, 1, %BF.System.CallStack.Depth%) DO (
      SET "_tab_string=!_tab_string!-"
   )
)

ECHO ^<%_tab_string%-%BF.System.Function.Name% 1>>%BF.System.CallStack.File%

IF [%BF.System.CallStack.Depth%] GEQ [0] (
   SET /A BF.System.CallStack.Depth=%BF.System.CallStack.Depth% - 1
)

:CALL.END

:CALL.RETURN

EXIT /B %ERRORLEVEL%
::---------------------------------------------------------------------------::


::-------------------------- :BF.BootStrap.Prepare --------------------------::
::---------------------------------------------------------------------------::
:BF.BootStrap.Prepare
REM -> BF.BootStrap.Prepare
SETLOCAL

:: Return codes
SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1

:BF.BootStrap.Prepare_INIT
REM -> BF.BootStrap.Prepare_INIT

:: Return varible
SET /A __RETURN=%__RETURN_UNKNOWN%

:BF.BootStrap.Prepare_BEGIN
REM -> BF.BootStrap.Prepare_BEGIN

SET BF_Start=#":<NUL ( SETLOCAL EnableDelayedExpansion#"^
#"& CALL SET "BF.System.CmdLine=%%CMDCMDLINE%%"#"^
#"& CALL SET "BF.Param[0]=%%~f0"#"^
#"& CALL SET "BF.Param.String=%%*")#"^
#"& "%~f0" -INTERNAL_START#"^
#"& FOR /F "UseBackQ Tokens=1,* Delims==" %%i IN (`SET BF`) DO SET "%%i="#"

:BF.BootStrap.Prepare_END
REM -> BF.BootStrap.Prepare_END

SET /A __RETURN=%__RETURN_SUCCESS%

:BF.BootStrap.Prepare_RETURN
REM <- BF.BootStrap.Prepare_RETURN
(
   ENDLOCAL
   SET "BF_Start=%BF_Start:#"=%"
   EXIT /B %__RETURN%
)
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:BF.BootStrap.Main
REM -> BF.BootStrap.Main
:: Open scope
SETLOCAL EnableDelayedExpansion

:: Return codes
SET /A __RETURN_SUCCESS=0
SET /A __RETURN_UNKNOWN=1
SET /A __RETURN_MISSED_PARAM=2


:BF.BootStrap.Main_INIT
REM -> BF.BootStrap.Main_INIT

:: Return varible
SET /A __RETURN=%__RETURN_UNKNOWN%

:: Validate parameter(s)
IF [%BF.Param[0]%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   GOTO :BF.BootStrap.Main_RETURN
)

:: Set varible(s)
SET "BF.Client.Script.File=%BF.Param[0]%"

FOR %%i in ("%BF.Param[0]%") DO (
   SET "BF.Client.Script.Path=%%~dpi"
   SET "BF.Client.Script.Name=%%~ni"
   SET "BF.Client.Script.Ext=%%~xi"
)

SET "BF.Exec.Tmp.Ext=.tmp"
SET "BF.Exec.Tmp.Name=%BF.Client.Script.Name%_BFExec"

SET "BF.Exec.Tmp.File=%BF.Client.Script.Path%%BF.Exec.Tmp.Name%%BF.Exec.Tmp.Ext%"
SET "BF.Exec.Exec.File=%BF.Client.Script.Path%%BF.Exec.Tmp.Name%%BF.Client.Script.Ext%"

:BF.BootStrap.Main_BEGIN
REM -> BF.BootStrap.Main_BEGIN

SET /P ".=CALL :CALL BF.BootStrap.Init & GOTO :%%%%BF_Start%%%%" 1>%BF.Exec.Tmp.File% 0<NUL 

CALL :CALL BF.BootStrap.Include  %BF.Client.Script.File% %BF.Exec.Tmp.File% --no_init

(
   ECHO.
   ECHO.
   ECHO ::::::::::End of the original Client.Script file::::::::::
   ECHO GOTO :eof
   ECHO.
) >> %BF.Exec.Tmp.File%

CALL :CALL BF.BootStrap.Include %~f0 %BF.Exec.Tmp.File% --no_init

IF EXIST "%BF.Exec.Exec.File%" (DEL "%BF.Exec.Exec.File%" 1>NUL 2>NUL)

REN "%BF.Exec.Tmp.File%" "%BF.Exec.Tmp.Name%%BF.Client.Script.Ext%"

CALL %BF.Exec.Exec.File%
CALL :CALL BF.BootStrap.ClearLocal

:BF.BootStrap.Main_END
REM -> BF.BootStrap.Main_END

SET /A __RETURN=%ERRORLEVEL%

::DEL "%BF.Exec.Exec.File%" 1>NUL 2>NUL

:BF.BootStrap.Main_RETURN
REM <- BF.BootStrap.Main
(
   ENDLOCAL
   EXIT /B %__RETURN%
)
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:BF.BootStrap.Init
REM -> BF.BootStrap.Init

FOR %%P IN (%BF.Param.String%) DO (
   REM TODO Parse input params
   ECHO %%P
)


REM <- BF.BootStrap.Init
EXIT /B 
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:BF.BootStrap.Include %__Include.File% [%__Target.File%] [--no_init]
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
SET "__Target.File=%~dpf0"

SET /A __requre_init=1

IF NOT [%~2] EQU [] (
   IF [%~2] EQU [--no_init] (
      SET /A __requre_init=0
   ) ELSE (
      SET "__Target.File=%~2"
      
      IF NOT [%~3] EQU [] (
         IF [%~3] EQU [--no_init] SET /A __requre_init=0
      )
      
   )
)

IF [%__Include.File%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   SET /A __requre_init=0
   GOTO :BF.BootStrap.Include_RETURN
)

IF [%__Target.File%] EQU [] (
   SET /A __RETURN=%__RETURN_MISSED_PARAM%
   SET /A __requre_init=0
   GOTO :BF.BootStrap.Include_RETURN
)

IF [%__requre_init%] EQU [1] (
   SET "__Include.Function.Init=%~n1.Init"
   SET "__Include.Function.Init=!__Include.Function.Init:_=.!"
)

:BF.BootStrap.Include_BEGIN

IF NOT EXIST "%__Include.File%" (
   SET /A __RETURN=%__RETURN_FILE_NOT_FOUND%
   SET /A __requre_init=0
   GOTO :BF.BootStrap.Include_RETURN
)

IF NOT EXIST "%__Target.File%" (
   SET /A __RETURN=%__RETURN_FILE_NOT_FOUND%
   SET /A __requre_init=0
   GOTO :BF.BootStrap.Include_RETURN
)

ECHO. >> "%__Target.File%"
TYPE "%__Include.File%" >> "%__Target.File%"


:BF.BootStrap.Include_END

SET /A __RETURN=%__RETURN_SUCCESS%

:BF.BootStrap.Include_RETURN
REM <- BF.BootStrap.Include
(
   ENDLOCAL
   IF [%__requre_init%] EQU [1] (
      CALL :%__Include.Function.Init%
      SET __RETURN=%ERRORLEVEL%
   )
   EXIT /B %__RETURN%
)
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:BF.BootStrap.ClearLocal
SET /A __=0
FOR /F "UseBackQ Tokens=1,* Delims==" %%i IN (`SET __`) DO SET "%%i="

EXIT /B 0
::---------------------------------------------------------------------------::