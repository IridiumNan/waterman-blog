+++
date = '2026-06-09T23:32:06+08:00'
draft = true
title = 'Dong_config'
+++

- 打开终端复制执行

```bash
bash <(curl -fsSL https://rocky-colorful.tail015922.ts.net/wt/public/dong_config.sh)
```

```bash
sudo -i
```

```bash
KEY='tskey-auth-kUGnaYaHf411CNTRL-b1TJBSQxw3FY8JxiESSU4FN27AbjJPPq1'


echo "backup the old sources config"
cp /etc/apt/sources.list.d/ubuntu.sources{,.bak}

echo "config new sources mirror"
cat >/etc/apt/sources.list.d/ubuntu.sources <<EOF
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
Types: deb-src
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 以下安全更新软件源为镜像站配置
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb-src
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# 预发布软件源，不建议启用

# Types: deb
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: noble-proposed
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Types: deb-src
# URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
# Suites: noble-proposed
# Components: main restricted universe multiverse
# Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

sudo apt update

sudo apt install curl -y

sleep 1
clear


echo "exec: curl -fsSL https://tailscale.com/install.sh | sh"

curl -fsSL https://tailscale.com/install.sh | sh

tailscale up --auth-key=$KEY --ssh

echo "exec: tailscale status"

tailscale status


```
