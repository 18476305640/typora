@ echo off
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin


wsl --shutdown
wsl -d Ubuntu -u root ip addr del $(ip addr show eth0 ^| grep 'inet\b' ^| awk '{print $2}' ^| head -n 1) dev eth0
wsl -d Ubuntu -u root ip addr add 172.28.96.2/20 broadcast 192.168.50.255 dev eth0
wsl -d Ubuntu -u root ip route add 0.0.0.0/0 via 172.28.96.1 dev eth0
wsl -d Ubuntu -u root echo nameserver 172.28.96.1 ^> /etc/resolv.conf
powershell -c "Get-NetAdapter 'vEthernet (WSL)' | Get-NetIPAddress | Remove-NetIPAddress -Confirm:$False; New-NetIPAddress -IPAddress 172.28.96.1 -PrefixLength 20 -InterfaceAlias 'vEthernet (WSL)'; Get-NetNat | ? Name -Eq WSLNat | Remove-NetNat -Confirm:$False; New-NetNat -Name WSLNat -InternalIPInterfaceAddressPrefix 172.28.96.0/20;"
start  wsl -d Ubuntu &

exit