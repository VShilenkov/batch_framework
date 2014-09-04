@ECHO OFF

::---------------------------------------------------------------------------::
::----------------------------- SCRIPT HEADER -------------------------------::
:: @script_name : <script_name>
:: @language    : Windows Batch File
:: @file_name   : <file_name>
:: @author      : VShilenkov
:: @date        : <date>
:: @brief       : <short_single_line_script_description>
:: @command_line: <usage>
:: @param       : <parameter_description>
:: @return      : <return_code_description>
:: @description : <long_multi_line_script_description>
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:: Start executing script
::---------------------------------------------------------------------------::
GOTO :MAIN
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:: @method     : set_script_config
:: @param [in] : %*  - script param string
:: @return     : no return
:: @usage      : call :set_script_config %*
:: @brief      : Apply all script settings
:: @description: Set all script parameters in environment variables 
::               __SCRIPT_param_%param_number%.
::               Set count of parameters in __SCRIPT_param_count.
::               Here is the place for user script settings.
::---------------------------------------------------------------------------::
:set_script_config

:: All script settings inserting here

:: Saving all script parameters in __SCRIPT_param_%param_number% variables
:: Saving parameter count in __SCRIPT_param_count variable
SET /A __SCRIPT_param_count=0
FOR %%i IN (%*) DO (
   SET /A __SCRIPT_param_count=!__SCRIPT_param_count! + 1
   SET    __SCRIPT_param_!__SCRIPT_param_count!=%%~i
)

EXIT /B
:: set_script_config
::---------------------------------------------------------------------------::


::---------------------------------------------------------------------------::
:: @method     : set_framework_config
:: @param [in] : %*  - script param string
:: @return     : no return
:: @usage      : call :set_framework_config
:: @brief      : Apply internal script settings
:: @description: Set script file description: volume, path, file name, 
::               file extention, etc.
::               Set report level, master and common log files.
::               Starts execution timer.
::---------------------------------------------------------------------------::
:set_framework_config

:: Script file info
SET __SCRIPT_script_full_volume_path_name_ext=%~f0
SET __SCRIPT_script_volume=%~d0
SET __SCRIPT_script_path=%~p0
SET __SCRIPT_script_file_name=%~n0
SET __SCRIPT_script_file_ext=%~x0
SET __SCRIPT_script_short_path_name_ext=%~s0
SET __SCRIPT_script_file_attribute=%~a0
SET __SCRIPT_script_file_date_time=%~t0
SET __SCRIPT_script_file_size=%~z0

:: Script command
SET "__SCRIPT_command=%__SCRIPT_script_file_name% %*"

:: Report level
SET __SYSTEM_report_level=_REPORT_ERROR_

:: Logging
SET __SYSTEM_log_dir_path=%__SCRIPT_script_volume%%__SCRIPT_script_path%log\
SET __SYSTEM_log_master_file=%__SYSTEM_log_dir_path%master.log
SET __SYSTEM_log_file=%__SYSTEM_log_dir_path%%__SCRIPT_script_file_name%.log

:: Title
SET "__SYSTEM_command_line=%CMDCMDLINE%"
TITLE %__SCRIPT_script_file_name%

:: Execution timer
SET /A __SYSTEM_execution_timer_start=0
CALL :get_time_ms __SYSTEM_execution_timer_start

EXIT /B
:: set_framework_config
::---------------------------------------------------------------------------::

::---------------------------------------------------------------------------::
:: @method     : set_framework_config
:: @param [in] : %*  - script param string
:: @return     : no return
:: @usage      : call :set_framework_config
:: @brief      : Apply internal script settings
:: @description: Set script file description: volume, path, file name, 
::               file extention, etc.
::               Set report level, master and common log files.
::               Starts execution timer.
::---------------------------------------------------------------------------::
:MAIN
   SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

:MAIN_INIT
   CALL :set_framework_config %*
   CALL :set_script_config %*

:MAIN_BEGIN
   PAUSE
   SET __
   ECHO.

:MAIN_END
   SET /A __SYSTEM_execution_timer_finish=0
   CALL :get_time_ms __SYSTEM_execution_timer_finish
   SET /A __SYSTEM_execution_time=%__SYSTEM_execution_timer_finish% - %__SYSTEM_execution_timer_start%
   SET __string_time=
   CALL :print_timestamp %__SYSTEM_execution_time% __string_time
   ECHO Total exectution time: %__string_time%
   
   TITLE %__SYSTEM_command_line:~1,-2%
   CALL :clear_local
   
:MAIN_RETURN
   ENDLOCAL
   ECHO ON
   @GOTO :EOF
:: MAIN
::---------------------------------------------------------------------------::

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------

:clear_local
   SET __=0
   FOR /F "usebackq delims==" %%i IN (`SET __`) DO SET %%i=
EXIT /b
rem :cleanup

rem ---------------------------------------------------------------------------
rem 1 406 818 341
rem ---------------------------------------------------------------------------

:set
	SET %~1=!%~2!
EXIT /b
rem :set

:get_time_ms

set __c_time=%time%
set /a __c_full_time=360000*(1%__c_time:~0,2% - 100) + 6000*(1%__c_time:~3,2% - 100) + 100*(1%__c_time:~6,2% - 100)+(1%__c_time:~9,2% - 100)

call :set %1 __c_full_time

EXIT /b

:print_timestamp

set /a __time_stamp=%~1
set /a __t_ms=__time_stamp %% 100
set /a __time_stamp/=100
set /a __t_ss=__time_stamp %% 60
set /a __time_stamp/=60
set /a __t_mm=__time_stamp %% 60
set /a __t_hh=__time_stamp / 60

if %__t_hh% LSS 10 (set __t_hh=0!__t_hh!)
if %__t_mm% LSS 10 (set __t_mm=0!__t_mm!)
if %__t_ss% LSS 10 (set __t_ss=0!__t_ss!)
if %__t_ms% LSS 10 (set __t_ms=0!__t_ms!)

set _time_str=!__t_hh!:!__t_mm!:!__t_ss!,!__t_ms!

call :set %2 _time_str

EXIT /b

::---------------------------------------------------------------------------::
:: End Of File
::---------------------------------------------------------------------------::
:EOF