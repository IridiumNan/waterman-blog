+++
date = '2026-05-05T13:17:29+08:00'
draft = true
title = 'Config Oh My Tmux'
+++

# Oh-my-tmux

> 打包好了常用的 Oh-my-tmux 配置， 可以用脚本一键配置 不需要翻墙

- 如果你还没有下载 `tmux`

```bash
sudo apt install tmux -y # debian 系 用 apt
```

- 然后使用脚本配置即可

```bash
bash <(curl -fsSL https://repo.waterman.xin/configs/tmux/config.sh)
```

---

## 快捷键说明

`tmux` 当中有一个非常重要的东西就是 `prefix`， 你需要先按 `prefix` 才能进行分屏， 新开窗口等操作

原生 `tmux` 的 `prefix` 是 同时按 `ctrl` 和 `b`， 也就是 `C-b`, 这对我来说比较麻烦

所以我改成了 `C-x` 也就是 同时 `ctrl` 和 `x` 作为 `prefix`

---

## 常用操作

### 进入tmux之前

- 创建名为 `test-session` 的会话

```bash
tmux new -s test-session
```

- 进入一个已有的会话

```bash
tmux a -t test-session

# 也支持前缀匹配
# tmux a -t te
```

### 进入 tmux 内部的操作

> [!NOTE]
> `prefix` -> `"` 表示先按 prefix 之后松开， 再按 `"`
> 等价于 `ctrl`, `x` -> `"`

- 上下分屏

`prefix` -> `"`

这是官方的默认配置

- 左右分屏

`prefix` -> `%`

- 退出会话(这个会话不会消失， 可以再次进入, 进程也会继续执行)

`prefix` -> `d`

- 创建新的窗口

`prefix` -> `c`

- 切换窗口

`prefix` -> `ID`

这里的 ID 看下面的编号, 从 1 开始

- 预览多个窗口 (支持切换)

`prefix` -> `w`

关闭窗口使用 `exit` 命令即可
