+++
date = '2026-09-01T09:38:23+08:00'
draft = true
title = 'Pandoc_beginner'
+++

# Pandoc Beginner

[pandoc](https://pandoc.org/) 是一个极其强大的文件类型转化软件
可以非常方便的让文档在各种格式之间互相转换

本篇介绍安装和 `md`, `html`, `docx` 的转换方法

## 安装

- 在 ubuntu 里面一般就叫做 `pandoc`

```bash
sudo apt install pandoc -y
```

- 在 fedora 里面叫做 `pandoc-cli`

```bash
sudo dnf install pandoc-cli -y
```

---

## 基础使用

> 注意这里的 pandoc 版本是 `3.7.0.2` 如果有变动请以官方文档为准

pandoc 会自动通过文件名的后缀来决定转化的格式
使用起来非常方便
只有一些特殊情况才需要手动指定 (实际上文件名的后缀已经包含了格式的信息)
需要注意的是， 转化出来的 html 一般只包含 <body></body> 部分， 你可以自己指定样式， 以及解决语言差异而导致的字符问题

一般我们需要手动添加或者使用程序添加这样的一个结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <title>Document Title</title>
        <style>
                /* 在这里添加你的 CSS 样式 */
        </style>
    </head>

    <body>
        <main>
            这里是 pandoc 转换出来的内容
        </main>
    </body>
</html>
```

- markdown 转 html

```bash
pandoc -o output.html input.md
```

- docx 转 html

> [!NOTE]
> 注意这里如果你的 `docx` 文件当中有插入的图片， 需要添加一个参数
> --extract-media=<path>

```bash
# 一般来说直接用这个
pandoc -o output.html input.docx --extract-media=.

# 如果你希望手动指定目录 (注意这里是嵌套)
# pandoc -o output.html input.docx --extract-media=./images
```

如果这个 path 填写的是 . (也就是当前目录的意思)， pandoc 就会将 docx 文件内部嵌入的图片提取出来放到 ./media 这个目录下， 命名例如 media/image1.jpeg, 然后在 html 里面会自动引用这个路径， 保证图片可以正常的显示。
在上面的第二个例子当中， 我们会获得一个新的嵌套目录 `image/media/`, 然后提取出来的照片就会保存在这个 image/media/ 目录下

也就是说 在原来的基础上加上 `--extract-media=.` is all you need

---
