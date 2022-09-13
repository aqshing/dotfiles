# la: 查看隐藏文件
alias la='ls -A'
# ll: 查看文件详细信息
alias ll='ls -alhF'
# 覆盖文件提示
alias cp='cp -i'
# -h: 提高可读性
alias df='df -h'
alias free='free -h'
# 递归创建目录
alias mkdir='mkdir -p'
# 高亮显示结果
alias grep='grep --color=auto'
alias catn='cat -n'
##alias kill9='kill -9'
alias scp='scp -r'
# 安静模式, 不打印版本信息
alias gdb='gdb -q'
# 查看本机的DNS域名解析服务器
##alias dns="sed -n 's/nameserver/dns/gp' /etc/resolv.conf"
# grep
# 模糊搜索进程
function pg() {
	for i in "$@";
	do
		ps -aux | grep -v grep | grep "$i"
	done
}
alias tg='top | grep'
alias hg='history | grep'
##function hg() {
##	for i in $@;
##	do #这个不好用,搜不全
##		history | grep $i
##	done
##}
##alias ig='ifconfig | grep inet'
alias ig="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp'"
alias ig6="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's/inet6/ipv6/g' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp' -e 's#\s*pref.*##gp'"
alias bk='bash ~/.config/zsh/bk'
alias mbk='bash ~/.config/zsh/mbk'
# git
alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'
alias gm='git merge'
alias gst='git status'
alias grh='git reset --hard'
alias gp='git push --set-upstream origin'
# nginx
alias nt='nginx -t'
alias nr='nginx -s reload'
alias nq='nginx -s quit'
# docker
alias dr='docker run'
alias dp='docker ps'
function de() {
	docker exec -it "$1" /bin/bash
}
alias ds='docker search --limit=5'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
# tmux
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tk='tmux kill-session -t'
# vpn
# curl -s https://api.ipify.org
alias myip='curl cip.cc'
alias vip='proxychains4 curl cip.cc'
# 测试vpn是否连接成功
alias vpnt='curl -x socks5://127.0.0.1:10808 https://www.google.com -v'
alias v='proxychains4'
# 将npm替换为cnpm
if  cnpm > /dev/null 2>&1 ; then
alias npm='cnpm'
fi
# Global Terminal VPN
function gvpn() {
#全局终端代理
export ALL_PROXY="socks5://127.0.0.1:10808"
export http_proxy="http://127.0.0.1:10809"
}
# 用 CURL 命令分析请求时间
# https://schaepher.github.io/2019/08/29/curl-analyze/
# https://stackoverflow.com/questions/18215389/how-do-i-measure-request-and-response-times-at-once-using-curl
function ct() {
    curl -so /dev/null -w "\
域名解析    namelookup:  %{time_namelookup}s\n\
建立连接       connect:  %{time_connect}s\n\
SSL 握手    appconnect:  %{time_appconnect}s\n\
数据发送   pretransfer:  %{time_pretransfer}s\n\
重定向        redirect:  %{time_redirect}s\n\
返回接收 starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
总耗时           total:  %{time_total}s\n" "$@"
}
# 模糊通杀进程
#eg: pk nginx
function pk() {
#[ "$1" ] && pgrep "$1" | xargs -I {} kill -9 {}
[ "$1" ] && ps -aux | grep -v grep | grep "$1" | awk '{ print $2}' | xargs -I {} kill -9 {}
}
# 二维码生成器 #Terminal QR Code
#eg: qrcode https://aqdebug.com
function qrcode() {
	echo "$1" | curl -F-=\<- qrenco.de
}
# 删除文件到回收站
function rr() {
	if [ ! -e "$HOME/.Trash/.count" ]; then
		mkdir "$HOME/.Trash"
		echo 0 > "$HOME/.Trash/.count"
	fi

	t=$(cat "$HOME/.Trash/.count")
	t=$((t+1))
	echo $t > "$HOME/.Trash/.count"

	if [ "$t" -gt 10 ]; then
		rm -rf "$HOME/.Trash"
		mkdir "$HOME/.Trash"
		echo 1 > "$HOME/.Trash/.count"
	fi

	## $(date +%Y-%m-%d_%H:%M:%S)
	nowtime=$(date +%y%m%d%H%M%S)
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$HOME/.Trash/$filename.$nowtime"
	done
}

# 自动压缩：判断后缀名并调用相应压缩程序
alias c='qcompress'
function qcompress() {
    if [ -n "$1" ] ; then
        FILE="$1"
        case "$FILE" in
        *.tar) shift && tar -cf "$FILE" "$*" ;;
        *.tar.bz2) shift && tar -cjf "$FILE" "$*" ;;
        *.tar.xz) shift && tar -cJf "$FILE" "$*" ;;
        *.tar.gz) shift && tar -czf "$FILE" "$*" ;;
        *.tgz) shift && tar -czf "$FILE" "$*" ;;
        *.zip) shift && zip "$FILE" "$*" ;;
        *.rar) shift && rar "$FILE" "$*" ;;
        esac
    else
        echo "usage: qcompress <foo.tar.gz> ./foo ./bar"
    fi
}

# 针对bash专门定制的别名、函数和配置
if ! pgrep "zsh" > /dev/null 2>&1 ;  then
alias sb='source ~/.bashrc'
# 自动解压：判断文件后缀名并调用相应解压命令
alias x='q-extract'
function q-extract() {
    if [ -f "$1" ] ; then
        case "$1" in
        *.tar.bz2)   tar -xvjf "$1"    ;;
        *.tar.gz)    tar -xvzf "$1"    ;;
        *.tar.xz)    tar -xvJf "$1"    ;;
        *.bz2)       bunzip2   "$1"    ;;
        *.rar)       rar x  "$1"       ;;
        *.gz)        gunzip  "$1"      ;;
        *.tar)       tar -xvf "$1"     ;;
        *.tbz2)      tar -xvjf "$1"    ;;
        *.tgz)       tar -xvzf "$1"    ;;
        *.zip)       unzip  "$1"       ;;
        *.Z)         uncompress  "$1"  ;;
        *.7z)        7z x  "$1"        ;;
        *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# 放到~/.bashrc 给man增加漂亮的色彩高亮
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'
# 判断是否处于交互式终端中
if [[ $- =~ i ]]; then
# bash键位映射,同下zsh
bind '"\e[1;5F":kill-word'
bind '"\e[1;5H":backward-kill-word'
bind '"\e[1;5A":beginning-of-line'
bind '"\e[1;5B":end-of-line'
fi
else
#http://mindonmind.github.io/notes/linux/zsh_bindkeys.html
#使用bindkey命令，第一个参数为对应快捷键的 CSI 序列 ，
#想知道某种快捷组合键的 CSI 序列，有如下两种方法:
#1.先按 Ctrl-V 然后再按组合键，如 Ctrl-A
#2.输入 cat > /dev/null ，之后输入组合键
# 更改 Ctrl+u 从光标删除到行首,而不是删除一整行
bindkey "^U" backward-kill-line
# Ctrl+End 向后删除一个单词
bindkey "^[[1;5F" kill-word
# Ctrl+Home 向前删除一个单词
bindkey "^[[1;5H" backward-kill-word
# 映射 Ctrl+↑ 为返回到行首,相当于 Home
bindkey "^[[1;5A" beginning-of-line
# 映射 Ctrl+↓ 为返回到行首,相当于 End
bindkey "^[[1;5B" end-of-line
# 使zsh前向词行为与bash/emacs中的行为相同
bindkey "^[[1;5C" emacs-forward-word
# 关闭括号粘贴模式 bing搜索zsh bracketed-paste-begin
# https://stackoverflow.com/questions/33452870/tmux-bracketed-paste-mode-issue-at-command-prompt-in-zsh-shell
#github.com/tokiclover/dotfiles/blob/master/.zsh/lib/bracketed-paste.zsh
unset zle_bracketed_paste
#source ~/.config/zsh/bracketed-paste.zsh

# 将zsh的type命令仿真为bash的type命令
alias type='bash ~/.config/zsh/type'
# 让zsh像bash一样提示未安装的软件
[ -r /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found
fi
#set -o vi
