@echo off
REM 后续命令使用的是：UTF-8编码
chcp 65001
color 0A
 
echo ===========Start to copy data===========
:start
cls
echo.请输入要关闭的端口号？
set /p my_port=
echo.你输入的端口号是：%my_port%
echo 开始关闭执行脚本！！！！！！！！！！！！！！
 
@echo off&setlocal EnableDelayedExpansion 
set Port=
set Dstport=%my_port%
 
for /F "usebackq skip=4 tokens=2,5" %%a in (`"netstat -ano -p tcp"`) do (  
  for /F "tokens=2 delims=:" %%k in ("%%a") do (  
    set  Port=%%k  
  )  
  echo !Port! %%b >>portandpid.txt  
)  
for /F "tokens=2 delims=:" %%c in ("%1") do (  
    set  Port=%%c  
  )  
for /F "tokens=1,2 delims= " %%d in (portandpid.txt) do (  
    echo %%d   
    echo %Dstport%  
    if %%d == %Dstport% taskkill /f /pid %%e  
  )  
del portandpid.txt    
set Port=  
set Dstport=  
goto :eof  
 
echo '结束了'
 
 
pause
===============================代码结束===================================