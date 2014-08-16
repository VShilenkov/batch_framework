@echo off
set prompt=#
for %%a in (1) do (
  echo on
  for %%b in (2) do rem ## %*
) > temp
@echo off
prompt
echo ---
type temp