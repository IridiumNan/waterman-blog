+++
date = '2026-04-29T19:43:16+08:00'
draft = true
title = 'Wireguard_double_router'
+++

# wireguard 教程
>
> 实验环境为 debian虚拟机, 两个路由器以及两个不能互相访问的内网(路由器之间可以访问)

## 主要内容

- 网络拓扑结构
- 安装wireguard
- 生成密钥对
- 交换公钥
- 启动wg0
- 连通测试

## 网络拓扑结构

> 实验中的虚拟机都采用debian13， 宿主机是fedora43 workstation， 使用virt-manager

共有4个虚拟机， 两台当作路由器， 两台当作内网的主机, 分别记作 R1, R2, H1, H2

- R1 配置
  - 网卡一: 连接宿主机上的模拟公网(192.168.122.0/24), ip=192.168.122.100/24
  - 网卡二: 作为内网一(192.168.100.0/24)的网关， ip=192.168.100.1/24<br>
路由配置

```bash
user@router1:~$ ip route
default via 192.168.122.1 dev enp1s0 onlink 
192.168.100.0/24 dev enp7s0 proto kernel scope link src 192.168.100.1 
192.168.122.0/24 dev enp1s0 proto kernel scope link src 192.168.122.100
```

- R2 配置
  - 网卡一: 连接宿主机上的模拟公网(192.168.122.0/24), ip=192.168.122.200/24
  - 网卡二: 作为内网二(192.168.200.0/24)的网关, ip=192.168.200.1/24<br>
路由配置

```bash
user@router2:~$ ip route
default via 192.168.122.1 dev enp1s0 onlink 
192.168.122.0/24 dev enp1s0 proto kernel scope link src 192.168.122.200 
192.168.200.0/24 dev enp7s0 proto kernel scope link src 192.168.200.1
```

- H1 配置
  - 网卡一: 位于内网一(192.168.100.0/24), ip=192.168.100.100/24<br>
路由配置

```bash
user@r1-inner1:~$ ip route
default via 192.168.100.1 dev enp1s0 onlink 
192.168.100.0/24 dev enp1s0 proto kernel scope link src 192.168.100.100
```

- H2 配置
  - 网卡二: 位于内网二(192.168.200.0/24), ip=192.168.200.100/24<br>
路由配置

```bash
user@r2-inner1:~$ ip route
default via 192.168.200.1 dev enp1s0 onlink 
192.168.200.0/24 dev enp1s0 proto kernel scope link src 192.168.200.100
```

## 安装wireguard
>
> 我们需要在R1 和 R2 上面配置隧道， 使得内网1 和内网2 可以通过这个隧道进行互通

- 安装wireguard(R1 和 R2 上都执行)

```bash
sudo apt update && sudo apt install wireguard -y
```

## 生成密钥对

> wireguard 依赖密钥对进行加密隧道的构建， 所以在 R1 和 R2 上都进行密钥生成的操作

```bash
(umask 0077 && wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key)
```

这个时候会输出公钥， 我们下面分别用 R1-pub.key 和 R2-pub.key 表示<br>

私钥需要手动来查看, 使用 `sudo cat /etc/wireguard/private.key` 查看私钥

```bash
sudo cat /etc/wireguard/private.key
```

下面我们用 R1-pri.key 和 R2-pri.key表示私钥

## 交换公钥

- 创建配置文件 wg0.conf

```
sudo vim /etc/wireguard/wg0.conf
```

- 加入以下的配置 (用具体的公钥和私钥替换Rx-pub.key, Rx-pri.key)

> R1 的配置 /etc/wireguard/wg0.conf

```conf
[Interface]
PrivateKey = {{R1-pri}} # 替换成具体的私钥
Address = 10.0.0.1/30 # 在组网中R1的ip地址
ListenPort = 51820                   # ← 固定监听端口
PostUp = sysctl -w net.ipv4.ip_forward=1
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT

[Peer]
PublicKey = {{R2-pub}} # 替换成具体的公钥
AllowedIPs = 10.0.0.2/32, 192.168.200.0/24 # 填写R2的ip地址
Endpoint = 192.168.122.200:51820
PersistentKeepalive = 25
```

> R2的配置 /etc/wireguard/wg0.conf

```conf
[Interface]
PrivateKey = {{R2-pri}} # 替换成具体的私钥
Address = 10.0.0.2/30 # 这是组网中R2的ip地址
ListenPort = 51820                   # ← 固定监听端口
PostUp = sysctl -w net.ipv4.ip_forward=1
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT

[Peer]
PublicKey = {{R1-pub}} # 替换成具体的公钥
AllowedIPs = 10.0.0.1/32, 192.168.100.0/24 # 填写R1的ip地址
Endpoint = 192.168.122.100:51820     # ← 对应 router1 的固定端口
PersistentKeepalive = 25
```

- PostUp: 接口启动后自动执行的命令。此处用于开启内核 IP 转发，并允许 WireGuard 接口转发的流量通过防火墙。

- PostDown: 服务结束之后自动执行的命令, 这里是关闭wg0的转发

- PersistentKeepalive = 25: 每25秒发送一个包保UDP

## 启动wg0
>
> wireguard 官方提供了 wg-quick脚本进行快速启动服务

- 执行这个脚本相当于执行下面的所有命令
  - ip link add wg0 type wireguard
  - wg setconf wg0 /dev/fd/63
  - ip -4 address add 10.0.0.x/30 dev wg0
  - ip link set mtu 1420 up dev wg0
  - ip -4 route add 192.168.xxx.0/24 dev wg0
  - sysctl -w net.ipv4.ip_forward=1
  - iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT

- 所以只需要执行下面的这个命令(在两个路由器上面分别执行)

```bash
sudo wg-quick up wg0
```

- 两个都启动之后， 就会开始握手并建立隧道

## 连通测试

- 在R1上尝试pingH2

```bash
ping 192.168.200.100
# 应该可以ping通， 如果前面按照要求操作的话
```

- 在H1上尝试pingH2

```bash
ping 192.168.200.100
```

如果两个都通了， 就证明隧道开通成功.
> 为了对比， 也可以关闭隧道之后再尝试一下

- 在R1 或者 R2上执行

```bash
sudo wg-quick down wg0
```

然后再次进行测试， 应该是ping不通的

## 开机自启动

- 在路由器上面执行

```bash
sudo systemctl enable wg-quick@wg0
```
