+++
date = '2026-04-28T22:21:21+08:00'
draft = true
title = 'Dns_debian_fix'
+++

# 修复debian的dns解析错误

- 有时候配置网络的时候， 总是会不小心改掉默认的配置， 导致dns解析出错， 所有网址都访问不了

> 所以这里给出极简的修复方案， 适用于 debian13

- 手动修改配置文件

```bash
# 编辑 resolv.conf 文件
sudo vim /etc/resolv.conf
```

- 添加下面的内容

```conf
nameserver 223.5.5.5
nameserver 223.6.6.6
```

- 重启一下网络

```bash
sudo systemctl restart networking
```

- 测试一下

```bash
ping baidu.com
```

正常返回pong就是恢复正常了
