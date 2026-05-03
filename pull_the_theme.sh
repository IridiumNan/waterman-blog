#!/bin/bash

mkdir -p themes
wget https://dong-dynabook-satellite-b35-r.tail015922.ts.net/static/file_manager/data/Share/static/hugo-theme-stack.tar.xz

tar xJvf hugo-theme-stack.tar.xz -C themes/

rm hugo-theme-stack.tar.xz
