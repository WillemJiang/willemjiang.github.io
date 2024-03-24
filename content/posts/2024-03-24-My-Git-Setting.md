+++
author = "Hugo Authors"
title = "My Git Setting"
date = "2024-03-24"
description = "Git的本机设置。The Git configure setting on my local machine."
tags = [
    "Git",
    "Configuration", 
]
categories = [
    "Tools",
]
+++

最近换了一台在公司的办公电脑因为没有把自己的本地设置导入进去， 发现Git工具都不太顺手，因此写下这篇文章记录一下相关的配置。

## Git 的全局设置

需要修改 ```～/.gitconf``` 文件是 Git 的全局配置文件，它存储了用户的所有全局配置。这个文件通常位于用户的主目录下。
在这个文件中，你可以设置许多 Git 的配置选项，例如用户名、电子邮件地址、别名等。我们可以通过设置别名来进一步提升我们的工作效率

你可以使用 ```git config --global``` 命令来修改 .gitconfig 文件。例如，以下命令将设置你的用户名和电子邮件地址:
```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

这些命令将修改 .gitconfig 文件，添加或更新相应的配置选项。

下面是具体的配置示例供大家参考

``` txt
[user]
    name = Your Name
    email = your.email@example.com
[alias]
  ci = commit -a
  co = checkout
  st = status
  br = branch
  cp = cherry-pick
  hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
  type = cat-file -t
  dump = cat-file -p
  s = commit -s

[http]
    proxy = http://127.0.0.1:1087 # http 使用本地代理访问 

[core]
    editor = vim  # 设置默认编辑器为 vim
    excludesfile = ~/.gitignore_global  # 设置全局 .gitignore 文件

[diff]
    tool = vimdiff  # 设置默认 diff 工具为 vimdiff

[merge]
    tool = vimdiff  # 设置默认 merge 工具为 vimdiff

[push]
    default = current  # 设置默认 push 行为为只 push 当前分支

[color]
    # 开启颜色输出
    ui = true

    # 设置特定命令的颜色
    branch = auto
    diff = auto
    status = auto
    grep = auto
```
