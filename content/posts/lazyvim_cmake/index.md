+++
date = '2026-09-30T15:47:10+08:00'
draft = true
title = 'Lazyvim_cmake'
+++

# Lazyvim Cmake 配置

lazyvim 当中对于头文件的定位和 lsp 依赖的是 `clangd`

而 `clangd` 需要读取一个 `compile_commands.json` 才能正确的定位到头文件

它是基于 `CMakeLists.txt` 来生成的

lazyvim 当中可以通过插件，来进行自动生成， 进而获得 项目的 lsp 支持

下面是具体的配置步骤

## 插件下载

普通模式下通过 `:LazyExtra` 打开插件管理面板

之后 按 `/` 进入搜索模式， 搜索 `lang.cmake`

按回车， 再按 `x` 然后退出重启， 让 lazyvim 自己下载

## 自动生成

当项目中有 `CMakeLists.txt` 这个文件的时候， 在 lazyvim 当中执行 `:CMakeGenerate`

就会自动进行编译并将 `compile_commands.json` 软链接到项目的根目录， 这个时候重新启动就可以获得 lsp 的语法支持
