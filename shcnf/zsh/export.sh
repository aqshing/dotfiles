# shellcheck disable=SC2148
# path_start
export CMAKE_HOME=/opt/cmake
export NODE_HOME=/opt/node
export ZSH_HOME=/opt/zsh
export TMUX_HOME=/opt/tmux
export TCC_HOME=/opt/tcc
export GCC_HOME=/opt/gcc
export OPENCV_HOME=/opt/opencv
export QEMU_HOME=/opt/qemu
export VERILA_HOME=/opt/verilator
export PYTHONHOME=/opt/python
export GOPATH=/opt/go
export JAVA_HOME=/opt/java
export LUA_HOME=/opt/lua
export REDIS_HOME=/opt/redis
# path_end
filename="$HOME/.config/zsh/export.sh"
# $1: filename="$HOME/.config/zsh/export.sh"
function AddPATH() {
local f=$(($(grep -n -m 1 '# path_start' "$1" | cut -f1 -d:)+1))
local l=$(($(grep -n -m 1 '# path_end' "$1" | cut -f1 -d:)-1))
local s i lines tpath haspkg=false # 跳过以#开头的行和空行
s=$(sed -ne"${f},${l} {/^#/d; /^\s*$/d; p}" "$1")
# 判断在bash中还是zsh中
if [[ "$0" == "AddPATH" ]]; then # zsh 将变量导入到PATH中
    lines=("${(@f)s}")
else # bash 将变量导入到PATH中
    while IFS= read -r line; do
        lines+=("$line") # 将变量 s 中的内容按行分割为数组
    done <<< "$s"
fi
[ "$(command -v pkg-config)" ] && haspkg=true
for i in "${lines[@]}"; do
    tpath=${i##*=}
    if [ -e "${tpath}/bin" ]; then
        PATH=$PATH:"${tpath}/bin"
        if [ -e "${tpath}/lib" ]; then
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${tpath}/lib"
        if $haspkg && [ -e "${tpath}/lib/pkgconfig" ]; then
            PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"${tpath}/lib/pkgconfig"
        fi
        fi
        if [ -e "${tpath}/lib64" ]; then
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"${tpath}/lib64"
        if $haspkg && [ -e "${tpath}/lib64/pkgconfig" ]; then
            PKG_CONFIG_PATH=$PKG_CONFIG_PATH:"${tpath}/lib64/pkgconfig"
        fi
        fi
    else #eval echo "$""$(sed -ne 's/export\s//g' -e 's/=.*//gp' <<< "${s}")"
        unset "$(sed -ne 's/export\s//g' -e 's/=.*//gp' <<< "${i}")"
    fi
done
}
#AddPATH "$0" && unset AddPATH
AddPATH "$filename" && unset AddPATH

function AddMYPATH() {
local MYPATH="$HOME/.local/bin:/snap/bin:/C/Program Files/Go/bin:/C/Program Files (x86)/Microsoft/Edge/Application:/c/Python310:/c/Python310/Scripts"

IFS=$'\n'
for f in $(echo "$MYPATH" | sed 's/:/\n/g'| sort); do
    if [ -e "$f" ]; then
        PATH=$PATH:"$f"
    fi
done
}
AddMYPATH && unset AddMYPATH
# shellcheck disable=SC2155 # PKG链接库 去重
export PKG_CONFIG_PATH=$(echo "$PKG_CONFIG_PATH" | sed 's/:/\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
# shellcheck disable=SC2155 # C/C++动态库 去重
export LD_LIBRARY_PATH=$(echo "$LD_LIBRARY_PATH" | sed 's/:/\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
# shellcheck disable=SC2155 # 环境变量 去重
export PATH=$(echo "$PATH" | sed 's/:/\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
