@if [%~1] EQU [debug] (@echo on) else (@echo off)


:Main

call :f_name "param_name_1=1" "param_name_2=" "b=string with spaces call :f_name <a>"  "return_ref=__rrr" 
echo in main
set __
:Main_INIT

:Main_BEGIN

:Main_END

:Main_RETURN
goto :eof

::---------------------------------------------------------------------------::
:: @method     : f_name
:: @param [in] : param_name[=default_value] 
:: @return     : return_code | return_status | description
:: @usage      : 
:: @brief      : 
:: @description: 
::---------------------------------------------------------------------------::

:f_name
   ::Open scope
   SETLOCAL EnableDelayedExpansion EnableExtensions
   
   ::Declare return codes
   SET /A __RETURN_SUCCESS=0
   SET /A __RETURN_UNKNOWN=1
   
   ::Return variable
   SET /A __RETURN=%__RETURN_UNKNOWN%
   
   ::Result variable
   SET __RESULT=default_result
   
   ::Declare function name
   SET __f_name=f_name
   
   ::Declare parameters counters
   SET /A __f_param_count=0
   SET /A __f_param_max_count=3
   
   ::Declare parameter(s)
   SET    __p_name_1=param_name_1
   SET    __p_name_2=param_name_2
   SET    __p_name_3=param_name_3
   
   SET /A __p_found_1=0
   SET /A __p_found_2=0
   SET /A __p_found_3=0
   
   SET /A __p_mandatory_1=1
   SET /A __p_mandatory_2=1
   SET /A __p_mandatory_3=0
   
   SET    __p_value_3=param_default_value
      
   ::Declare result variable(s)
   SET __r_name=return_ref
   SET __r_value=__f_name_result
   
   ::Validate parameter(s)
   FOR %%i IN (%*) DO (
      
      SET /A __f_param_count = !__f_param_count! + 1
      SET /A __found=0
      
      FOR /f "delims==; tokens=1,*" %%j IN ("%%~i") DO (
         SET __p_name=%%~j
         SET __p_value="%%~k"
      )
      
      IF [!__p_name!] EQU [] (
      
         echo Empty 1
         
      ) ELSE (
         
         IF [!__p_value!] EQU [""] (
         
            echo Empty 2
            
         ) 
            
         IF /I [!__p_name!] EQU [return_ref] (
         
         FOR %%p IN (!__p_value!) DO (SET __r_value=%%~p)
         SET /A __found=1
         
         ) ELSE (
            
            FOR /L %%t IN (1,1,%__f_param_max_count%) DO (
            
               SET __lp_name=!__p_name_%%t!
               SET __lp_value=__p_value_%%t
               SET __lp_found=__p_found_%%t
               
               IF /I [!__lp_name!] EQU [!__p_name!] (
                  SET !__lp_value!=!__p_value!
                  SET /A !__lp_found!=1
                  SET /A __found=1
               )
               
            )
         
         )
         
      )
      
      IF NOT [!__found!] EQU [1] (echo Unknown !__p_name!)
   )
   
   FOR /L %%t IN (1,1,%__f_param_max_count%) DO (
      SET __lp_name=!__p_name_%%t!
      SET __lp_value=!__p_value_%%t!
      SET __lp_found=!__p_found_%%t!
      SET __lp_mandatory=!__p_mandatory_%%t!
      
      echo !__lp_name!
      echo !__lp_value!
      echo !__lp_found!
      echo !__lp_mandatory!
      
      IF [!__lp_mandatory!] EQU [1] IF [!__lp_found!] EQU [0] (ECHO Scipped mandotory !__lp_name!)
   )
   set __
   
:f_name_INIT
   ::rem Initialise local variables
   
:f_name_BEGIN
   ::rem Functionality
   
:f_name_END
   ::rem Clear local variables
   
:f_name_RETURN
   ::rem Close scope
   ::rem Return result
   ::rem Exit with return code
   ENDLOCAL                            ^
      &  (SET %__r_value%=%__RESULT%)  ^
      &  (EXIT /B %__RETURN%)
   
::---------------------------------------------------------------------------::