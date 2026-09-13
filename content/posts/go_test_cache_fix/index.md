+++
date = '2026-09-13T17:20:54+08:00'
draft = true
title = 'Go_test_cache_fix'
+++

# Golang Test Cache

有时候测试的时候遇到删掉注释运行结果跟原来不一样的情况。这个时候基本就开始道心破碎了，但是别慌，可能是 cache 没有清理，修改部分没有被重新构建。所以我们这个时候需要清理一下 test 的 cache.

参考自 [stack overflow](https://stackoverflow.com/questions/48882691/force-retesting-or-disable-test-caching)
这个命令可以让所有的测试缓存都到期， 直接重新构建， 可以得到真实的结果

```bash
go clean -testcache
```
