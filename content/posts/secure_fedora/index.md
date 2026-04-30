+++
date = '2026-04-30T22:45:10+08:00'
draft = true
title = 'Secure_fedora'
+++

# 个人的 Fedora 引导拯救方案

> 有时候玩linux的时候， 移动硬盘上的grub引导会改掉内置硬盘上的引导， 导致内置硬盘不能独立启动

**所以我为了保住我的内置硬盘中的fedora，记录了修复引导的方法**

- 下面的方法是针对于 Fedora Btrfs

## 创建临时挂挂载目录

```bash
sudo mkdir -p /mnt/fedora
sudo mkdir -p /mnt/fedora/boot
sudo mkdir -p /mnt/fedora/boot/efi
```

## 挂载

```bash
sudo mount -o subvol=root,compress=zstd:1 /dev/nvme0n1p3 /mnt/fedora
sudo mount /dev/nvme0n1p2 /mnt/fedora/boot
sudo mount /dev/nvme0n1p1 /mnt/fedora/boot/efi
sudo mount --bind /dev /mnt/fedora/dev
sudo mount --bind /proc /mnt/fedora/proc
sudo mount --bind /sys /mnt/fedora/sys
sudo mount --bind /run /mnt/fedora/run
```

## 进入fedora系统

```bash
sudo chroot /mnt/fedora
```

## 修复 GRUB 引导

```bash
grub2-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=fedora
grub2-mkconfig -o /boot/grub2/grub.cfg
```

> 执行完之后退出

```bash
exit
```

## 然后卸载fedora并重启

```bash
sudo umount -R /mnt/fedora
sudo reboot
```

> 这个时候拔掉移动硬盘， fedora正常从内置硬盘的引导启动
