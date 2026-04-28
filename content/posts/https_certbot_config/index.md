+++
date = '2026-04-28T19:46:04+08:00'
draft = true
title = 'Https_certbot_config'
+++

# 配置https证书(公网版)

- 要实现这个配置需要满足以下条件
  - 有公网ip
  - 有已经备案的域名
  - 会基础linux操作

> 主要有这几个步骤<br>

- 添加域名解析
- 启动nginx
- 创建网站根目录和校验专用目录
- 配置一个nginx的纯http网站
- 启动站点配置
- 测试站点是否正常工作
- 安装certbot和必要的nginx插件
- 执行certbot申请命令

## 添加域名解析
>
> 在你的域名管理界面， 把你的二级域名指向你的公网ip<br>
> 比如 demo.example.com -> 31.3.51.38

## 启动nginx

- 确保已经安装nginx并禁用掉其他的web服务(比如apache 或者 caddy)

```bash
sudo systemctl disable --now httpd
sudo systemctl disable --now caddy

sudo apt remove apache apache2
sudo apt remove caddy
```

- 然后安装nginx并启动

```bash
sudo apt update && sudo apt install nginx -y

sudo systemctl enable --now nginx

# 查看状态确认 如果显示 active(running) 就没有问题
sudo systemctl status nginx
```

- 一般nginx会自带一个网页放在 /var/www/html/ 目录下， 查看这个目录， 如果有网页文件， 先进行本机测试

```bash
ls -l /var/www/html
```

一般输出是这个:

```bash
total 4
-rw-r--r-- 1 root root 615 Apr 27 20:41 index.nginx-debian.html
```

进行测试

```bash
# 如果还没有安装curl, 需要先安装， 但是一般都已经预装了
# sudo apt update && sudo apt install curl

curl http://localhost/
```

这里对http的默认端口80进行测试， 应该会返回如下结果

```bash
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

## 创建网站根目录和校验专用目录

这里的demo.example.com 换成你自己的站点网址

```bash
# 创建站点目录
mkdir -p /var/www/demo.example.com

# certbot 校验专属目录（关键）
mkdir -p /var/www/demo.example.com/.well-known/acme-challenge

# 授权权限
chmod -R 755 /var/www/demo.example.com

```

## 编写纯http的nginx配置

```bash
vim /etc/nginx/sites-available/demo.example.com.conf
```

写入以下内容

```nginx
server {
    listen 80;
    server_name demo.example.com;

    # 网站根目录
    root /var/www/demo.example.com;
    index index.html;

    # 关键：放行 acme 校验目录，必须配置
    location /.well-known/acme-challenge/ {
        allow all;
        try_files $uri =404;
    }

    # 默认首页
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## 使用软链接启动站点

```bash
ln -s /etc/nginx/sites-available/demo.example.com.conf /etc/nginx/sites-enabled/

# 语法检查并重载nginx启动站点
sudo nginx -t
sudo systemctl reload nginx
```

## 进行测试

```bash
sudo echo "hello" | sudo tee /var/www/demo.example.com/index.html

# 用curl发送请求进行测试
curl http://demo.example.com
# 看到 hello 表示成功
```

## 安装certbot和必要的nginx插件

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

## 执行certbot申请命令

```bash
certbot --nginx -d demo.example.com
```

> certbot 会自动生成配置

```nginx
server {
    listen 443 ssl;
    server_name demo.example.com;

    ssl_certificate /etc/letsencrypt/live/demo.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/demo.example.com/privkey.pem;

    # 你的网站根目录
    root /var/www/xxx;
    index index.html;
}

# 80 端口自动跳 443
server {
    listen 80;
    server_name demo.example.com;
    return 301 https://$host$request_uri;
}
```

根据需要来进行修改
