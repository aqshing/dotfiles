#!/usr/bin/env bash
############################################################
# Filename: download_bin.sh
# Author: aqshing
# Email: jdbc.cc <work@jdbc.cc>
# Brief:
# Created: 2024-05-22 20:08:05
# Changed: 2024-05-22 20:11:51
############################################################
# set -Exeo pipefail # if '*' not match, return a null string
command -v shopt >/dev/null 2>&1 && shopt -s nullglob

exec_array=(btm dust grex htop ncdu tldr tmux tokei)

install_path=$HOME/.local/bin

for cmd in "${exec_array[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd is installed in $install_path."
    else
        echo "$cmd is not installed."
        echo "Installing $cmd..."
    fi
done