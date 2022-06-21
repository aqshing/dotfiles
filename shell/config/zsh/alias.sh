## la:查看隐藏文件
alias la='ls -A'
## ll: 查看文件详细信息
alias ll='ls -alhF'
alias cp='cp -i'
alias df='df -h'
alias free='free -h'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias catn='cat -n'
alias kill9='kill -9'
alias scp='scp -r'
alias gdb='gdb -q'
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
#alias ig='ifconfig | grep inet'
alias ig="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp'"
alias ig6="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's/inet6/ipv6/g' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp' -e 's#\s*pref.*##gp'"
alias bk='~/.config/zsh/bk'
alias mbk='~/.config/zsh/mbk'
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
alias ds='docker search --limit=5'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
# tmux
alias ta='tmux attach -t'
alias tls='tmux ls'
# vpn
# curl -s https://api.ipify.org
alias myip='curl cip.cc'
alias vip='proxychains4 curl cip.cc'
# 测试vpn是否连接成功
alias vpnt='curl -x socks5://127.0.0.1:10808 https://www.google.com -v'
alias v='proxychains4'
# Global Terminal VPN
function gvpn(){
	#全局终端代理
	export ALL_PROXY="socks5://127.0.0.1:10808"
	export http_proxy="http://127.0.0.1:10809"
}
# 模糊通杀进程
#eg: pk nginx
function pk() {
#ps -aux | grep -v grep | grep "$1" | awk '{ print $2}' | xargs -I {} kill -9 {}
	[ "$1" != "" ] && pgrep "$1" | xargs -I {} kill -9 {}
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

    nowtime=$(date +%Y-%m-%d_%H:%M:%S)
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$HOME/.Trash/$filename.$nowtime"
	done

    t=$(cat "$HOME/.Trash/.count")
    t=$((t+1))
    echo $t > "$HOME/.Trash/.count"

    if [ "$t" -gt 10 ]; then
        rm -rf "$HOME/.Trash"
    fi
}
#set -o vi
