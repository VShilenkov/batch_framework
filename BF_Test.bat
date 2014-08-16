::@ECHO Off

CALL BF_Bootstrap.bat

<:%BF_Start%
REM -> %%BF_Start%%

CALL :BF.BootStrap.Include "BF_DateTime.bat"

CALL :CALL

:Main
REM -> BF_Test.Main
ECHO Hello BF!
REM <- BF_Test.Main
EXIT /B

:CALL 

   ECHO We testing call wrapper

EXIT /B 0
