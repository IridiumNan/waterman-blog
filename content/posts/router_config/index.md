+++
date = '2026-04-29T15:02:16+08:00'
draft = true
title = 'Router_config'
+++

# 使用虚拟机配置路由 (NAT)

## 主要步骤

- 虚拟机创建一个独立网络连接 (isolated-net)
- 在当作路由器的虚拟机这里新建网络， 选中这个isolated-net
- 然后创建一个虚拟机， 配置网卡的时候只连接这个isolated-net， 作为内网的设备
- 给两个设备分别配置静态ip, dns, 禁用动态ip(防止操作失败)
- 开启路由器的NAT功能和ipv4转发
- 进行测试

## 创建独立的网络

- 这里使用 virt-manager

Edit -> Connection Details -> + -> Mode (Isolated) -> Name: isolated-net -> Finish

## 创建路由器虚拟机并配置网卡

- 这里命名为router

router -> details -> Add Hardware -> Network -> source (isolated-net) -> Finish

## 创建内网的虚拟机

- 命名为 inner

inner -> 创建的时候勾选 -> customize configuration before install -> Network source (isolated-net) -> Finish

## 配置静态ip, 禁用掉动态ip, 以及dns手动配置

- [静态ip](https://www.waterman.xin/posts/static_ip_addr/)

> 注意， 这里配置静态ip的时候建议把其他无关的内容都禁用了， 防止出现问题, 也就是把动态ip禁用

- [dns配置](https://www.waterman.xin/posts/dns_debian_fix/)

## 开启路由器的ipv4转发和NAT

> 下面的操作在当作路由器的虚拟机上面进行

- 开启 ipv4 转发

> 这里分为两种情况

1. 有 /etc/sysctl.conf

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.conf

# 启动配置
suod sysctl -p
```

1. 没有 /etc/sysctl.conf

```bash
# 新创建一个配置文件 放在 /etc/sysctl.d/ 目录下
sudo touch /etc/sysctl.conf
sudo touch /etc/sysctl.d/99-sysctl.conf

echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-sysctl.conf

#启动配置
sudo sysctl -p
```

- 设置NAT

> 首先查看默认的网络接口 (在路由器上执行)

```bash
ip route show default
```

> 输出如果是 `default via 192.168.122.1 dev enp1s0 onlink` 则网络接口就是 `enp1s0`

> 添加 MASQUERADE 规则

```bash
# 如果没有预装 iptables 
# sudo apt install iptables -y

sudo iptables -t nat -A POSTROUTING -o enp1s0 -j MASQUERADE
```

> 允许流量转发

```bash
sudo iptables -P FORWARD ACCEPT
```

> 持久化 iptables 规则 (保证重启依旧有效)

```bash
sudo apt update
sudo apt install iptables-persistent -y
sudo netfilter-persistent save
```

> 配置内网主机的gateway

```bash
sudo vi /etc/network/interfaces
```

打开配置文件

找到 `gateway xx.xx.xx.xx` 这一行， 把后面的ipv4改成路由器的ip

```bash
# 重启使得网络配置生效
sudo systemctl restart networking
```

- 测试(在内网主机上)

```bash
traceroute baidu.com
```

```bash
# 看到下面的这种有 _gateway的输出就没有问题了
traceroute to baidu.com (111.63.65.247), 30 hops max, 60 byte packets                                                                     
 1  _gateway (192.168.200.1)  1.491 ms  1.392 ms  1.345 ms

```

> 如果失败了， 最好的办法就是重启， 让路由器重新加载配置, 成功率大大提高哦
