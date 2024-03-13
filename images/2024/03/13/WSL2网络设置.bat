@echo off
chcp 65001
net session >nul 2>&1
if %errorLevel% == 0 (
    echo （1/2）脚本程序正在执行中...
) else (
    echo 需要以管理员身份运行!
    pause >nul
    exit /B
)


wsl --shutdown
wsl -d Ubuntu -u root ip addr del $(ip addr show eth0 ^| grep 'inet\b' ^| awk '{print $2}' ^| head -n 1) dev eth0
wsl -d Ubuntu -u root ip addr add 172.28.96.2/20 broadcast 192.168.50.255 dev eth0
wsl -d Ubuntu -u root ip route add 0.0.0.0/0 via 172.28.96.1 dev eth0
wsl -d Ubuntu -u root echo nameserver 172.28.96.1 ^> /etc/resolv.conf
powershell -c "Get-NetAdapter 'vEthernet (WSL)' | Get-NetIPAddress | Remove-NetIPAddress -Confirm:$False; New-NetIPAddress -IPAddress 172.28.96.1 -PrefixLength 20 -InterfaceAlias 'vEthernet (WSL)'; Get-NetNat | ? Name -Eq WSLNat | Remove-NetNat -Confirm:$False; New-NetNat -Name WSLNat -InternalIPInterfaceAddressPrefix 172.28.96.0/20;"

echo (2/2)等待3秒钟后执行启动WSL...
for /l %%i in (3,-1,1) do (
    echo 倒计时: %%i
    ping -n 2 127.0.0.1 > nul
)
start  wsl -d Ubuntu &

exit