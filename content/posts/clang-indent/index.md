+++
date = '2026-08-23T21:10:33+08:00'
draft = true
title = 'Clang Indent'
+++

# Lazyvim Clang format adjust

- Create your project

```bash
mkdir myProject
cd myProject

touch .clang-format
```

- Edit .clang-format file (Write as below)

```yaml
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
UseTab: Never
```

- Then you can begin your coding, lazyvim will format it as 4 indentwidth
