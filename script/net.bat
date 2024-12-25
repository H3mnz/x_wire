@echo off

:loop
    netsh interface ip show subinterfaces %1
    timeout 5 >nul
    cls
goto loop