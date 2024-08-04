# shellcheck disable=SC2148
if ! grep -i "termux" <<<"$PREFIX" && [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color # 开启terminal 256色支持, 将8色改为256色支持
fi                             # [ "$(tput colors)" = 8 ] && [ "$TERM" = "xterm" ]
alias ,='cd -'
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
# 查看默认网关 route -n
##alias wg="ip route show | grep default"
# 查看实时网络流量速度 dstat -cdmnry
##alias nsp=dstat -n
alias cpu="grep -c '^processor' /proc/cpuinfo"
#sudo提权后使用别名https://mp.weixin.qq.com/s/LEWlF5reOTZQWFRx43lAIg
alias sudo='sudo '
# 清除所有ssh-agent缓存的pem
# alias sshcl='ssh-add -D'
# 模糊搜索进程
function pg() {
    for i in "$@"; do # shellcheck disable=SC2009
        ps aux | grep -v grep | grep "$i"
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
##匹配本机所有网卡 ifconfig | grep -oE "^\S*:"| grep -v 'lo' | sed -n 's/://gp'
## 匹配本机真实ip
#ip addr|grep ": e\S*:" -A2|grep -oE "inet ([0-9]+.){3}[0-9]+"|sed -n 's#inet ##p'
#ifconfig|grep "^e\S*:" -A2|grep inet|sed -ne 's/^\s*//' -e 's@inet @@g' -e 's#\s*netm.*##gp'
alias ig="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp'"
alias ig6="ifconfig | grep inet | sed -n -e 's/^\s*//' -e '/inet 127/d' -e 's/inet6/ipv6/g' -e 's@inet@ipv4@g' -e 's#\s*netm.*##gp' -e 's#\s*pref.*##gp'"
alias bk='bash ~/.config/zsh/bk'
alias mv='bash ~/.config/zsh/mbk'
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
function de() { # 检查容器中是否存在 /bin/bash
    if docker exec -it "$1" [ -e /bin/bash ]; then
        docker exec -it "$1" /bin/bash
    else
        docker exec -it "$1" /bin/sh
    fi
}
alias ds='docker search --limit=5'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
# tmux
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tk='tmux kill-session -t'
# 将npm替换为cnpm
if command -v cnpm >/dev/null 2>&1; then
    alias npm='cnpm'
fi
# 依次检测nvim vim 是否存在
if command -v nvim >/dev/null 2>&1; then
    alias vi='nvim'
elif command -v vim >/dev/null 2>&1; then
    alias vi='vim'
fi
# vpn # curl -s https://api.ipify.org
alias myip='curl cip.cc'
alias vip='proxychains4 curl ipinfo.io'
# 测试vpn是否连接成功
[ -z "$proxy_ip" ] && export proxy_ip="127.0.0.1"
alias vpnt='curl -x socks5://$proxy_ip:10808 https://www.google.com -v'
alias v='proxychains4'
# Global Terminal VPN
function gvpn() {
    if [[ "$1" == "off" || "$1" == "0" ]]; then
        # unset ALL_PROXY proxy http_proxy https_proxy ftp_proxy no_proxy
        export ALL_PROXY=""
        export proxy=""
        export http_proxy=""
        export https_proxy=""
        export ftp_proxy=""
        export use_proxy=off
    else # 全局终端代理
        [ -z "$proxy_ip" ] && export proxy_ip="127.0.0.1"
        export ALL_PROXY="socks5://$proxy_ip:10808"
        export proxy=$ALL_PROXY
        export http_proxy="http://$proxy_ip:10809"
        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export no_proxy="localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
        export use_proxy=on
    fi
}
# 获取 curl 和 wget 的可执行文件路径
[ -z "$CURL_BIN" ] && CURL_BIN=$(command -v curl)
[ -z "$WGET_BIN" ] && WGET_BIN=$(command -v wget)
# 定义 alias 并调用自定义函数
alias curl='auto_proxy_curlwget "$CURL_BIN"'
alias wget='auto_proxy_curlwget "$WGET_BIN"'
# 自定义函数：自动判断是否需要打开 VPN，并下载文件
function auto_proxy_curlwget() {
    local dl_bin="$1" # 下载工具的路径
    shift             # 移除第一个参数，剩余的参数是传递给下载工具的参数列表
    local tmp_proxy=$use_proxy

    # 判断是否需要打开 VPN
    if python3.9 "$HOME"/.config/zsh/isproxy.py "$@"; then
        gvpn 1 # 打开 VPN
    fi

    # 使用下载工具下载文件
    "$dl_bin" "$@"
    local ErrCode=$?
    # 如果之前 VPN 状态不是 "on"，则关闭 VPN 并恢复环境
    if [[ "$tmp_proxy" != "$use_proxy" ]] && [[ "$tmp_proxy" != "on" ]]; then
        gvpn 0 # 关闭 VPN
    fi
    return $ErrCode
}
# 用CURL命令分析请求时间
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
function pk() { # shellcheck disable=SC2009
    #[ "$1" ] && pgrep "$1" | xargs -I {} kill -9 {}
    [ "$1" ] && ps aux | grep -v grep | grep "$1" | awk '{ print $2}' | xargs -I {} kill -9 {}
}
# 二维码生成器 #Terminal QR Code
#eg: qrcode https://aqdebug.com
function qrcode() {
    echo "$1" | curl -F-=\<- qrenco.de
}
function glibc() {
    [ -e "$1" ] && ldd "$1" && readelf -s "$1" | grep -oP "GLIBC_[\d\.]*" | sort | uniq
}
# 删除文件到回收站
function rr() {
    if [ ! -e "$HOME/.Trash/.count" ]; then
        mkdir -p "$HOME/.Trash"
        echo 0 >"$HOME/.Trash/.count"
    fi

    t=$(cat "$HOME/.Trash/.count")
    if [ ! "$1" ]; then
        echo "now: $t, if it great than 10, will delete."
        return 0
    fi
    t=$((t + 1))
    echo $t >"$HOME/.Trash/.count"

    if [ "$t" -gt 10 ]; then
        echo 1 >"$HOME/.Trash/.count"
        local file trimmed_string date_part timestr answer
        for file in "$HOME/.Trash"/*; do
            # 去掉最后6位时间字符串 %H%M%S
            trimmed_string="${file%??????}"
            # 截取最后8位日期字符串 %Y%m%d
            date_part="${trimmed_string: -8}"

            # 判断是否是合法的 %Y%m%d 日期字符串
            if date -d "$date_part" +%Y%m%d >/dev/null 2>&1; then
                timestr="+%Y%m%d"
            else
                # 如果不是，去掉前两位再判断是否是合法的 %y%m%d 日期字符串
                date_part="${date_part#??}"
                if date -d "$date_part" +%y%m%d >/dev/null 2>&1; then
                    timestr="+%y%m%d"
                else
                    while true; do
                        read -rt 60 -n 1 -p"$file: No timestamp was found. Continue delete? [y|n]" answer >&2
                        if [[ -z "$answer" ]]; then
                            answer=n
                        fi
                        case $answer in
                        [Yy])
                            echo -e "\033[33m\ndelete $file\033[0m" >&2
                            rm -rf "$file"
                            break
                            ;;
                        [Nn])
                            echo -e "\033[32mAbort delete the file...\033[0m" >&2
                            break
                            ;;
                        *)
                            echo -e "\033[31mInvalid input, please enter y|n:\033[0m" >&2
                            ;;
                        esac
                    done
                    continue
                fi
            fi
            # 判断该文件是否超过10天, 超过则删除
            if ((10#"$date_part" <= 10#$(date -d "- 10 days" "$timestr"))); then
                echo -e "\033[33mdelete $file\033[0m"
                rm -rf "$file"
            fi
        done
    fi
    ## $(date +%Y-%m-%d_%H:%M:%S)
    nowtime=$(date +%y%m%d%H%M%S)
    for i in "$@"; do
        filename=$(basename "$i")
        mv "$i" "$HOME/.Trash/$filename.$nowtime"
    done
}

# 自动压缩：判断后缀名并调用相应压缩程序
alias c='qcompress'
function qcompress() {
    if [ -n "$1" ]; then
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

if grep -iqE "bash$" <<<"$0"; then # 针对bash专门定制的别名、函数和配置
    alias ....='. $HOME/.bashrc'
    alias ...='vi $HOME/.bashrc && . $HOME/.bashrc'
    # 自动解压：判断文件后缀名并调用相应解压命令
    alias x='q-extract'
    function q-extract() {
        if [ -f "$1" ]; then
            case "$1" in
            *.tar.bz2) tar -xvjf "$1" ;;
            *.tar.gz) tar -xvzf "$1" ;;
            *.tar.xz) tar -xvJf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) rar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar -xvf "$1" ;;
            *.tbz2) tar -xvjf "$1" ;;
            *.tgz) tar -xvzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "don't know how to extract '$1'..." ;;
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
else # 针对zsh专门定制的别名、函数和配置
    alias ....='. $HOME/.zshrc'
    alias ...='vi $HOME/.zshrc && . $HOME/.zshrc'
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
    #. ~/.config/zsh/bracketed-paste.zsh

    # 将zsh的type命令仿真为bash的type命令
    # shellcheck disable=SC2139
    alias type="bash ${0:h}/type"
    # 让zsh像bash一样提示未安装的软件
    # shellcheck source=/dev/null
    [ -r /etc/zsh_command_not_found ] && . /etc/zsh_command_not_found
fi
#set -o vi
alias 。。。=...
# sort -t ";" -k 2 -u ~/.zsh_history | sort -o ~/.zsh_history # 去重zsh历史记录
