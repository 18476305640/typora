@echo off
chcp 65001
set /p name="请输入java程序运行名称（包含即可如Application）: "
echo Searching for processes with name including '%name%'
FOR /F "tokens=1,2" %%G IN ('jps -l') DO (
    echo Processing %%H
    IF NOT "%%H"=="" (
        echo %%H|findstr /C:"%name%">nul
        if %errorlevel%==0 (
            echo Killing process with PID %%G (%%H)
            taskkill /PID %%G /F
        )
    )
)