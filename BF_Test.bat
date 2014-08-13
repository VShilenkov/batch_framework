::@ECHO Off

CALL BF_Bootstrap.bat

<:%BF_Start%
REM -> %%BF_Start%%

:Main
REM -> BF_Test.Main
ECHO Hello BF!
REM <- BF_Test.Main
EXIT /B
