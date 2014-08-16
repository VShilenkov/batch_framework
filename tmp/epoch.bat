@echo off
if [%~1] EQU [1] (@echo on)
setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

:main

set /a _TBIAS_DAYS=70*365 + 17
set /a _TBIAS_YEAR=1900

set /a _LY_M1=0
set /a _LY_M2=31
set /a _LY_M3=60
set /a _LY_M4=91
set /a _LY_M5=121
set /a _LY_M6=152
set /a _LY_M7=182
set /a _LY_M8=213
set /a _LY_M9=244
set /a _LY_M10=274
set /a _LY_M11=305
set /a _LY_M12=335

set /a _SY_M1=0
set /a _SY_M2=31
set /a _SY_M3=59
set /a _SY_M4=90
set /a _SY_M5=120
set /a _SY_M6=151
set /a _SY_M7=181
set /a _SY_M8=212
set /a _SY_M9=243
set /a _SY_M10=273
set /a _SY_M11=304
set /a _SY_M12=334

set /a t_year=2014
set /a t_month=8
set /a t_day=3
set /a t_hour=8
set /a t_min=50
set /a t_sec=57

set /a _year=t_year - _TBIAS_YEAR

::call :check_leap_year %t_year%

::IF [%__check_leap_year_result%] EQU [1] (SET _Y=_LY_M) ELSE (SET _Y=_SY_M)

::set /a _days=(_year - 1)/4 + !%_Y%%t_month%! - 1 + 365*_year + t_day - _TBIAS_DAYS

::set /a _secs=_days*86400 + t_hour*3600 + t_min*60 + t_sec

rem echo %_secs%

call :print_msg "type:error" "str:59" "func:Method" "msg:Missing parameter Year" "usage:usage" "tt: "

goto :exit

:print_msg "msg:%msg%" "type:%type%" "func:%func%" "str:%str%" "usage:%usage%" 
SETLOCAL EnableDelayedExpansion EnableExtensions


set __f_name=print_msg

set __f_p1_name=msg
set /a __f_p1_type=1
set /a __f_p1_found=0
set __f_p2_name=type
set /a __f_p2_type=0
set /a __f_p2_found=0
set __f_p3_name=func
set /a __f_p3_type=1
set /a __f_p3_found=0
set __f_p4_name=str
set /a __f_p4_type=0
set /a __f_p4_found=0
set __f_p5_name=usage
set /a __f_p5_type=0
set /a __f_p5_found=0

set __f_usage=%__f_name% %__f_p1_name%=%__f_p1_name%

set /a __f_possible_param_count=5
set /a __f_param_count=0

for %%i in (%*) do (

   set /a __f_param_count = !__f_param_count! + 1
   
   for /f "delims=:; tokens=1,2" %%j in ("%%~i") do (
      
      set /a __found=0
      
      for /l %%t in (1,1,%__f_possible_param_count%) do (
      
         set __p_name=!__f_p%%t_name!
                  
         if [%%j] EQU [!__p_name!] (
         
            set __p_val=__f_p%%t_val
            set __p_found=__f_p%%t_found
            
            if not [%%k] EQU [] (
               set !__p_val!=%%k
               set /a !__p_found!=1
            ) else (
               call :print_msg "msg:skipped value for parameter %%j" "type:WARNING" "func:%__f_name%" "str:109" "usage:%__f_usage%"
            )
            
            set /a __found=1
            
         )
         
      )
      
      if [!__found!] EQU [0] (call :print_msg "msg:unknown parameter %%j" "type:WARNING" "func:%__f_name%" "str:118" "usage:%__f_usage%")
      
      
   )
   
)

for /l %%t in (1,1,%__f_possible_param_count%) do (
   set __p_name=!__f_p%%t_name!
   set __p_type=!__f_p%%t_type!
   set __p_found=!__f_p%%t_found!
   
   if [!__p_type!] EQU [1] if [!__p_found!] EQU [0] (call :print_msg "msg:scipped mandatory parameter !__p_name!" "type:ERROR" "func:%__f_name%" "str:130" "usage:%__f_usage%")
)

set __header=

if defined __f_p2_val (
   if /i [%__f_p2_val%] EQU [error] (set __header=ERROR)
   if /i [%__f_p2_val%] EQU [critical] (set __header=CRITICAL ERROR)
   if /i [%__f_p2_val%] EQU [warning] (set __header=WARNING)
   if /i [%__f_p2_val%] EQU [note] (set __header=NOTE)
   if /i [%__f_p2_val%] EQU [info] (set __header=INFO)
   
   if defined __f_p3_val ( set __header=!__header! in function: %__f_p3_val%)
)
if defined __header (echo %__header%)
if defined __f_p4_val (set __f_p1_val=[!__f_p4_val!]: !__f_p1_val!)
echo.!__f_p1_val!
if defined __f_p3_val if defined __f_p5_val (echo Usage: %__f_p5_val%)
echo.----

endlocal

exit /b 0

::---------------------------------------------------------------------------::
:: @method     : check_leap_year
:: @param [in] : [m] year       | int    | no default value         | Year to check
:: @param [out]: [o] return_ref | string | __check_leap_year_result | Name of value reference for result : 1 - Year is leap, 0 - otherwise
:: @return     : 0 | PASSED | 
:: @return     : 1 | FAILED | Unknown.
:: @return     : 2 | FAILED | Missed parameter year.
:: @usage      : CALL :check_leap_year %year% %__is_leap%
:: @usage      : CALL :check_leap_year %year%
:: @brief      : Determine if the param %year% is a leap year or not.
:: @description: 
::---------------------------------------------------------------------------::

:check_leap_year "year=%year%" ["return_ref=%return_ref%=__check_leap_year_result]
   rem Open scope
   SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
   
   rem Return and Result values
   SET /A __RETURN=1
   SET /A __RESULT=0
   
   rem Determine function specifications
   SET __f_name=check_leap_year
   
   SET __p_name=year
   SET /A __p_val=%~1
     
   SET __r_name=return_ref
   SET __r_val=%~2
   SET __r_def=__check_leap_year_result
   
   SET __f_usage_msg=call :%__f_name% %__p_name% [%__r_name%=%__r_def%]
   
   rem Validate parameter(s)
   IF [%__r_val%] EQU [] (SET __r_val=%__r_def%)
   
   IF [%__p_val%] EQU [] (
      SET /A __RETURN=2
      ECHO. Missed parameter %__p_name%
      ECHO. Usage: %__f_usage_msg%
      GOTO :check_leap_year_RETURN
   )
      
:check_leap_year_INIT
   rem Initialise local variables
   SET /A __check_004 = __p_val %% 4
   SET /A __check_100 = __p_val %% 100
   SET /A __check_400 = __p_val %% 400
   
:check_leap_year_BEGIN
   rem Functionality
   IF [%__check_400%] EQU [0] (SET /A __RESULT=1) ELSE (
      IF [%__check_100%] EQU [0] (SET /A __RESULT=0) ELSE (
         IF [%__check_004%] EQU [0] (SET /A __RESULT=1) ELSE (SET /A __RESULT=0)
      )
   )
   
:check_leap_year_END
   rem Clear local variables
   SET __f_name=
   SET __p_name=
   SET __p_val=
   SET __r_name=
   SET __r_def=
   SET __f_usage_msg=
   SET __check_004=
   SET __check_100=
   SET __check_400=
   
   rem Define Correct Return value
   SET __RETURN=0
   
:check_leap_year_RETURN
   ENDLOCAL                         ^
      &  (SET %__r_val%=%__RESULT%) ^
      &  (EXIT /B %__RETURN%)
   
::---------------------------------------------------------------------------::

:exit
ENDLOCAL