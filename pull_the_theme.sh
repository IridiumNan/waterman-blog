#!/bin/bash

SRC='https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/hugo-theme-stack.tar.xz'

mkdir -p themes
wget $SRC

echo "unpacking the stack theme"
tar xJf hugo-theme-stack.tar.xz -C themes/

rm hugo-theme-stack.tar.xz
