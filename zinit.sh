#!/usr/bin/env bash
###################################################
# Filename: zinit.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: init shell
# Created: 2020-11-05 20:53:24
# Changed: 2022-10-12 19:01:22
###################################################
# set -xeuo pipefail
# 架构 x86 x86_64 arm aarch64
HOST_ARCH=$(uname -m | sed -e 's/i.86/i686/' -e 's/^armv.*/arm/')
# 内核：Linux
OS_KERNEL=$(uname | tr "[:lower:]" "[:upper:]")
# OS分支：Ubuntu CentOS
#DISTRO=$(cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2 | tr "[:lower:]" "[:upper:]" | tr -d '"')
# 当前用户ID
USER_ID=$(id -u)
# 当前用户名字
USER_NAME=$(whoami)
# bash 和 zsh 版本
BASH_VERSION=$(bash --version | grep -oE '[0-9]+\.[0-9]+' | sed -n 's/\.//gp')
#ZSH_VERSION=$(zsh --version | grep -oE '[0-9]+\.[0-9]+' | sed -n 's/\.//gp')
# 脚本所在目录
START_DIR=$(cd "$(dirname "$0")" || exit; pwd)
cd "$START_DIR" || return 1
ConfFile="$HOME/.bashrc"
SourceLine=0

ln -s "$0" "$START_DIR/lntest.sh"
[[ $(file "$START_DIR/lntest.sh") =~ "symbolic link" ]] && ISLINK=true || ISLINK=false
printf "checking command: %s ... " "ln -s"
"$ISLINK" && printf "yes\n" || printf "no\n"
rm -f "$START_DIR/lntest.sh"


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
	f=$(sed -ne "s#$HOME#~#gp" <<< "$2")
	if ! "$ISLINK" || [ "$3" == "cp" ]; then
		cp -a "$1" "$2"
		printf "cp %s -> %s\n" "$(basename "$1")" "$f"
	else
		ln -is "$1" "$2"
		printf "ln %s -> %s\n" "$f" "$(basename "$1")"
	fi
}

function CpConf() {
	if [ ! -d "$HOME/.config" ]; then
		mkdir "$HOME/.config"
	fi
	f=$(ls shcnf)
	for folder in $f
	do
		if [ -n "$folder" ]; then
			LinkOrCopy "$START_DIR/shcnf/$folder" "$HOME/.config/$folder"
		fi
	done
	LinkOrCopy "$START_DIR/softcnf/vimrc" "$HOME/.config/nvim/init.vim"

	if [ ! -d "$HOME/.zinit" ]; then
		mkdir "$HOME/.zinit"
		git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
	fi
}


function GitandSSH() {
	git config --global user.name "aqshing"
	git config --global user.email aqdebug@gmail.com
	git config --global core.editor vi
	# 禁止\n自动转化为\r\n
	git config --global core.autocrlf false

	if [ ! -d "$HOME/.ssh" ]; then
		mkdir "$HOME/.ssh"
	fi
	f=$(ls softcnf)
	for folder in $f
	do
		if [ -n "$folder" ]; then
			LinkOrCopy "$START_DIR/softcnf/$folder" "$HOME/.$folder"
		fi
	done
	LinkOrCopy "$START_DIR/ssh/config" "$HOME/.ssh/config" "cp"

	LinkOrCopy "$START_DIR/vimc" "$HOME/.vim"
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
		sed -i  "$SourceLine i $1" "$2"
		sed -i "1i#! /bin/sh -" a
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
			ConfFile="$HOME/.zshrc"
			#
			LoadFile '. ~/.zinit/bin/zinit.zsh' "$file"
			LoadFile '. ~/.config/zsh/zconf.zsh' "$file"
		fi
	fi

	LoadFile '. ~/.config/zsh/alias.sh' "$file"
	LoadFile '. ~/.config/zsh/git.sh' "$file"
	LoadFile '. ~/.config/zsh/work.sh' "$file"
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
	true || OpenGlobalVPN
	GitandSSH
	CpConf
	Load

	if [[ "$OS_KERNEL" =~ "NT" ]] && grep -iqE "windows" <<< "$OS" &&
	! grep -iqE "._.bat" "$HOME/.config/zsh/export.sh"; then
		cat "$START_DIR/shcnf/zsh/winpath" >> "$HOME/.config/zsh/export.sh"
	fi

	# 清理环境变量
	if tail -1 ~/.bashrc | grep -c "export PATH=\$(echo \"\$PATH\" | sed 's/:/\\\n/g' | sort | uniq | tr -s '\\\n' ':' | sed 's/:$//g')"; then
		printf "export PATH=\$(echo \"\$PATH\" | sed 's/:/\\\n/g' | sort | uniq | tr -s '\\\n' ':' | sed 's/:$//g')" >> "$ConfFile"
	fi
}

main  "$@"
exit  "$?"
