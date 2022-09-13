alias vi='nvim'
alias du='du -sh'
alias ansible='python /opt/ansible'
alias ansible-playbook='python /opt/ansible-playbook'

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
    echo -e "\033[32m"  "    [ -u | --uname  ]    -- 用户名"  "\033[0m"
    echo -e "\033[32m"  "    [ -p | --passwd ]    -- 密码"  "\033[0m"
    echo -e "\033[32m"  "    [ -h | --host   ]    -- IP"  "\033[0m"
    echo -e "\033[32m"  "    [ -P | --port   ]    -- 端口"  "\033[0m"
    echo -e "\033[32m"  "    [ -V | --version]    查看版本信息"  "\033[0m"
    echo -e "\033[32m"  "    [ -e \"sql语句\"  ]    执行sql语句"  "\033[0m"
    echo " "

    return 1
fi
# 刷新参数列表 等号替换为空格
eval set -- "$ARGS"
while :
do
    case "$1" in
        -u | --uname)            UNAME="$2"     ; shift 2  ;;
        -p | --passwd)           PASSWD="$2"    ; shift 2  ;;
        -h | --host)             HOST="$2"      ; shift 2  ;;
        -P | --port)             PORT="$2"      ; shift 2  ;;
        -V | --version)          MENU=1         ; shift    ;;
        -e)      MENU=2;    STATEMENT="$2"      ; shift 2  ;;
        --) shift; break ;;
    esac
done
# echo "name:$UNAME pwd:$PASSWD ip:$HOST port:$PORT"
if [ $MENU -eq 0 ]; then  
"${MYSQL_BIN}" -u"${UNAME}" -p"${PASSWD}" -h"${HOST}" -P"${PORT}" --local-infile=1
elif  [ $MENU -eq 2 ]; then 
"${MYSQL_BIN}" -u"${UNAME}" -p"${PASSWD}" -h"${HOST}" -P"${PORT}" --local-infile=1 -e "$STATEMENT"
else
"${MYSQL_BIN}" --version
fi
}

# install greatdb
function indb() {
	cd /opt/greatdb-ansible-master || return 1;
	ansible-playbook deploy.yml -i inventory/deploy.ini -v
}
# upgrade greatdb
alias update='ansible-playbook upgrade.yml -i inventory/upgrade.ini -v'
alias upgrade='ansible-playbook upgrade.yml -i inventory/upgrade.ini -v'
function updb() {
	cd /opt/greatdb-ansible-master || return 1;
	ansible-playbook upgrade.yml -i inventory/deploy.ini -v
}
# clean greatdb
alias clean='ansible-playbook cleanup.yml -i inventory/deploy.ini -v'
function cldb() {
	cd /opt/greatdb-ansible-master || return 1;
	ansible-playbook cleanup.yml -i inventory/deploy.ini -v
}
##alias el='vi /greatdb/log'
##if [ -z "$TMUX" ]; then
##    tmux attach -t default || tmux new -s default
##fi
