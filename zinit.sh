#!/usr/bin/env bash
###################################################
# Filename: zinit.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: init shell
# Created: 2020-11-05 20:53:24
# Changed: 2022-06-21 16:14:29
###################################################

##set -xeuo pipefail
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

ConfFile='~/.bashrc'
SourceLine=0


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
	if [ ! -d "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi

	for folder in $(ls shell/config)
	do
		if [ -n "$folder"  -a -e $HOME/.config/$folder ]; then
			Transhor "$HOME/.config/$folder"
		fi
	done

	cp -a shell/config/* "$HOME"/.config
	cp vi/vimrc "$HOME"/.config/nvim/init.vim

	if [ ! -d "$HOME/.zinit" ]; then
		mkdir "$HOME/.zinit"
		git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
	fi
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

	if [ ! -d "$HOME/.proxychains" ]; then
		mkdir "$HOME/.proxychains"
	fi
	if [ -e "$HOME/.proxychains/proxychains.conf" ]; then
		Transhor "$HOME/.proxychains/proxychains.conf"
	fi
	cp -a shell/proxychains/proxychains.conf "$HOME/.proxychains"
}

# @brief: 导出路径到PATH路径
# @param: $1:变量名称
# @param: $2:导出路径
# @eg: SetPATH JAVA_HOME /opt/java
# 会在~/.bashrc中检测JAVA_HOME变量，若检测到，则修正导出路径
# 若没有则追加 export JAVA_HOME=/opt/java
# export PATH=$PATH:$JAVA_HOME/bin 这两行内容到文件末尾
function LoadFile()
{
	# 获取$1变量在.[ba|z]shrc出现的位置
	local line=$(grep "$1" "$2" | wc -l)

	if [ "$line" -lt 1 ]; then #没有导出过则导出此变量
		SourceLine=$((SourceLine+1))
		sed -i  "$SourceLine a $1" "$2"
	fi

	return 0
}

function Load()
{
	local file="$HOME/.bashrc"
	# 检测是否存在zsh
	if [ -e "$HOME/.zshrc" ]; then
		echo '检测到~/.zshrc，您当前使用的是ZSH吗？'
		echo '如果是，请输入[y|yes]确认将配置写入.zshrc'
		echo '否则将会把配置写入~/.bashrc'
		read -t 30 -p "please choice option:{y|n}:" choice
		if [ "$choice" == "y" ] || [ "$choice" == "yes" ]; then
			file="$HOME/.zshrc"
			ConfFile='~/.zshrc'
			#
			LoadFile 'source ~/.zinit/bin/zinit.zsh' "$file"
			LoadFile 'source ~/.config/zsh/zconf.zsh' "$file"
		fi
	fi

	LoadFile 'source ~/.config/zsh/alias.sh' "$file"
	LoadFile 'source ~/.config/zsh/git.sh' "$file"
	LoadFile 'source ~/.config/zsh/work.sh' "$file"
}

function OpenGlobalVPN()
{
	if curl -x socks5://127.0.0.1:10808 https://www.google.com --silent > /dev/null; then
		echo "检测到代理，代理联网成功，开启全局代理..."
		export ALL_PROXY="socks5://127.0.0.1:10808"
		export http_proxy="http://127.0.0.1:10809"
	else
		echo "未检测到代理，后续下载可能会失败..."
	fi
}

function main()
{
	#cd "$START_DIR" || return 1
	OpenGlobalVPN
	#GitandSSH
	#CpConf
	#Load
}

main  "$@"
exit  "$?"
