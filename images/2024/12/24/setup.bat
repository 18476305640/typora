@echo off

:: ��ȡ��ǰ�������ļ����ڵ�Ŀ¼·��
set script_dir=%~dp0

:: ��binĿ¼��ӵ�ϵͳ��������PATH��
setx PATH "%PATH%;%script_dir%bin"

:: ֹͣMySQL����
net stop mysql

:: ɾ��dataĿ¼
rd /s /q "%script_dir%data"

:: ɾ���Ѱ�װ��MySQL����
%script_dir%bin\mysqld.exe -remove

:: ��ʼ��MySQL���ݿ�
%script_dir%bin\mysqld.exe --initialize --console

:: ��װMySQL����
%script_dir%bin\mysqld.exe --install

:: ����MySQL����
net start mysql

:: ����ָ���
echo ===============================================
echo HIGHLIIGHT: 1. Enter temporary password to log in !
echo HIGHLIIGHT: 2. ALTER USER 'root'@'localhost' IDENTIFIED BY "<your-password>";
echo ===============================================

:: ����MySQL�ͻ���
%script_dir%bin\mysql.exe -uroot -p
