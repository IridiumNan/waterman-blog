+++
date = '2026-04-28T20:33:30+08:00'
draft = true
title = 'Ssh Key'
+++

# ssh密钥配置教程 (自定义多个密钥)

操作步骤

- 生成密钥并指定保存文件
- 将公钥拷贝到远程服务器上
- 修改配置文件

## 生成密钥并指定保存文件

> 当我们有多个服务器的时候， 就应该使用自定义的名称和路径来区别管理

```bash
ssh-keygen -t ed25519 -C "virtual debian inner1 key" -f ~/.ssh/virt_debian_inner1_rsa
```

> 参数说明

- `-t` 指定算法， 无脑填ed25519就行
- `-C` 给密钥添加一个注释， 会追加到公钥文件的末尾， 方便管理员识别, 自行定义
- `-f` 指定密钥保存的路径, 这里指定为 ~/.ssh/virt_debian_inner1_rsa， 就会生成两个文件, **这个路径也是自定义的**
  - 私钥 `~/.ssh/virt_debian_inner1_rsa` 一定不要泄露
  - 公钥 `~/.ssh/virt_debian_inner1_rsa.pub` 这个是要传输到服务器上面的

## 将公钥拷贝到远程服务器上

```bash
# 命令就是
# ssh-copy-id -i /path/to/your_custom_key.pub username@remote_host

# 对于上面的例子， 即为
ssh-copy-id -i ~/.ssh/virt_debian_inner1_rsa.pub user@ip # 这里的user和ip根据你的目标来填写

# 然后输入密码就行了
```

## 修改配置文件

> ssh 的配置文件是 ~/.ssh/config, 如果没有就新建， 会自动读取

```bash
nano ~/.ssh/config # 用编辑器打开配置文件进行修改
```

```config
Host myserver
    HostName 192.168.1.100
    User ubuntu
    IdentityFile ~/.ssh/virt_debian_inner1_rsa 
```

- Host 写一个你自己容易记住和识别这个机器的用途的， 比如 myserver 表示我自己的服务器之类的
- HostName 填ip地址
- User 就是你登陆的账户是什么
- IdentityFile 指向你的**私钥**， **跟刚才传过去的配置文件是对应的**

## 测试
>
> 接下来就是优雅的免密码登录

```bash
# ssh user@HostName

ssh ubuntu@myserver #  根据你实际的配置进行更改
```
