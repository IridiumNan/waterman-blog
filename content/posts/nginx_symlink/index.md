+++
date = '2026-09-01T08:54:08+08:00'
draft = true
title = 'Nginx_symlink'
+++

# Nginx Symlink

在 Linux 里面， 软链接是非常重要的功能， 可以非常方便地控制页面的动态发布和审核。
而 `nginx` 是一个非常常用的高性能网页文件服务器， 在 nginx 使用软链接暴露页面就非常实用。

但是 `nginx` 有时候不允许软链接的直接访问，可以通过 [stack overflow](https://stackoverflow.com/questions/12624358/nginx-not-following-symlinks?__cf_chl_tk=S0q4naAVR7.5MWGYRouoHcxmKDp..Nhh3SDFLfzIqbA-1788223379-1.0.1.1-RRuyhyKaYb3OP7Q67usu_njr4KpXaXqIdxFFc.bHlac)当中的方法进行操作

这里简要介绍一下解决方案

- 演示使用的 nginx 版本为 version: nginx/1.24.0 (Ubuntu)

```conf
server {
 listen 80 default_server;
 listen [::]:80 default_server;

 root /var/www/public;

 disable_symlinks off;

 # Add index.php to the list if you are using PHP
 index index.html index.htm index.nginx-debian.html;


 location / {
  # First attempt to serve request as file, then
  # as directory, then fall back to displaying a 404.
  try_files $uri $uri/ =404;
  }
}
```

**关键就是添加一行** `disable_symlinks off;`

表示允许软链接的访问， 这个时候 **软链接目录和软链接文件** 都可以被直接访问和暴露
