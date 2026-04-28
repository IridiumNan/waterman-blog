+++
date = '2026-04-28T18:52:25+08:00'
draft = true
title = 'Static_ip_addr'
+++

# 静态ip地址的配置方法

> 这里使用debian作为演示

主要有三个步骤:

- 连接上网络, ssh 连接
- 配置interfaces并启用
- 禁用 NetworkManager产生的动态ip (可选)

## 连接网络
>
> 按照正常的安装流程安装时候, 有一个进行镜像选择的环节， 推荐使用上海交大的或者清华大学的

- 下载 openssh-server

> 注意这一步之前必须先配置镜像， 如果安装的时候没有配置， 可以查看这个网址进行配置
[清华大学debian镜像配置](https://mirrors.tuna.tsinghua.edu.cn/help/debian/)<br>

```bash
# 安装 openssh-server
sudo apt update && sudo apt install openssh-server -y

# 开启sshd 
sudo systemctl enable --now sshd #  通常安装之后会自动打开， 为了以防万一还是开一下
sudo systemctl status sshd # 如果是 active(running) 就是正常的

# 查看 局域网的ip地址
ip a 
```

- 看懂输出的ip地址

> 一般输出会类似这种

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether b8:6b:23:13:e8:c8 brd ff:ff:ff:ff:ff:ff
3: wlp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether ac:2b:6e:cb:01:29 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.32/24 brd 192.168.1.255 scope global dynamic noprefixroute wlp2s0
       valid_lft 7181sec preferred_lft 7181sec
    inet6 2408:8248:6000:c130:cdad:aab1:bd0f:c7b8/64 scope global temporary dynamic 
```

> **lo是本地回环**(就是自己跟本机通信的网络)对应的网卡<br>
> **enp0s25是有线网卡**， 这里的输出中是 DOWN 的状态， 说明没有连接网线<br>
> **wlp2s0是无线网卡**， 这里有 ipv4 的ip (192.168.1.32) 和 ipv6 的ip (2408:8248:6000:c130:cdad:aab1:bd0f:c7b8), 我们记住这个ipv4的ip, 等下用这个来连接

- 将你自己创建的用户 (安装的时候创建的用户, 比如说 liu)加入到sudo用户组里面， 确保拥有超级管理员权限

```bash
# 这个时候先使用root用户(物理真机登陆root)

usermod -aG sudo liu #  这里的liu替换成你实际创建的用户

```

- 使用自己的另一个有桌面的笔记本连接(操作比较方便)

```bash
# 打开另外一个linux操作系统(windows我也不会搞)

# 我这里用192.168.1.32来演示， 替换成你实际的ipv4, 用户名替换为你安装的时候创建的用户名
ssh 你的用户名@192.168.1.32
```

- 改写配置文件 (/etc/network/interfaces)

```bash
# 用nano编辑器打开， 或者你会用vi的话也可以用vi
sudo nano /etc/network/interfaces
```

```context
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug wlp2s0
iface wlp2s0 inet dhcp
```

> 一般会看到这种配置， 我们改成如下配置

```context
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
# 这个是原来的， 选择注释或者删除
#allow-hotplug wlp2s0
#iface wlp2s0 inet dhcp

auto wlp2s0
iface wlp2s0 inet static
# 原动态 IP: 192.168.1.32/24 → 同网段
    address 192.168.1.100   # 最后一位改成一个未使用的数字
# 把最后一位改成1, 表示网关
    gateway 192.168.1.1
# 这个是子网掩码, 如果你的 ipv4 显示的是 192.168.xx.xx/24 -> 填255.255.255.0, 如果是 192.168.xx.xx/16 -> 填 255.255.0.0
    netmask 255.255.255.0
# 这个是dns服务器， 这里使用阿里的
    dns-nameservers 223.5.5.5
```

- 下一步就是重新启动网络服务

```bash
sudo systemctl restart networking
# 这里建议在真实机器上操作， 不然会卡一下 (ssh可能中断)
# 如果连接断开， 过几秒时候尝试重新连接， 如果连接失败， 在物理真机上操作
```

- 如果你不需要动态ip的话， 可以接着禁用NetworkManger (动态ip地址获取)

> 注意这里的wlp2s0换成你自己的网卡名称, 还有ip也是， 换成你自己之前自动获取的ipv4地址

```bash
# 禁用可能冲突的服务
sudo systemctl disable --now NetworkManager 2>/dev/null   # 如果未安装会报错，忽略
sudo systemctl disable --now dhcpcd 2>/dev/null
sudo systemctl disable --now systemd-networkd 2>/dev/null

# 1. 杀死所有 dhclient/dhcpcd
sudo pkill -f dhclient
sudo pkill -f dhcpcd

# 2. 手动删除动态 IP
sudo ip addr del <你之前看到的动态IP>/24 dev wlp2s0

# 3. 重启 networking 服务（确保它不会重新触发 dhcp）
sudo systemctl restart networking

# 4. 检查 IP 地址
ip a show wlp2s0
# 确保 ifupdown (networking) 是唯一的管理者
sudo systemctl enable networking
sudo systemctl restart networking
```

- 查看结果

```bash
ip a
```

> 如果顺利的话， 会显示像下面这样的输出

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: wlp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:2e:e0:b6 brd ff:ff:ff:ff:ff:ff
    altname enx5254002ee0b6
    inet 192.168.1.100/24 brd 192.168.1.255 scope global wlp2s0
       valid_lft forever preferred_lft forever
```

这里的 forever 就是静态ip的意思， 已经配置成功了
