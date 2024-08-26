@echo off
chcp 65001 >nul
title 更新流氓软件黑名单
cd /d "%~dp0"

echo 正在使用 Gitee 更新黑名单...
wscript.exe -e:vbs Data\Gitee更新名单.vbs

SoftCnKiller.exe
exit
