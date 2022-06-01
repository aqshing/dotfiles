#!/bin/bash
###################################################
# Filename: export.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: brief of script
# Created: Tue 16 Nov 2021 08:42:44 PM CST
# Changed: Tue 31 May 2022 04:03:25 PM CST
###################################################

# 环境变量
export NODE_HOME=/opt/node-v14.18.1-linux-x64

export PATH=$PATH:$NODE_HOME/bin:/snap/bin
# PKG链接库
export PKG_CONFIG_PATH=/opt/opencv/lib/pkgconfig:$PKG_CONFIG_PATH
# C/C++动态库
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv/lib:/boost_1_77_0/stage/lib


