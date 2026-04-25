# nginx + tailscale funnel 一键配置

只需要一个命令, **可以把nginx监听的80端口流量全部代理到公网上**

> nginx 配置 (监听80端口 -> 本地 http://localhost:80/)

```nginx
server {
	listen 80; # 有这一行就不需要调整
	listen [::]:80;

	server_name example.com;

	root /var/www/example.com;
	index index.html;

	location / {
        root /var/www/html;
        index index.html index.htm index.
        #
	}
}
```


> tailsacale 配置

```bash
sudo tailscale funnel --bg --set-path / http://localhost:80
```

这条命令由几个关键部分组成：

    tailscale funnel：核心指令，通知 Tailscale 创建一个从公网到你本地服务的加密隧道，并提供一个以 ts.net 结尾的固定域名

- --bg：后台运行。加上它，关闭命令行窗口后服务也不会中断

- --set-path /：设置访问路径为根路径 /。这意味着访问你的域名时，流量会被直接转发到后端服务，而不添加任何子路径

- http://localhost:80：指定了流量的最终目的地，即你本地正在监听的 80 端口的 HTTP 服务


- Funnel 负责处理公网入站流量并自动完成HTTPS加密，再通过安全的隧道将请求转发给你指定的本地服务
用户访问时，只能看到 Funnel 的入口，无法感知后端服务的真实细节。
