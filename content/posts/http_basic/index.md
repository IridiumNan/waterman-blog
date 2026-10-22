+++
date = '2026-10-22T15:23:43+08:00'
draft = true
title = 'Http_basic'
+++

# HTTP 协议

这里对 http 的请求和响应做最简单的介绍

HTTP 协议是一种应用层的协议。在传输层基于 tcp 或者 加密的 tcp 协议 来保证数据的准确性。

HTTP 预设的通信架构为 C/S 也就是 Client-Server 架构。

一般来说， 用户使用浏览器作为客户端， 服务端接收用户发送的请求并且返回请求的资源 （也可能是对服务器上的数据进行修改）

## 核心内容

## HTTP 报文

一个典型的 HTTP 交互分为 **请求(Request)** 和 **响应(Response)** 两个部分

### HTTP 请求

一个典型的请求包含以下的关键要素

- HTTP Method: Http 方法， 用于指定客户端的意图(获取， 创建， 删除等)
- Scheme: 协议类型， 正规网站是 `https`, 本地开发可能是 `http`
- Host: 服务器的域名或者 Socket (就是ip地址加上对应端口)
- HTTP Version: 协议的版本 (HTTP/1.1, HTTP/2 等)
- Path: 请求的目标资源路径
- Header: 请求头, **包含多个 Key-Value 的键值对**。 用来传输一些附加的数据。当然前提是可以方便地使用键值对表达
- Body: 数据的主体内容, **纯字节流**， 浏览器通过 Header 当中的 `Content-Type` 字段来分辨数据的类型并进行相应的解析

### HTTP 响应

服务端返回的 Response 包括

- Status Code & Status Message: 状态码和状态信息, 用来说明这次 HTTP 交互的状况 (如 `200 OK`, `404 Not Found`)
- Header: 响应头, 也是携带 多个键值对的附加信息
- Body: 响应的主题数据

---

## 核心要素

### HTTP Method

HTTP 请求包含不同的方法, 分别代表客户端不同的目的

- GET

这是最常用的方法， 直接向服务端请求资源, 它是 safe 的方法， 因为它不改变服务端的状态

并且 GET 方法一般不允许包含 Body

- POST

用来在服务器上创建新的资源

- PUT

用来替代服务器上已有的资源

- PATCH

用来更新服务器上已有资源的一部分

- DELETE

删除服务器上的资源

- HEAD

跟 GET 类似， 向服务端请求资源。但是要求响应不包含有 Body

可以用来 *试探* 这个资源是否有变化， 大小为多少, 因为我们可以根据 Header 当中的信息进行推断

### 状态码

在服务器返回的 response 当中， 会包含 `status code` 和 `status message`

也就是状态码和状态的信息

最常见的状态码就是 200 和 404, 前者表示 OK, 后者表示 Not Found

状态码的值表示不同的含义

| code | status |
| -- | -- |
| `100` - `199` | 信息 |
| `200` - `299` | 成功 |
| `300` - `399` | 重定向 |
| `400` - `499` | 客户端错误 |
| `500` - `599` | 服务端错误 |

### Header

Client 请求当中的 Header 一般会包含以下字段

- User-Agent

并不是我们手动指定请求的各部分内容之后手动发送， 而是浏览器帮我们自动处理。所以为了 ~~表彰浏览器的贡献~~ 让服务端知道我们使用的浏览器和操作系统等环境， 使得他们返回兼容性更好的数据，正常渲染出页面。 所以一般浏览器都会添加这个字段

- Accept

可以接收到数据类型

- Referer

这个资源是由上一级别的资源引用的 (可能是 html 或者调用的脚本)

...

另外， 还有一些字段是专门用来做认证的

比如说 Cookie 或者 Authorization x-read-token 等等

这就是一个典型的 Header

```http
Host: developer.mozilla.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:158.0) Gecko/20100101 Firefox/158.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.9
Accept-Encoding: gzip, deflate, br, zstd
Referer: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers
Sec-GPC: 1
Connection: keep-alive
Cookie: _ga_R3H4BDP5J2=GS2.1.s1787801349$o1$g1*************6$j60$l0$h0; _ga=GA1.*************887801349; _ga_B9CY1C9VBC=GS2.1.*****************91462311$j60$l0$h0
Upgrade-Insecure-Requests: 1
Sec-Fetch-Dest: document
Sec-Fetch-Mode: navigate
Sec-Fetch-Site: same-origin
Sec-Fetch-User: ?1
Priority: u=0, i
Pragma: no-cache
Cache-Control: no-cache
```

Server 响应的 Header 一般会包含以下关键字段

- Content-Type

Body 当中的数据类型

这是一个比较简单的 Response Header

```http
Access-Control-Allow-Origin: *
Connection: Keep-Alive
Content-Encoding: gzip
Content-Type: text/html; charset=utf-8
Date: Mon, 18 Jul 2016 16:06:00 GMT
ETag: "c561c68d0ba92bbeb8b0f612a9199f722e3a621a"
Keep-Alive: timeout=5, max=997
Last-Modified: Mon, 18 Jul 2016 02:36:04 GMT
Server: Apache
Set-Cookie: my-key=my value; expires=Mon, 17-Jul-2017 16:06:00 GMT; Max-Age=31449600; Path=/; secure
Transfer-Encoding: chunked
Vary: Cookie, Accept-Encoding
X-Backend-Server: developer2.webapp.scl3.mozilla.com
X-Cache-Info: not cacheable; meta data too large
X-kuma-revision: 1085259
x-frame-options: DENY
```

### Content-Type

前后端基于 `Content-Type` 进行相应的数据处理.

文本类型的数据

- `text/html` HTML 文档
- `text/plain` 纯文本
- `text/css` CSS 样式
- `text/javascript` js 脚本
- `text/markdown` markdown 文件

图片类

- `image/png` png 图片
- `image/jpeg` jpeg 图片

应用类

- `application/json` json 文件
- `multipart/form-data` 多部分的表单 (基于特定的分隔符来分隔各个部分的内容)
- `application/x-www-form-urlencoded` URL 编码方式 形如 key=value&key=value

在 header 当中， Content-Type 的语法是

Content-Type: `<media-type>`; xx=xxx

> [!NOTE]
> 比如
> content-type text/html; charset=utf-8

后方可以添加键值对属性

- `charset` 编码方式， 比如说 utf-8

- `boundary` body 当中不同部分的分隔符, 见于 `multipart/form-data`
