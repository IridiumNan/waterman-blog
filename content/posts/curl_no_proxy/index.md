+++
date = '2026-10-07T21:00:15+08:00'
draft = true
title = 'Curl_no_proxy'
+++

# 配置 curl 无代理模式

在 Linux 上使用代理上网的时候， 本机和虚拟机之间的调试可能会遇到各种问题

特别是使用 `curl` 进行各种 API 调试的时候

大量的问题都是代理干扰了流量包的正常路由， 所以我们可以通过对 curl 进行配置来永久性的解决

## 命令行参数

```bash
curl "http://127.0.0.1:8081/" -v

# output
* Uses proxy env variable http_proxy == 'http://192.168.122.1:7890'
*   Trying 192.168.122.1:7890...
* Established connection to 192.168.122.1 (192.168.122.1 port 7890) from 192.168.122.211 port 49018 
* using HTTP/1.x
> GET http://127.0.0.1:8081/ HTTP/1.1
> Host: 127.0.0.1:8081
> User-Agent: curl/8.18.0
> Accept: */*
> Proxy-Connection: Keep-Alive
> 
* Request completely sent off
< HTTP/1.1 502 Bad Gateway
< Connection: keep-alive
< Keep-Alive: timeout=4
< Proxy-Connection: keep-alive
< Content-Length: 0
< 
* Connection #0 to host 192.168.122.1:7890 left intact
```

在这种配置代理(特别是非本机的代理) 之后, 流量被直接劫持， 原本要发往本机的8081端口的请求被重定向到 代理服务器的 8081 端口

解决方案就是添加一个 `--noproxy` 参数， 后面跟上请求对应的地址或者域名

```bash
curl "http://127.0.0.1:8081/" -v --noproxy 127.0.0.1/8

#output
*   Trying 127.0.0.1:8081...
* Established connection to 127.0.0.1 (127.0.0.1 port 8081) from 127.0.0.1 port 49840 
* using HTTP/1.x
> GET / HTTP/1.1
> Host: 127.0.0.1:8081
> User-Agent: curl/8.18.0
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< Date: Wed, 07 Oct 2026 13:13:49 GMT
< Content-Length: 27
< Content-Type: text/plain; charset=utf-8
< 
* Connection #0 to host 127.0.0.1:8081 left intact
hello this is root endpoint%
```

这样发往这个 地址的 流量包会绕过代理。我们看到最后得到了本机的回复 hello this is root endpoint

> [!NOTE]
> 当然这样的方法局限性也非常明显  
> 就是每次调试都需要多加参数  
> 对于像我这样的懒人非常不友好
> 于是我就去 curl 的 man 手册寻找解决方案

## 配置文件

> [!NOTE]
> 也可以通过 man curl 自行查看相关的内容

curl会按照顺序读取下列的配置文件

1) "$CURL_HOME/.curlrc"

2) "$XDG_CONFIG_HOME/curlrc" (Added in 7.73.0)

3) "$HOME/.curlrc"

4) Windows: "%USERPROFILE%\.curlrc"

5) Windows: "%APPDATA%\.curlrc"

6) Windows: "%USERPROFILE%\Application Data\.curlrc"

7) Non-Windows: use getpwuid to find the home directory

8) On Windows, if it finds no .curlrc file in the sequence  described  above,  it

我个人是直接放在家目录的， 也就是 `~/.curlrc`, 根据个人喜好配置吧

接下来介绍如何配置

`curlrc` 文件配置非常容易， 核心就是 key = value

直接由命令行的参数转换而成

比如说  `--noproxy 127.0.0.1/8` 就对应 `noproxy = "127.0.0.1/8"`

官方给了个案例

```rc
# --- Example file ---
# this is a comment
url = "example.com"
output = "curlhere.html"
user-agent = "superagent/1.0"

# and fetch another URL too
url = "example.com/docs/manpage.html"
-O
referer = "http://nowhereatall.example.com/"
# --- End of example file ---

```

而我们要对特定的子网区域禁用代理， 只需要做如下的配置

```rc
# 不同的区域使用 , 隔开， 支持 /24 等子网掩码后缀
# 根据自己的需要来进行配置
noproxy = "127.0.0.1/8,192.168.122.0/24"
```

然后就是自己本机起一个服务来进行测试

```bash
curl "http://127.0.0.1:8081/" -v

# output
Note: Read config file from '/home/cai/.curlrc'
*   Trying 127.0.0.1:8081...
* Established connection to 127.0.0.1 (127.0.0.1 port 8081) from 127.0.0.1 port 59412 
* using HTTP/1.x
> GET / HTTP/1.1
> Host: 127.0.0.1:8081
> User-Agent: curl/8.18.0
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< Date: Wed, 07 Oct 2026 13:25:15 GMT
< Content-Length: 27
< Content-Type: text/plain; charset=utf-8
< 
* Connection #0 to host 127.0.0.1:8081 left intact
hello this is root endpoint%
```

我们会看到第一行会有一个输出 Read config file from 配置文件的位置

然后后面就是直接连接目的 url

我们也顺利得到了期望的输出

希望这个帖子可以帮助到你
