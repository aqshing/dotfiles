# path_start
export CMAKE_HOME=/opt/cmake
export NODE_HOME=/opt/node
export TMUX_HOME=/opt/tmux
export TCC_HOME=/opt/tcc
export GCC_HOME=/opt/gcc
export OPENCV_HOME=/opt/opencv
export PYTHON_HOME=/opt/python
export VERILA_HOME=/opt/verilator
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
local s i
# 判断在bash中还是zsh中
if [[ "$0" == "AddPATH" ]]; then
#zsh 将变量导入到PATH中
for ((i=$f; i<=$l; i++)) {
	if [[ $i == "#"* ]]; then
        continue  # 跳过以#开头的行
    fi

	s=${"$(<$1)"[(f)$i]}
    if [ -e "${s##*=}/bin" ]; then
        PATH=$PATH:"${s##*=}/bin"
    else
        #eval echo "$""$(sed -ne 's/export\s//g' -e 's/=.*//gp' <<< "${s}")"
        unset "$(sed -ne 's/export\s//g' -e 's/=.*//gp' <<< "${s}")"
    fi
}
else
#bash 将变量导入到PATH中
s=$(sed -n "${f},${l}p" "$1")
IFS=$'\n'
for i in ${s}; do
	if [[ $i == "#"* ]]; then
        continue  # 跳过以#开头的行
    fi

    if [ -e "${i##*=}/bin" ]; then
        PATH=$PATH:"${i##*=}/bin"
    else
        unset "$(sed -ne 's/export\s//g' -e 's/=.*//gp' <<< "${i}")"
    fi
done
fi
}
#AddPATH "$0" && unset AddPATH
AddPATH "$filename" && unset AddPATH

# PKG链接库
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PYTHON_HOME/lib/pkgconfig:/opt/opencv/lib/pkgconfig
# C/C++动态库
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv/lib:$PYTHON_HOME/lib
# 环境变量
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
#export PATH=$(echo "$PATH" | sed 's/:/\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
