#!/usr/bin/env bash
###################################################
# Filename: zinit.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: init shell
# Created: 2020-11-05 20:53:24
# Changed: 2022-09-19 16:30:46
###################################################
# set -xeuo pipefail
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
# 脚本所在目录
START_DIR=$(cd "$(dirname "$0")" || exit; pwd)

ConfFile='~/.bashrc'
SourceLine=0


function Transhor() {
	if [ ! -d "$HOME/.backups" ]; then
	    mkdir "$HOME/.backups"
	fi
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$HOME/.backups/$filename.$(date +%y%m%d%H%M%S)"
	done
}

# @brief 创建软链接, 或者复制文件, 默认创建软链接
function LinkOrCopy() {
	if [ -e "$2" ]; then
		Transhor "$2"
	fi
	if [ "$3" == "cp" ]; then
		cp -a "$1" "$2"
	else
		ln -is "$1" "$2"
	fi
}


function CpConf() {
	if [ ! -d "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi

	for folder in $(ls shell/config)
	do
		if [ -n "$folder" ]; then
			LinkOrCopy "$START_DIR/shell/config/$folder" "$HOME/.config/$folder"
		fi
	done
	LinkOrCopy "$START_DIR/shell/vimrc" "$HOME/.config/nvim/init.vim"

	if [ ! -d "$HOME/.zinit" ]; then
		mkdir "$HOME/.zinit"
		git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
	fi
}


function GitandSSH() {
	git config --global user.name "aqshing"
	git config --global user.email aqdebug@gmail.com
	git config --global core.editor vi

	if [ ! -d "$HOME/.ssh" ]; then
		mkdir "$HOME/.ssh"
	fi

	LinkOrCopy "$START_DIR/ssh/config" "$HOME/.ssh/config" "cp"

	LinkOrCopy "$START_DIR/shell/proxychains" "$HOME/.proxychains"

	LinkOrCopy "$START_DIR/shell/tmux.conf.local" "$HOME/.tmux.conf.local"

	LinkOrCopy "$START_DIR/vi" "$HOME/.vim"

	LinkOrCopy "$START_DIR/shell/vimrc" "$HOME/.vimrc"
}

# @brief: 导出路径到PATH路径
# @param: $1:变量名称
# @param: $2:导出路径
# @eg: SetPATH JAVA_HOME /opt/java
function LoadFile() {
	# 获取$1变量在.[ba|z]shrc出现的位置
	line=$(grep "$1" "$2" | wc -l)

	if [ "$line" -lt 1 ]; then #没有导出过则导出此变量
		SourceLine=$((SourceLine+1))
		sed -i  "$SourceLine a $1" "$2"
	fi
}

function Load() {
	local file="$HOME/.bashrc"
	# 检测是否存在zsh
	if [ -e "$HOME/.zshrc" ]; then
		echo '检测到~/.zshrc，您当前使用的是ZSH吗？'
		echo '如果是，请输入[y|yes]确认将配置写入.zshrc'
		echo '否则将会把配置写入~/.bashrc'
		read -rt 30 -p "please choice option:{y|n}:" choice
		if [ "$choice" == "y" ] || [ "$choice" == "yes" ]; then
			file="$HOME/.zshrc"
			#
			LoadFile 'source ~/.zinit/bin/zinit.zsh' "$file"
			LoadFile 'source ~/.config/zsh/zconf.zsh' "$file"
		fi
	fi

	LoadFile 'source ~/.config/zsh/alias.sh' "$file"
	LoadFile 'source ~/.config/zsh/git.sh' "$file"
	LoadFile 'source ~/.config/zsh/work.sh' "$file"
}

function OpenGlobalVPN() {
	if curl -x socks5://127.0.0.1:10808 https://www.google.com --silent > /dev/null; then
		echo "检测到代理，代理联网成功，开启全局代理..."
		export ALL_PROXY="socks5://127.0.0.1:10808"
		export http_proxy="http://127.0.0.1:10809"
	else
		echo "未检测到代理，后续下载可能会失败..."
		export ALL_PROXY=""
		export http_proxy=""
	fi
}

function main() {
	cd "$START_DIR" || return 1
	OpenGlobalVPN
	GitandSSH
	CpConf
	Load
}

main  "$@"
exit  "$?"
