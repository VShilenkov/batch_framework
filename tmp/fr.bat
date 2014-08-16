@ECHO off
rem ---------------------------------------------------------------------------
rem @script_name
rem @file_name
rem @author
rem @date
rem @brief
rem @description
rem ---------------------------------------------------------------------------

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------
SET __SCRIPT_script_full_path_name_ext=%~f0
SET __SCRIPT_script_volume=%~d0
SET __SCRIPT_script_path=%~p0
SET __SCRIPT_script_file_name=%~n0
SET __SCRIPT_script_file_ext=%~x0
SET __SCRIPT_script_short_path_name_ext=%~s0
SET __SCRIPT_script_file_attribute=%~a0
SET __SCRIPT_script_file_date_time=%~t0
SET __SCRIPT_script_file_size=%~z0

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------
SET __SCRIPT_param_1=%~1
SET __SCRIPT_param_2=%~2
SET __SCRIPT_param_3=%~3
SET __SCRIPT_param_4=%~4
SET __SCRIPT_param_5=%~5
SET __SCRIPT_param_5=%~5
SET __SCRIPT_param_6=%~6
SET __SCRIPT_param_7=%~7
SET __SCRIPT_param_8=%~8
SET __SCRIPT_param_9=%~9

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------
SET __SYSTEM_report_level=_REPORT_ERROR_
SET __SYSTEM_log_dir_path=%__SCRIPT_script_path%log\

GOTO :main

:set_script_config

EXIT /b

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------

:main

set __

GOTO :exit
rem :main

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------

:cleanup
   SET __=0
   FOR /F "usebackq delims==" %%i IN (`SET __`) DO SET %%i=
EXIT /b
rem :cleanup

rem ---------------------------------------------------------------------------
rem 
rem ---------------------------------------------------------------------------

:set
	SET %~1=!%~2!
EXIT /b
rem :set


:exit
   CALL :cleanup
   ENDLOCAL
rem :exit