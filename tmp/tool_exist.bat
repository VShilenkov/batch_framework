@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

rem echo %~dp0 %1 %2 %3

goto :main

:set_framework_settings
set __report_level=_REPORT_ERRORS_
set __script_path=%~d0

:main

set tool_name=%~1
if "%tool_name%"=="" set tool_name=cmd
call :exist_tool %tool_name%
if "%return_exist_tool_result%"=="1" (
   call :get_file_name_ext %return_exist_tool_path%
   if defined _r_get_file_name_ext ( 
      echo !_r_get_file_name_ext! 
      echo %return_exist_tool_path%
   )
)

goto :exit

:set
	set %~1=!%~2!
goto :eof

:print_msg_param_missing

   set __f_name=print_msg_param_missing
   set __f_usage_msg=Usage: call :%__f_name% param_function_name param_param_name param_usage_description

   set __p_function_name=%~1
   set __p_param_name=%~2
   set __p_usage_description=%~3
   
   if defined __report_level if "%__report_level%"=="_REPORT_ERRORS_" (
      if not "%__p_function_name%"=="" (
         echo Error: %__p_function_name%

         echo.
         echo Description: missing argument %__p_param_name%
         
         if not "%__p_usage_description%"=="" (
            echo.
            echo %__p_usage_description%
         )
      ) else (
         echo Error: %__f_name%
         echo.
         echo Description: missing argument param_function_name
         echo.
         echo %__f_usage_msg%
      )
   )
   
   set __f_name=
   set __f_usage_msg=
   set __p_function_name=
   set __p_param_name=
   set __p_usage_description=
   
goto :eof

:get_file_name_ext

   set __f_name=get_file_name_ext
   set __f_usage_msg="Usage: call :%__f_name% filename [_ret_value_name]"
   
   set __p_filename=%~1
   set __r_return=%~2

   if "%__p_filename%"=="" (
      call :print_msg_param_missing %__f_name% filename %__f_usage_msg%
   )
   
   if "%__r_return%"=="" ( set __r_return=_r_get_file_name_ext )
   
   set _file_name_ext=
   
   for /d %%i in ("%__p_filename%") do (
      set _file_name_ext=%%~nxi
   )
   
   call :set !__r_return! _file_name_ext

   set __f_name=
   set __f_usage_msg=
   set __p_filename=
   set __r_return=
   set _file_name_ext=

rem :get_file_name_ext   
goto :eof

:exist_tool

   set __f_name=exist_tool

set tool=%1
set found=0
set tool_path=
set filelist=

if "%tool%"=="" exit /b

set return_exist_tool_result=
set return_exist_tool_path=

for %%E in (%PATHEXT%) do set filelist="%tool%%%E" !filelist!

for %%F in (%filelist%) do (
	set fullpath=%%~$PATH:F
	if not "!fullpath!"=="" (
		set found=1
		set tool_path=!fullpath! !tool_path!
	)
)

set return_exist_tool_result=!found!
set return_exist_tool_path=!tool_path!

goto :eof


:exit
ENDLOCAL