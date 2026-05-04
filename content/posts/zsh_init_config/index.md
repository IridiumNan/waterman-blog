+++
date = '2026-04-29T22:38:29+08:00'
draft = true
title = 'Zsh_init_config'
+++

# zsh 配置插件

## 主要步骤

- 下载zsh
- 从仓库拉取插件压缩包和配置文件
- 启动zsh
- 设置为默认终端

## 下载zsh
>
> 根据自己的包管理器下载zsh

```bash
# dedbian系用apt
sudo apt update && sudo apt install zsh -y

# 红帽系用 dnf/yum
sudo dnf update && sudo dnf install zsh -y

# ...arch
```

## 拉取插件压缩包和配置文件
>
> 插件的压缩包我已经打包好了， 直接从仓库拉取

```bash
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/zsh-config.tar.gz

# 然后直接解压到家目录
tar xzf zsh-config.tar.gz -C ~
```

> 然后是拉取配置文件, zsh的配置文件是 ~/.zshrc 需要相应的配置文件来激活主题和插件

```bash
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/dot_zshrc

# 把配置文件放到指定的位置
mv dot_zshrc ~/.zshrc
```

## 启动zsh

```bash
zsh
```

> 注意这里可能会跳出一个 git status, 直接 ctrl+C 中断， 但是每次还是会加载， 所以需要改一下配置文件

```bash
echo "typeset -g POWERLEVEL9K_DISABLE_GITSTATUS=true" | tee -a ~/.p10k.zsh
```

> 这个命令会禁用gitstatus的检查， 然后直接exit退出zsh, 之后重新启动就不会有问题了

## 设置为默认终端

```bash
chsh -s $(which zsh)
```

> 执行完这个命令之后输入你的密码， 然后重新开一个终端， 默认终端就是zsh了
