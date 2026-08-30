+++
date = '2026-08-30T21:36:26+08:00'
draft = true
title = 'Journalctl'
+++

# 最常用的 Journalctl 命令

## 实时查看日志

```bash
journalctl -f
```

这里跟 tail -f 的用法非常一致， 就是如果有出现新的日志会不断刷新到屏幕上

## 查看某个服务的日志

```bash
# journalctl -u <service>
journalctl -u sshd
```

-u 就是 --unit
后面跟上你的服务名, 即可查看这个服务相关的日志

## 查看特定时间段的日志

```bash
# 只查看两个小时时间段内的日志
journalctl --since "2 hours ago"

# 指定时间范围
journalctl --since "2026-08-30 00:00:00" --until "2026-08-30 12:00:00"
```

--since 指定开始的时间， --until 指定结束的时间

## 查看特定等级的日志

```bash
# 仅查看 err 级别的日志
journalctl -p err
```

-p 是 --priority 的意思
日志有不同的优先级, 这些是可选的级别 [ `emrg`, `alert`, `crit`, `err`, `warning`, `notice`, `info`, `debug` ]

## 查看内核日志

```bash
journalctl -k
```

-k 是 --dmesg 的意思， 代表内核的信息
