+++
date = '2026-04-21T19:36:14+08:00'
draft = true
title = 'Hugo_usage'
image = './pictures/cover.png'
+++

## Hugo 介绍

> hugo 是一个轻量化的静态网页生成工具, 自动读取你的markdwon文件并生成对应的静态文件

### 作用

- 写个人 blog
- 记笔记
- 记录项目 (当然可以附上访问链接)
- 记录一些容易忘记却又经常用到的小知识

### 用法

1. 先下载hugo

```bash
# 从官方的网址拉取最新版 (推荐, 当然可以使用包管理器)
wget https://github.com/gohugoio/hugo/releases/download/v0.160.1/hugo_extended_0.160.1_linux-amd64.tar.gz

# 解压到你放应用的地方
# 我这里就在家目录里面创建一个 .applications
mkdir -p ~/.applications
tar xzvf hugo_extended_0.160.1_linux-amd64.tar.gz

# 解压之后会出三个东西
# hugo
# README.md
# LICENSE
# 这里的hugo就是可执行文件， 把这个拿了就行
mv hogo ~/.applications/

# 然后软链接到环境变量里面的目录 (我这里用 /usr/local/bin)
ln -s ~/.applications/hugo /usr/local/bin/hugo

#这个时候用命令验证一下链接是否成功
which hogo

# 如果输出是
/usr/local/bin/hugo 就没问题了

```

2. 使用 hugo 新建一个文件夹， 会自动完成初始化

```bash
# 命名随意， 我这里用 my-blog 举例
hugo new site my-blog

# 进入文件夹
cd my-blog
```


3. 然后git初始化， 开始装主题

```bash
# 这一步是在 my-blog  目录下执行的
git init

# 安装 Stack 主题 (当然可以自己选择其他的)
git submodule add https://github.com/CaiJimmy/hugo-theme-stack.git themes/hugo-theme-stack

```
4. 删除默认的配置文件, 然后新建一个 hugo.yaml

```bash
rm hugo.toml
touch hugo.yaml

# 用vim打开编辑
vim hugo.yaml
```

> 下面的内容直接粘贴进去， 根据需要修改, 这里的目录配置可以自定义
```yaml
baseURL: /
languageCode: zh-cn
title: 我的成长与项目记录
theme: hugo-theme-stack

paginate: 5
enableInlineShortcodes: true
enableRobotsTXT: true

markup:
  goldmark:
    renderer:
      unsafe: true

outputs:
  home:
    - HTML
    - JSON

params:
  author: 你的名字
  description: 记录大学成长、项目实战、学习笔记
  defaultTheme: auto
  displayCategories: true
  displayTags: true
  search:
    enable: true

menu:
  main:
    - identifier: home
      name: 首页
      url: /
      weight: 1
    - identifier: posts
      name: 文章
      url: /posts
      weight: 2
    - identifier: projects
      name: 项目
      url: /projects
      weight: 3
    - identifier: about
      name: 关于我
      url: /about
      weight: 4
```

5. 用 hugo 创建文件并初始化
```bash
hugo new posts/index.md
# 然后就会自动在 content/posts 文件夹下创建一个 index.md
# 用vim或者其他东西打开
vim content/posts/index.md
```

6. 配置这个 index.md 开头的toml 配置
```toml
date = '2026-04-21T19:36:14+08:00'
draft = true
title = 'Hugo_usage'
image = './pictures/cover.png' 
```

> 这里的 image 是自定义的， 按照相对路径来引用就行了

7. 然后就是开启本地预览看看效果 (bash)
```bash
hugo server -D 
# 会出现一个网址， 直接打开就看到效果了
```

8. 修改成自己想要的样子之后, 就是用hugo 生成静态网页了
```bash
# 注意我们默认的配置里面有一行 draft = true

# 直接使用这个命令， draft = true 的文件会被忽略
# 在项目根目录执行 
hugo

# 如果想要把 draft = true 也包含进来, 使用 
hugo -D
```

9. 将public/文件夹拷贝到你的服务器上托管
```bash
# 假设你已经复制整个文件夹到服务器上了

# 如果你配置了 apache 或者 nginx, 默认目录在 /var/www/html/
mv public/* /var/www/html/ 

# 注意要赋予可读权限或者直接改称 www-data 所有
sudo chown www-data:www-data /var/www/html/*
```

10. 接下来访问你的域名就可以了
