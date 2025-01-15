# k8s中master无法访问NodePort，普通节点可以

我的是ens33下有两个ip: 

移除不想要的ip（不是我们设置的静态ip）：

## **临时（重启后失效）：**

**sudo ip addr del 192.168.87.132/24 dev ens33**

**# 删除所有pod让他们再创建**

**kubectl delete pods --all --all-namespaces**

## **永久（不要dhcp）：**

**sudo vi /etc/sysconfig/network-scripts/ifcfg-ens33**

**# 确保BOOTPROTO=none ,原值是dhcp**

**sed -i '/^BOOTPROTO=/d' /etc/sysconfig/network-scripts/ifcfg-ens33 && echo 'BOOTPROTO=none' >> /etc/sysconfig/network-scripts/ifcfg-ens33**

**# 执行下面这个命令就会发现没有了那个动态ip了，只有我们设置的静态ip了**

**sudo systemctl restart network**

**# 重启各节点机器，如果还不行执行下面命令 删除所有pod让他们再创建**

**kubectl delete pods --all --all-namespaces**
