+++
date = '2026-04-21T23:08:50+08:00'
draft = true
title = 'Tailscale_nginx_https_config'
+++

# nginx + tailscale + https 配置教程

## 清理apache2(如有)

```bash
sudo systemctl stop apache2
sudo apt remove apache2
sudo apt autoremove
```

## 安装nginx 并启动

```bash
sudo apt update && sudo apt install nginx -y
sudo systemctl enable --now nginx
sudo systemctl status nginx
```

## 申请tailscale https 证书

> 需要先在tailscale的后台的dns界面enable https

> 然后在机器上面申请证书

```bash
sudo tailscale cert \
--cert-file /etc/ssl/certs/你的设备名.你的tailnet名.ts.net.crt \
--key-file /etc/ssl/private/你的设备名.你的tailnet名.ts.net.key \
你的设备名.你的tailnet名.ts.net
```

> 这里的 --cert-file 后面跟着公钥的目标地址, --key-file 后面跟着私钥的目标地址

### 一定要把私钥的权限设置为 600

```bash
sudo chmod 600 /etc/ssl/private/你的设备名.你的tailnet名.ts.net.key
```

## 接下来配置站点文件

> 先创建然后打开编辑

```bash
sudo touch /etc/nginx/sites-available/tailscale
sudo vim /etc/nginx/sites-available/tailscale
```

> 然后粘贴下面的内容并对必要的部分进行修改
> 主要修改的部分:

- 将mydevice.example.ts.net  换成完整域名， 例如 debian.tailb69be3.ts.net
- 配置一下私钥和公钥的地址     
  - ssl_certificate     /etc/ssl/certs/mydevice.example.ts.net.crt;
  - ssl_certificate_key /etc/ssl/private/mydevice.example.ts.net.key;

```nginx
# 文件路径: /etc/nginx/sites-available/tailscale
# 假设你的 Tailscale 设备名为 "mydevice"，tailnet 名为 "example.ts.net"
# 则完整域名为: mydevice.example.ts.net

# ------------------------------------------------------------
# 1. HTTP 服务：将所有请求重定向到 HTTPS
# ------------------------------------------------------------
server {
    listen 80;
    listen [::]:80;                     # 支持 IPv6
    server_name mydevice.example.ts.net;  # 请修改为你的 Tailscale 域名

    # 可选：如果需要处理 Let's Encrypt 验证等特殊路径，可以单独放行
    # location ^~ /.well-known/acme-challenge/ {
    #     root /var/www/html;
    # }

    # 所有其他请求永久重定向到 HTTPS 的相同 URI
    return 301 https://$host$request_uri;
}

# ------------------------------------------------------------
# 2. HTTPS 服务：提供网站内容或反向代理
# ------------------------------------------------------------
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name mydevice.example.ts.net;  # 请修改为你的 Tailscale 域名
    http2 on;

    # ---------- SSL 证书配置 ----------
    # 使用 tailscale cert 命令生成的证书路径（请修改）
    ssl_certificate     /etc/ssl/certs/mydevice.example.ts.net.crt;
    ssl_certificate_key /etc/ssl/private/mydevice.example.ts.net.key;

    # 强化的 SSL 配置（推荐）
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;
    ssl_session_timeout 1d;
    ssl_session_cache shared:MozSSL:10m;

    # ---------- 安全头（可选但推荐） ----------
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;

    # ---------- 静态网站配置（按需修改） ----------
    root /var/www/html;   # 请修改为实际的网站根目录
    index index.html index.htm;

    # ---------- 通用 location 处理 ----------
    location / {
        try_files $uri $uri/ =404;           # 先尝试文件，找不到返回 404
    }

    # ---------- 可选：反向代理到本地后端（如果你需要代理，请取消注释并注释掉上面的 location /） ----------
    # location / {
    #     proxy_pass http://127.0.0.1:8080;            # 请修改为你的后端地址
    #     proxy_http_version 1.1;
    #     proxy_set_header Upgrade $http_upgrade;
    #     proxy_set_header Connection "upgrade";
    #     proxy_set_header Host $host;
    #     proxy_set_header X-Real-IP $remote_addr;
    #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #     proxy_set_header X-Forwarded-Proto $scheme;
    # }

    # ---------- 静态资源缓存（优化性能） ----------
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff2?|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    # ---------- 访问限制（可选，仅允许 Tailscale 内网访问） ----------
    # 注意：Tailscale 证书本身已是私有网络认证，如需额外限制可启用以下配置
    # allow 100.64.0.0/10;   # Tailscale 使用的 CGNAT 地址段
    # deny all;
}
```

> 启用站点 (使用软链接)

```bash
sudo ln -sf /etc/nginx/sites-available/tailscale /etc/nginx/sites-enabled/
```

> 然后检查是否有错误并重载nginx

```bash
sudo nginx -t && sudo systemctl reload nginx
```

## 访问测试

随便放一个index.html 文件在 /var/www/html/ 路径下， 并更改权限

```bash
sudo mv index.html /var/www/html/
sudo chown www-data:www-data /var/www/html/index.html
```

> 或者可以放目录

```bash
sudo mv dist /var/www/html/
sudo chown www-data:www-data -R /var/www/html/dist
```

然后就可以通过https://mydevice.example.ts.net/ 来访问你的这个机器了， 静态http网页的配置就全部结束了
使用https://mydevice.example.ts.net/dist/来访问这个目录(如果有index.html会优先访问)
