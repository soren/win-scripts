@echo off
call perl6 %~dpn0.p6 %~dpn0.sel
for /f %%d in (%~dpn0.sel) do cd "%%d"
