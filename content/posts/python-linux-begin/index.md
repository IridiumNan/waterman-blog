+++
date = '2026-08-15T19:32:01+08:00'
draft = true
title = 'Python Linux Begin'
+++

# Python

## 安装 Python

Linux 上装Python还是非常轻松的，因为不用装，大部分发行版自带。

Linux 里面一般都是 `python3`。
如果你想要用 `python` 这个命令， 可以装一个 `python-is-python3`, 来用软链接骗过操作系统(开个玩笑)。

- Debian: `sudo apt install python-is-python3 -y`
- Fedora: `sudo dnf install python-is-python3 -y`

## 编写第一个脚本

- 创建一个脚本

```bash
touch hello.py
```

- 写入内容

```bash
echo "print('hello python')" > hello.py
```

- 查看内容

```bash
cat hello.py

# 会输出
# print('hello python')
```

## 运行

有很多Windows来的同志不知道怎么运行，但实际上非常简单。

用法:

```bash
# python <要运行的脚本路径>

python hello.py
```

这样你就成功运行起 Python 脚本了。
实际上就是给 Python 指定需要运行的文件， 就这么简单。

恭喜你在Linux上成功运行了Python脚本。

## 编辑器

- 如果你使用WSL, 推荐使用 VSCode 的 WSL 插件来连接写代码, 当然勇敢牛牛可以尝试 LazyVim 写代码
- 如果你使用原生 Linux, 还是这两种推荐haha

VSCode 资料很多， 我也用的比较少，可以直接上Bilibili搜索VSCode Python环境搭建
[LazyVim入坑视频](https://www.bilibili.com/video/BV1TJCvYFE2T?t=286.5)
