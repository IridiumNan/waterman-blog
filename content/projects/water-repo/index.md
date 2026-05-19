+++
date = '2026-05-19T20:57:59+08:00'
draft = true
title = 'Water Repo'
+++

# water-repo (wt)

## 仓库

- 权威仓库: [github](https://github.com/IridiumNan/wt)
- 国内访问推荐用: [gitee](https://gitee.com/cai-zixiang_hainan/wt)

## 适合谁

- 有一个服务器和一个日常使用的开发本
- 没有非常复杂的权限管理需求
- 觉得 `python -m http.server` 功能太简陋， 需要一些其他的扩展功能
- 不想配置复杂的重型仓库
- 服务器通过 类似 `tailnet` 或者其他的vpn以及内网进行访问

## 为什么适合

- 个人使用， 配置3分钟 -> 后续无需再配置
- 扁平化标签管理， 没有任何的认知负担
- 打造自己的 `wt` 仓库 (一个可以操作的 `apt` 包管理器)
- 配合 `tailscale` 内网安全进行 CLI 仓库管理
- 零依赖，低占用

## 快速上手教程

- 首先是安装 `wt` 最新版 -> 可以上仓库下载或者直接命令行从我的私人网站下载

```bash
# 下载最新版 linux
wget https://repo.waterman.xin/apps/water-repo/wt-lastest-linux-amd64

# 下载最新版 macOS
curl -LO https://repo.waterman.xin/apps/water-repo/wt-lastest-darwin-arm64

# 下载最新版 Windows
curl -O https://repo.waterman.xin/apps/water-repo/wt-lastest-windows-amd64.exe
```

- 然后看视频操作

- 配置环境变量(Linux)<br>

如果你使用bash

```bash
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
mkdir -p ~/.local/bin && mv wt-lastest-linux-amd64 ~/.local/bin/wt
source ~/.bashrc
```

如果你使用zsh

```bash
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc
mkdir -p ~/.local/bin && mv wt-lastest-linux-amd64 ~/.local/bin/wt
source ~/.zshrc
```
