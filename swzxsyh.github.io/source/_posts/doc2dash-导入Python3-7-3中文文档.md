---
title: doc2dash 导入Python3.7.3中文文档
date: 2019-03-29 23:48:42
tags:
---

Python官网出中文版文档（进阶部分仍是英文），但是Dash更新好像无法下载中文文档，遂自建

方法非常简单：

python先根据自己版本下载doc2dash
pip3 install doc2dash

然后去官网下载中文版html
https://docs.python.org/zh-cn/3/archives/python-3.7.3-docs-html.tar.bz2

解压为python-3.7.3-docs-html文件夹（可在此改名）

然后运行doc2dash python-3.7.3-docs-html
Adding table of contents meta data… [#########################################################################################################################################################] 100%
即可在目录创建出python-3.7.3-docs-html.docset

复制到Dash默认路径打开即可导入