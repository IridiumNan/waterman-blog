+++
date = '2026-09-13T23:26:02+08:00'
draft = true
title = 'Gitea_max_size'
+++

# Gitea 配置最大上传文件的大小

> [!NOTE]
> 下面的教程只在 gitea version 1.27.2 上验证过

在gitea中， 默认的文件上限是 50 M
我们自己的家里云存储那么大， 肯定不能浪费了。所以我们应该改配置之后为所欲为。

下面的操作参考自 [gitea 论坛](https://forum.gitea.com/t/increase-size-for-release-files/7113/4)
这是docker部署的版本， 如果你使用其他方式部署， 也是找到 `app.ini` 这个文件然后修改配置重启

- 进入 docker 容器

```bash
docker exec -it <你的容器id> /bin/sh
```

- 打开配置文件

```bash
vi /etc/gitea/app.ini
```

- 写入配置

这里找到 attachment 然后添加 `MAX_SIZE=50000` 单位是 M

```bash
[attachment]
PATH = /var/lib/gitea/data/attachments
MAX_SIZE=50000
```

- 退出并重启容器

```bash
exit

docker restart <你的容器id>
```

这样就顺利完成配置了
