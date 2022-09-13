##/bin/bash
###################################################
# Filename: daemon.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: termux background process
# Created: 2022-06-09 01:07:35
# Changed: 2022-06-09 01:07:35
###################################################

if ! pgrep -x "sshd" > /dev/null ;then
	sshd
	mydaemon mysqld_safe
fi
