+++
date = '2026-09-09T23:00:28+08:00'
draft = true
title = 'Jupyter Server'
+++

# Jupyter Notebook Server 配置

当我们拥有一台游戏本和一个轻薄本的时候, 我们就可以使用 轻薄本作为客户端。游戏本作为服务端，把机器学习的训练都放到长期在线的 服务端上.

这个时候我们可以使用 `jupyter notebook` 来暴露服务。
当然可以使用其他的方式，如果你会用 nvim 之类的编辑器， 直接ssh上服务器编辑也可以。

我们这里简单介绍一下如何配置一个 jupyter notebook 的服务端并进行端口映射

这里我们使用 miniconda 来进行管理和环境配置, 如果你现在还不会用 conda, 可以查看 [miniconda 入门教程](https://www.waterman.xin/posts/miniconda/)

---

**以下的操作都在服务端上进行**

## 环境准备

**创建新的虚拟环境**

```bash
conda create -n notebook-env python=3.12
```

- 这里的 notebook-env 是环境的名称， 可以自定义
- python 指定版本为 3.12, 根据需求来

**激活环境**

```bash
conda activate notebook-env
```

**使用pip安装jupyter notebook**

> [!NOTE]
> 注意这里需要你可以正常访问 pipy 的源， 国内可使用清华大学的镜像源或者中科大的

```bash
pip install jupyter notebook
```

---

## 启动服务

```bash
mkdir my-notebook && cd my-notebook

jupyter notebook --no-browser --port=8080
```

---

## 配置端口映射

这个时候服务端已经就绪了
**接下来在客户端进行操作**

```bash
ssh -Nf -L 8080:localhost:8080 <user>@<server_host>
```

- 这里将 user 替换成你ssh登录服务器的用户
- 然后 server_host 换成你的服务器的 host 或者 ip地址 (客户端可以访问到的)

比如说我的服务器的 ip 地址是 `100.120.83.34` ， 然后用户是 demo

```bash
ssh -Nf -L 8080:localhost:8080 demo@100.120.83.34
```

这个命令的作用是将 demo@100.120.83.34 这个机器的 localhost:8080 映射到客户端的 8080 端口

**接下来我们在客户端访问 localhost:8080, 就相当于访问服务端的 localhost:8080**
也就是服务端监听 jupyter notebook 的端口

---

## 登录

访问之后需要在右上角填入认证 token, 这个在 服务端的这里进行复制即可

在服务端启动之后， 会出现类似这样的信息

```bash
[I 2026-09-09 20:27:29.839 ServerApp] http://localhost:8080/tree?token=60e243dfde91bb70689f9a31115c17084d164da65db98771
[I 2026-09-09 20:27:29.839 ServerApp]     http://127.0.0.1:8080/tree?token=60e243dfde91bb70689f9a31115c17084d164da65db98771
```

我们看到 token=... 这一段， 把等号后面的 tocken 复制一下然后填入就行了

这里就是复制 `60e243dfde91bb70689f9a31115c17084d164da65db98771` 这一串

这个时候就可以正常使用 notebook 了
至于 notebook 如何使用，不是本帖子的目的 😃
祝你配置顺利
