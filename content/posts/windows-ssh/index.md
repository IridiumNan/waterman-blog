+++
date = '2026-08-15T19:32:17+08:00'
draft = true
title = 'Windwos Ssh'
+++


# SSH

在 Linux 中， 远程操控服务器是基本操作，这个时候，就需要使用 `ssh` 这个工具。

具体的概念和介绍参考[百度百科](https://baike.baidu.com/item/%E5%AE%89%E5%85%A8%E5%A4%96%E5%A3%B3%E5%8D%8F%E8%AE%AE)或[Wikipedia](https://zh.wikipedia.org/zh-hans/Secure_Shell)。

很多 Windows 用户可能有**连接 Linux 虚拟机**进行实验的需求，
以及人工智能专业的同学可能需要 **使用云端服务器来进行模型的训练**

所以我在这里简单介绍一下如何在 Windows 下使用 ssh 命令远程连接虚拟机或者服务器。

## 前置条件

Windows客户端和被连接的Linux**必须满足下面的条件之一**：

- 处于同一个网络下(内网穿透也可)
- Linux 服务器有公网ip，并且windows可以正常上网

> 一般虚拟机就是在宿主机拉起的虚拟网络中， 所以可以直接连接。

## 安装

- 首先使用 win + r ， 然后输入cmd
- 按住 ctrl + shift 然后回车打开管理员的命令提示符

- 之后使用 `winget` 来安装 ssh 客户端

```cmd
winget install Microsoft.OpenSSH.Beta
```

- 检验是否安装成功

```cmd
ssh -V
```

## 查看Linux端信息

如果你是虚拟机，打开虚拟机内部的终端 (一般叫做Terminal)：

```bash
user@hostname:~$ 
# 开启之后会看到这个， 叫做命令提示符， @ 前面的就是用户名
# 然后你输入的命令会出现在 $ 右侧
```

查看 `ip` 地址：

```bash
ip a

```

参考输出讲解：

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 52:54:00:0d:46:77 brd ff:ff:ff:ff:ff:ff
    altname enx5254000d4677
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:21:7d:76 brd ff:ff:ff:ff:ff:ff
    altname enx525400217d76
    inet 192.168.200.2/24 brd 192.168.200.255 scope global enp7s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe21:7d76/64 scope link proto kernel_ll 
       valid_lft forever preferred_lft forever
```

我们先找到**状态为UP**的网卡， 也就是显示 state UP 的卡， 这里是 `lo` 以及 `enp7s0`

- `lo`: 本地回环， 用于这个机器内部自己的通信， 无法跟外界通信，所以我们不使用这个网络接口连接
- `enp7s0`: 有线网卡,可以与同一网络下的机器通信，我们将使用这个接口进行 ssh 连接

下一步是找到我们目标网卡的 inet 这一行，在这里的例子中是：

```
inet 192.168.200.2/24 brd 192.168.200.255 scope global enp7s0
```

这里的 192.168.200.2 就是对应的ip地址， 至于后面的 /24 表示子网掩码，这里不需要管。

然后我们记住这个ip地址(当然你可以后面返回来看)。

## 进行连接

下面的操作就是在你的 cmd 或者 powershell 当中运行(也就是windows)
我们刚才已经拿到了两个信息：

- 用户名: 也就是 @ 前面的那个
- ip地址: 也就是 3 个点分割的ipv4 (一般 192开头)

我们现在使用这两个信息进行ssh连接，语法是：

```shell
ssh 用户名@ip地址
```

举个例子：

```shell
ssh cabin@192.168.200.2
```

表示我要使用ssh登陆 192.168.200.2 对应的主机的 cabin 这个账户。

## 测试

当你看到出现了类似这种提示符， 就代表连接成功了。

```shell
cabin@linux-handbook:~$
```

接下来你可以试着跟linux打个招呼。

```bash
echo hello linux
# 输出 hello linux
```

然后如果需要推出的话， 可以使用 `exit` 命令。

当然Windows用户更习惯关掉命令行， 因为不常用haha。
