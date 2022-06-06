## la:查看隐藏文件
alias la='ls -A'
## ll: 查看文件详细信息
alias ll='ls -alhF'
## rr:递归删除
alias rr='rm -r'
alias cp='cp -i'
alias df='df -h'
alias free='free -m'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias catn='cat -n'
alias kill9='kill -9'
alias j='_zlua'
alias scp='scp -r'
alias gdb='gdb -q'
# grep
alias pg='ps -aux | grep -v grep | grep'
alias tg='top | grep'
alias hg='history | grep'
#alias ig='ifconfig | grep inet'
alias ig="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp'"
alias ig6="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's/inet6/ipv/g' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp' -e 's#\s*pref.*##gp'"
alias bk='~/.config/zsh/bk'
alias mbk='~/.config/zsh/mbk'
# git
alias gb='git branch'
alias gc='git checkout'
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
# vpn
alias myip='curl cip.cc'
alias vip='proxychains4 curl cip.cc'
# 测试vpn是否连接成功
alias vpnt='curl -x socks5://127.0.0.1:10808 https://www.google.com -v'
alias v='proxychains4'
# Global Terminal VPN
function gvpn()
{#全局终端代理
	export ALL_PROXY="socks5://127.0.0.1:10808"
	export http_proxy="http://127.0.0.1:10809"
}

#alias d='dirs -v | head -10'
#alias 1='cd -'
#alias 2='cd -2'
#alias 3='cd -3'
#alias 4='cd -4'
#alias 5='cd -5'
#alias 6='cd -6'
#alias 7='cd -7'
#alias 8='cd -8'
#alias 9='cd -9'
#set -o vi
