# shellcheck disable=SC2148
alias du='du -sh'
alias ansible='python /opt/ansible'
alias ansible-playbook='python /opt/ansible-playbook'
completion_path=~/.config/zsh/completion
if grep -iqE "bash$" <<<"$0"; then # 针对bash专门定制的别名、函数和配置
    shell=bash
elif [ -n "$ZSH_VERSION" ]; then # 针对zsh
    shell=zsh
elif [ -n "$FISH_VERSION" ]; then # 针对fish
    shell=fish
fi

# @brief: zsh completion debug
__zshcomp_debug() {
    local file="$ZSH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >>"${file}"
    fi
}

function sql() {
    # 客户端路径
    if [[ -z "$MYSQL_BIN" ]]; then
        MYSQL_BIN=/greatdb/svr/greatdb/bin/greatsql
    fi
    # 默认缺省值
    UNAME='greatdb'
    PASSWD='greatdb'
    HOST=127.0.0.1
    PORT=3306
    # 要执行的sql语句
    STATEMENT=""
    # 0: 登陆客户端
    # 1: 查看版本信息
    # 2: 执行sql语句
    MENU=0
    # 要过滤的mysql参数
    # -n: 出错时的信息
    # -o: 表示短选项，冒号表示该选项有一个可选参数
    # --long: 长选项
    # 没有跟随:的是开关型选项，不需要再指定值，相当于true/false，只要带了这个参数就是true。
    ARGS=$(getopt -a -n sql -o e:u:p:h:P:V --long uname:,passwd:,host:,port:,version -- "$@")
    VALID_ARGS=$?
    if [ "$VALID_ARGS" != "0" ]; then
        echo " "
        echo "Usage: sql [OPTION]"
        echo "Options:"
        echo "defalut: sql -u$UNAME -p$PASSWD -h$HOST -P$PORT"
        echo -e "\033[32m" "    [ -u | --uname  ]    -- 用户名" "\033[0m"
        echo -e "\033[32m" "    [ -p | --passwd ]    -- 密码" "\033[0m"
        echo -e "\033[32m" "    [ -h | --host   ]    -- IP" "\033[0m"
        echo -e "\033[32m" "    [ -P | --port   ]    -- 端口" "\033[0m"
        echo -e "\033[32m" "    [ -V | --version]    查看版本信息" "\033[0m"
        echo -e "\033[32m" "    [ -e \"sql语句\"  ]    执行sql语句" "\033[0m"
        echo " "

        return 1
    fi
    # 刷新参数列表 等号替换为空格
    eval set -- "$ARGS"
    while :; do
        case "$1" in
        -u | --uname)
            UNAME="$2"
            shift 2
            ;;
        -p | --passwd)
            PASSWD="$2"
            shift 2
            ;;
        -h | --host)
            HOST="$2"
            shift 2
            ;;
        -P | --port)
            PORT="$2"
            shift 2
            ;;
        -V | --version)
            MENU=1
            shift
            ;;
        -S)
            DBSOCK="$2"
            shift 2
            ;;
        -e)
            MENU=2
            STATEMENT="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        esac
    done
    if [ -z "$DBSOCK" ]; then
        CONN="-h${HOST}"
    else
        CONN="-S${DBSOCK}"
    fi
    # echo "name:$UNAME pwd:$PASSWD ip:$HOST port:$PORT"
    if [ $MENU -eq 0 ]; then
        "${MYSQL_BIN}" -u"${UNAME}" -p"${PASSWD}" "${CONN}" -P"${PORT}" --local-infile=1
    elif [ $MENU -eq 2 ]; then
        "${MYSQL_BIN}" -u"${UNAME}" -p"${PASSWD}" "${CONN}" -P"${PORT}" --local-infile=1 -e "$STATEMENT"
    else
        "${MYSQL_BIN}" --version
    fi
}

# 检测 k8s 是否存在
if command -v kubectl >/dev/null 2>&1; then
    # To start using your cluster, you need to run the following as a regular user:
    #   mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
    #   sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
    if [ -r "$HOME/.kube/config" ]; then
        export KUBECONFIG="$HOME/.kube/config"
    else # Alternatively, if you are the root user, you can run:
        export KUBECONFIG=/etc/kubernetes/admin.conf
    fi

    if command -v helmfile >/dev/null 2>&1; then
        alias hf=helmfile
    fi

    function k() {
        local k8scmd="$1"
        shift
        # 补全k8s命令
        if [[ $k8scmd =~ ^a.*$ ]]; then
            k8scmd='apply'
        elif [[ $k8scmd =~ ^g.*$ ]]; then
            k8scmd='get'
        elif [[ $k8scmd =~ ^desc.*$ ]]; then
            k8scmd='describe'
        elif [[ $k8scmd =~ ^del.*$ ]]; then
            k8scmd='delete'
        elif [[ $k8scmd =~ ^lo.*$ ]]; then
            k8scmd='logs'
        elif [[ $k8scmd =~ ^la.*$ ]]; then
            k8scmd='label'
        elif [[ $k8scmd =~ ^ro.*$ ]]; then
            k8scmd='rollout'
            local rocmd="$1"
            shift
            if [[ $rocmd =~ ^h.*$ ]]; then
                rocmd='history'
            elif [[ $k8scmd =~ ^p.*$ ]]; then
                rocmd='pause'
            elif [[ $k8scmd =~ ^s.*$ ]]; then
                rocmd='status'
            elif [[ $k8scmd =~ ^rst.*$ ]]; then
                rocmd='restart'
            elif [[ $k8scmd =~ ^rsu.*$ ]]; then
                rocmd='resume'
            elif [[ $k8scmd =~ ^u.*$ ]]; then
                rocmd='undo'
            fi
            set -- "$k8scmd" "$@"
        elif [[ $k8scmd =~ ^ed.*$ ]]; then
            k8scmd='edit'
        elif [[ $k8scmd =~ ^exp.*$ ]]; then
            k8scmd='explain'
        elif [[ $k8scmd =~ ^exe.*$ ]]; then
            k8scmd='exec'
            if [[ "$*" != *-it* && "$*" != *"/bin/sh"* && "$*" != *"/bin/bash"* ]]; then
                set -- "$@" '-it' && set -- "$@" '--'
                if kubectl exec "$@" /bin/sh -c '[ -e /bin/bash ]'; then
                    set -- "$@" '/bin/bash'
                else
                    set -- "$@" '/bin/sh'
                fi
            fi
        fi
        # 检查 $1 是否以 "de" 开头，同时检查 $k8scmd 是否等于 "get" 或者 "delete"
        if [[ ("$k8scmd" == "get") || ("$k8scmd" == "delete") ]] && [[ $1 =~ ^de.*$ ]]; then
            shift
            set -- "deploy" "$@"
            if [[ -z "$k8snamespace" ]] && grep -q ' -n ' <<<"$@" 2>/dev/null; then
                set -- "-n" "$@" && set -- "$k8snamespace" "$@" # 没有传递ns就复用上次的ns
            fi
        elif [[ ("$k8scmd" == "apply") || ("$k8scmd" == "create") ]] && [[ $1 != '-f' ]]; then
            set -- "-f" "$@"
        fi
        echo "kubectl $k8scmd" "$@"
        kubectl "$k8scmd" "$@"
    }
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    kcmds=(kubectl helm)
    for kcmd in "${kcmds[@]}"; do
        if command -v "$kcmd" >/dev/null 2>&1 &&
            [ ! -e "$completion_path/$shell/_$kcmd.$shell" ]; then
            ($kcmd completion "$shell") >"$completion_path/zsh/_$kcmd.$shell"
        fi
    done
    unset kcmds
fi

# 检测 docker compose 是否存在
if command -v docker-compose >/dev/null 2>&1; then
    # download docker and docker-compose completion
    # if [ ! -e "$completion_path/$shell/_docker.$shell" ]; then
    #     curl -sSL "https://raw.githubusercontent.com/docker/cli/master/contrib/completion/$shell/_docker" \
    #         -o "$completion_path/$shell/_docker.$shell"
    # fi

    function dc() {
        local dcmd="$1"
        shift
        # 补全docker compose命令
        if [[ $dcmd =~ ^d.*$ ]]; then
            dcmd='down'
        elif [[ ($dcmd =~ ^co.*$) || ("$dcmd" =~ ^t.*$ && "$dcmd" != top) ]]; then
            dcmd='config'
            if [[ "$dcmd" =~ ^t.*$ && "$1" == "" ]]; then
                set -- "-q" "$@"
            fi
        elif [[ $dcmd =~ ^re.*$ ]]; then
            dcmd='restart'
        elif [[ $dcmd =~ ^q.*$ ]]; then
            dcmd='stop'
        elif [[ $dcmd =~ ^lo.*$ ]]; then
            dcmd='logs'
        elif [[ $dcmd =~ ^i.*$ ]]; then
            dcmd='images'
        elif [[ $dcmd =~ ^k.*$ ]]; then
            dcmd='kill'
        elif [[ $dcmd =~ ^e.*$ ]]; then
            dcmd='exec'
            if [[ "$2" == "" ]]; then
                # 检查容器中是否存在 /bin/bash
                if docker-compose exec "$@" [[ -e /bin/bash ]]; then
                    set -- "$@" "/bin/bash"
                else
                    set -- "$@" "/bin/sh"
                fi
            fi
        elif [[ $dcmd =~ ^v.*$ ]]; then
            dcmd='version'
        elif [[ $dcmd == rmi ]]; then
            if [[ $1 == all ]]; then
                docker stop "$(docker ps -qa)" && docker rm "$(docker ps -qa)" && docker rmi "$(docker images -qa)"
            elif [[ $dcmd == none ]]; then
                docker stop "$(docker ps -qf "dangling=true")" && docker rm "$(docker ps -qf "dangling=true")" && docker rmi "$(docker images -qf "dangling=true")"
            fi
            return
        fi
        echo "docker-compose $dcmd" "$@"
        docker-compose "$dcmd" "$@"
    }
fi

# 检测 systemctl 是否存在
if command -v systemctl >/dev/null 2>&1; then
    if [ ! -e "$completion_path"/zsh/_systemctl.zsh ]; then
        curl -sSL https://raw.githubusercontent.com/linuxmint/systemd-rosa/master/shell-completion/systemd-zsh-completion.zsh -o "$completion_path"/zsh/_systemctl.zsh
    fi
    function sc() {
        local scmd="$1"
        shift
        # 补全systemctl命令
        # start
        # stop
        # status
        # restart
        # disable
        # daemon-reload
        if [[ ("$scmd" == start) || ($scmd == r) ]]; then
            scmd='start'
        elif [[ ("$scmd" == stop) || ($scmd =~ ^q.*$) ]]; then
            scmd='stop'
        elif [[ $scmd =~ ^s*$ ]]; then
            scmd='status'
        elif [[ $scmd =~ ^re.*$ ]]; then
            if [[ -z "$1" ]]; then
                scmd='daemon-reload'
                echo "Tips: systemctl reload your's service"
            else
                scmd='restart'
            fi
        elif [[ $scmd =~ ^en.*$ ]]; then
            scmd='enable'
        elif [[ $scmd =~ ^dis.*$ ]]; then
            scmd='disable'
        elif [[ $scmd =~ ^li.*$ ]]; then
            scmd='list-unit-files'
        elif [[ $scmd =~ ^is.*$ ]]; then
            scmd='is-active'
        elif [[ $scmd == def ]]; then
            scmd='get-default' # 列出当前使用的运行级别
            echo "Tips: systemctl set-default runlevel5.target # 3 or 5"
        else
            # 判断参数个数为空, 并且systemctl status $cmd命令可以执行成功
            if [[ -z "$1" ]] && systemctl list-unit-files --type=service | grep -q "$scmd"; then
                set -- "$@" "$scmd" && scmd="status"
            fi
        fi
        echo "systemctl $scmd" "$@"
        systemctl "$scmd" "$@"
    }
fi

# 检测 qemu 是否存在
if command -v qemu-io >/dev/null 2>&1; then
    function q() {
        popd || return
        qemu-system-x86_64 \
            -m 1G \
            -nographic \
            -kernel bzImage \
            -initrd initramfs.img \
            -netdev user,id=eth0,hostfwd=tcp::5555-:22 -device e1000,netdev=eth0 \
            -append "root=/dev/ram rw console=ttyS0 oops=panic panic=1 nokaslr" \
            -smp cores=2,threads=1 \
            -cpu kvm64
        #    -nic user,model={net device mode}, hostfwd=::2222-:22
    }
# qemu-img create -f qcow2 disk.img 10G
# find -print0| cpio -0 -oH newc | gzip -9 > ../initramfs.img
# find . -print0 | cpio -0 -oH newc | xz -9 --check=crc32 -v -T $(nproc) > ../initramfs.img

fi

#function ssh256(){
#for item in $*; do
#    echo "$item"
#    ssh-keygen -lf "$item"
#    echo ---
#done
#}

# 允许生成的core文件无限大
ulimit -c unlimited
if [ "$(id -u)" -eq 0 ]; then
    # %e: 不含路径的可执行文件名 %i: 线程ID(TID) %s: 引发核心转储的信号 %p: 进程ID(PID) %t: 时间戳
    echo "%e-%i-%s-%p-%t.core" >/proc/sys/kernel/core_pattern
fi

# 检测当前 shell 类型
if [ -n "$ZSH_VERSION" ]; then
    # shellcheck disable=SC2206
    fpath=("$completion_path"/zsh $fpath)
elif [ -n "$BASH_VERSION" ]; then
    for file in "$completion_path"/bash/_*; do # shellcheck source=/dev/null
        [ -e "$file" ] && source "$file"
    done
fi
