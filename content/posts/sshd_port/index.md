+++
date = '2026-08-26T09:40:32+08:00'
draft = true
title = 'Sshd_port'
+++

# sshd port 更改

sshd 默认运行在 22 端口， 为了增强安全性， 我们可以更改这个端口为任意我们希望的端口号
比如 10086
然后在 ssh 的时候加上 -p 10086 参数即可指定端口号登陆

- 打开配置文件 `/etc/ssh/sshd_config`

- 找到 端口配置

这些虽然被注释掉了， 但是它们是默认值， 如果没有配置来覆盖， 就会使用这些值

```conf
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

**注意，一定要先同时开两个端口试试新的端口是否可用并保留22端口**
确认没有问题了再关闭22端口

- 修改配置

```conf
Port 10086
Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```

改成这样的配置, 同时开放 10086 还有 22 端口。 **记得取消 22 端口前面的注释**

- 测试

```bash
ssh -o IdentitiesOnly=true user@server_ip -p 10086
```

如果连接失败, **请检查防火墙规则**

fedora 等rhel发行版可以通过这样的方式打开对应端口的防火墙
如果是云端的服务器请上控制台修改防火墙规则

```bash
sudo firewall-cmd --add-port=10086/tcp --permanent
sudo firewall-cmd --reload
```

确认没有问题之后， 我们将原来的 `Port 22` 这行注释掉， 然后改用新的端口连接即可

如果希望快捷登录， 不想要每次都指定 port 的话， 可以参考 [ssh 公钥配置](https://www.waterman.xin/posts/ssh-key/) 当中的内容
