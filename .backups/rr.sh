#!/bin/bash
###################################################
# Filename: rr.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: rm
# Created: 2022-06-09 16:50:33
# Changed: 2022-06-09 19:55:04
###################################################

TRASH_PRIFIX="/tmp"

function Trash()
{
    local t
    if [ ! -d "$TRASH_PRIFIX/.backups" ]; then
	    mkdir "$TRASH_PRIFIX/.backups"
    fi

    if [ ! -e "$HOME/.trash" ]; then
		echo 0 > "$HOME/.trash"
	fi

    nowtime=$(date +%Y-%m-%d_%H:%M:%S)
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$TRASH_PRIFIX/.backups/$filename.$nowtime"
	done

    t=$(cat "$HOME/.trash")
    t=$((t+1))
    echo $t > "$HOME/.trash"

    if [ "$t" -gt 10 ]; then
        rm "$HOME/.trash"
        rm -rf "$TRASH_PRIFIX/.backups"
    fi
}

Trash "$@"
exit  "$?"
