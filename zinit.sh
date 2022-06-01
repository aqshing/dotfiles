#!/bin/bash
###################################################
# Filename: zinit.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: init shell
# Created: 2020-11-05 20:53:24
# Changed: 2022-06-01 15:02:26
###################################################

##set -xeuo pipefail
set -x
# 架构 x86 x86_64 arm aarch64
HOST_ARCH=$(uname -m | sed -e 's/i.86/i686/' -e 's/^armv.*/arm/')
# 内核：Linux
OS_KERNEL=$(uname | tr "[:lower:]" "[:upper:]" )
# OS分支：Ubuntu CentOS
DISTRO=$(cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2 | tr "[:lower:]" "[:upper:]" | tr -d '"')
# 当前用户ID
USER_ID=$(id -u)
# 当前用户名字
USER_NAME=$(whoami)


START_DIR=$(dirname "$0")
START_DIR=$(cd "$START_DIR" || exit; pwd)


function Transhor()
{
	if [ ! -d "$HOME/.backups" ]; then
	    mkdir "$HOME/.backups"
	fi

	nowtime=$(date +%Y-%m-%d_%H:%M:%S)
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$HOME/.backups/$filename.$nowtime"
	done
}


function CpConf()
{
	if [ ! -d $HOME/.config ]; then
		mkdir $HOME/.config
	fi

	for folder in $(ls shell/config)
	do
		if [ -n "$folder"  -a -e $HOME/.config/$folder ]; then
			Transhor $HOME/.config/$folder
		fi
	done

	cp -a shell/config/* $HOME/.config
	cp vi/vimrc $HOME/.config/nvim/init.vim

	# if [ ! -d $HOME/.zinit ]; then
	# 	mkdir $HOME/.zinit
	# 	git clone https://github.com/zdharma/zinit.git $HOME/.zinit/bin
	# fi
}

function GitandSSH()
{
	git config --global user.name "aqshing"
	git config --global user.email aqdebug@gmail.com
	git config --global core.editor vim

	if [ ! -d "$HOME/.ssh" ]; then
		mkdir "$HOME/.ssh"
	fi

	if [ -e "$HOME/.ssh/config" ]; then
		Transhor "$HOME/.ssh/config"
	fi

	cp -a ssh/config "$HOME/.ssh"
}

function main()
{
	cd "$START_DIR"  || return 1
	CpConf
	GitandSSH
}

main  "$@"
exit  "$?"
