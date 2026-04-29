+++
date = '2026-04-29T23:02:29+08:00'
draft = true
title = 'Lazyvim_config'
+++

# lazyvim 配置
>
> lazyvim 是 neovim 的一个插件， 可以大大提升使用体验

## 主要步骤

- 从仓库拉取 neovim (新版)
- 配置路径
- 从仓库拉取lazyvim的配置压缩包
- 拉取字体并配置
- nvim启动!!!

## 拉取neovim

- 如果你可以科学上网

```bash
wget https://github.com/neovim/neovim/releases/download/v0.12.2/nvim-linux-x86_64.appimage
```

- 如果你在我的tailnet里面

```bash
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/nvim-linux-x86_64.appimage
```

- 如果你上面两条路都走不通(需要直接从dnf仓库或者提供很新的软件包的包管理器上下载)

```bash
# fedora43
sudo dnf install neovim -y
```

## 配置路径

```bash
mkdir -p ~/.applications
# 把刚才下载到的appimage包放到 ~/.applications 里面统一管理
mv nvim-linux-x86_64.appimage ~/.applications/

# 然后软链接到 /usr/local/bin/ 让所有的用户都可以使用nvim

sudo ln -s ~/.applications/nvim-linux-x86_64.appimage /usr/local/bin/nvim

# 这个时候可以先启动尝试一下
nvim

# 要退出使用 :q
```

## 从仓库拉取lazyvim的配置压缩包

> 从我的tailnet的仓库中拉取

```bash
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/temp_share/nvim-config.tar.gz

# 然后解压到家目录
tar xzvf nvim-config.tar.gz -C ~

# 启动看一下效果， 应该会有图标显示出问题
nvim
```

## 配置 Nerd Font

> 从我的tailnet仓库中获取font.zip

```bash
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/font.zip

# 创建一个目录来放这些字体， 然后解压
mkdir -p ~/Nerd-Font
mv font.zip ~/Nerd-Font

sudo apt install unzip -y # 安装解压工具

cd ~/Nerd-Font

unzip font.zip
```

然后会出现很多ttf文件，选择三个带Mono的字体下载(Mono是每一个字母一样宽的， 代码看着才正常)<br>
具体是这三个:

- 0xProtoNerdFontMono-Bold.ttf
- 0xProtoNerdFontMono-Italic.ttf
- 0xProtoNerdFontMono-Regular.ttf

然后配置自己的终端字体， 改成这种就可以了

## 然后就是启动nvim

```bash
nvim
```

> 大功告成
