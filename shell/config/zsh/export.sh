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
# path_end

function AddPATH() {
local filename="$HOME/.config/zsh/export.sh"
local f=$(($(grep -n -m 1 '# path_start' "$filename" | cut -f1 -d:)+1))
local l=$(($(grep -n -m 1 '# path_end' "$filename" | cut -f1 -d:)-1))
local s=$(sed -n "${f},${l}p" "$filename")
IFS=$'\n'
for i in ${s}; do
    if [ -e "${i##*=}/bin" ]; then
        PATH=$PATH:"${i##*=}/bin"
    fi
done
}
AddPATH && unset AddPATH
# PKG链接库
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PYTHON_HOME/lib/pkgconfig:/opt/opencv/lib/pkgconfig
# C/C++动态库
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv/lib:$PYTHON_HOME/lib
# 环境变量
export PATH=$PATH:$HOME/.local/bin:/snap/bin
export PATH=$(echo "$PATH" | sed 's/:/\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
