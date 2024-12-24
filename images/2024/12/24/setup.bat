@echo off

:: 获取当前批处理文件所在的目录路径
set script_dir=%~dp0

:: 将bin目录添加到系统环境变量PATH中
setx PATH "%PATH%;%script_dir%bin"

:: 停止MySQL服务
net stop mysql

:: 删除data目录
rd /s /q "%script_dir%data"

:: 删除已安装的MySQL服务
%script_dir%bin\mysqld.exe -remove

:: 初始化MySQL数据库
%script_dir%bin\mysqld.exe --initialize --console

:: 安装MySQL服务
%script_dir%bin\mysqld.exe --install

:: 启动MySQL服务
net start mysql

:: 输出分隔线
echo ===============================================
echo HIGHLIIGHT: 1. Enter temporary password to log in !
echo HIGHLIIGHT: 2. ALTER USER 'root'@'localhost' IDENTIFIED BY "<your-password>";
echo ===============================================

:: 启动MySQL客户端
%script_dir%bin\mysql.exe -uroot -p
