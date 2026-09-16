+++
date = '2026-09-18T23:08:00+08:00'
draft = true
title = 'Cpp_Beginner'
+++

# 在 Linux 上运行 cpp 代码

## Windows 的配置灾难

众所周知，在windows上安装vscode并配置好mingw编译器对于很多新手来说都是一件非常曲折的事情
因为 windows 的主要受众是普通人，所以软件管理，编译器配置方面都不如Linux便利

如果你选择了 Linux 那么恭喜你将获得一个非常便利而自然的开发环境
接下来我简单介绍一下如何在 Linux 上跑通一个 简单的 Hello World 以及多文件编译

---

## g++ 安装

g++ 编译器是专门用于编译 cpp 代码的(也就是让你写的东西能用机器跑起来)
安装非常简单，取决于你使用什么包管理器

- Debian 系列(ubuntu, mint, debian)

```bash
sudo apt install g++ -y
```

- RHEL 系列(fedora, rhel, rocky)

```bash
sudo dnf install g++ -y
```

- 查看版本

```bash
g++ -v
```

参考输出:
❯ g++ -v

```shell
Using built-in specs.
COLLECT_GCC=g++
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-pc-linux-gnu/16/lto-wrapper
Target: x86_64-pc-linux-gnu
Configured with: ../gcc/configure --enable-languages=ada,c,c++,d,fortran,go,lto,m2,objc,obj-c++,rust,cobol --enable-bootstrap --prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib --mandir=/usr/share/man --infodi
r=/usr/share/info --with-bugurl=https://gitlab.archlinux.org/archlinux/packaging/packages/gcc/-/issues --with-build-config=bootstrap-lto --with-gcc-major-version-only --with-linker-hash-style=gnu --with-system-zl
ib --enable-cet=auto --enable-checking=release --enable-clocale=gnu --enable-default-pie --enable-default-ssp --enable-gnu-indirect-function --enable-gnu-unique-object --enable-libstdcxx-backtrace --enable-link-s
erialization=1 --enable-linker-build-id --enable-lto --enable-multilib --enable-plugin --enable-shared --enable-threads=posix --disable-fixincludes --disable-libssp --disable-libstdcxx-pch --disable-werror
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 16.1.1 20260725 (GCC)
```

---

## 编写一个程序

- 创建一个cpp文件(以cpp为后缀)

```bash
touch hello.cpp
```

- 使用你喜欢的编辑器打开

```bash
vim hello.cpp
# 如果你不会用 vim 就用nano
# nano hello.cpp
```

- 写入下面的内容

```cpp
#include <iostream>

int main() {
    std::cout << "hello world" << std::endl;
    return 0;
}
```

- 保存并退出

- 编译成二进制文件

```bash
g++ hello.cpp -o hello
```

> -o <file>                Place the output into <file>.
这里 -o 表示 output(输出的二进制文件), 后面跟上你起的二进制文件名， 随便叫啥，一般会叫main或者你的程序名

写法是 g++ 源文件路径 -o 二进制文件

- 运行程序

```bash
./hello # ./ 表示当前目录， 后面直接跟上文件名， 表示运行该二进制文件
```

这个时候终端会打印 hello world， 恭喜你成功用命令行成功编写并运行了一个cpp程序

---

## 多文件编译

当我们的源文件不止一个的时候， 我们需要在编译的时候把所有用到的源文件都写上(当然仅限于自己写的那些源文件，标准库就不需要了)

比如说这个项目

```bash
❯ tree
.
├── CMakeLists.txt
├── compile_commands.json
├── include
│   ├── legacy
│   │   ├── CommentIO.hpp
│   │   ├── Filter.hpp
│   │   ├── LegacyFilterPipeline.hpp
│   │   └── NaiveScanner.hpp
│   ├── lib
│   │   ├── csv.hpp
│   │   └── simdutf.h
│   └── localLib
│       ├── BloomDeduplicator.hpp
│       ├── Comment.hpp
│       ├── CommentInteractiveInput.hpp
│       ├── CsvCommentInput.hpp
│       ├── CsvUtil.hpp
│       ├── Deduplicator.hpp
│       ├── FilterPipeline.hpp
│       ├── HammingDeduplicator.hpp
│       ├── ICommentSource.hpp
│       ├── Matrix.hpp
│       ├── mini_test.h
│       ├── PathUtil.hpp
│       ├── Recorder.hpp
│       ├── SlidingWindowLimiter.hpp
│       ├── Trie.hpp
│       ├── WatchMode.hpp
│       ├── WordAppender.hpp
│       ├── WordLibarary.hpp
│       └── WorkPerformaceAnalyser.hpp
├── makefile
├── src
│   ├── main.cpp
│   └── simdutf.cpp
```

不要看有这么多文件， 但是这个明显是一个 header only 的项目， 只有 src/ 目录里面有两个cpp 文件，所以我们只需要编译的时候指定这两个即可

```bash
# 创建一个 bin 目录放产物 如果你还没有的话
mkdir -p bin

g++ src/simdutf.cpp src/main.cpp -o bin/main
# 当然我们有更好的策略， 我们使用的可是高贵的Linux
# g++ src/*.cpp -o bin/main
# 直接使用通配符编译所有的cpp文件
```

这里给个建议就是将cpp源文件和hpp头文件分开，这样方便管理

现在你已经学会如何使用命令行编译cpp程序了，当然还有各种的编译方式，有各种编译工具，但是入门的话现在这些知识就够了
祝贺你
