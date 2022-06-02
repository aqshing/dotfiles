#!/bin/bash
###################################################
# Filename: work.sh
# Author: aqshing
# Email: aqdebug.com aqdebug@gmail.com
# Brief: 工作中经常用到的别名
# Created: 2022-05-31 14:52:01
# Changed: 2022-06-02 18:49:41
###################################################

alias vi='vim'
alias du='du -sh'
alias ansible='python /opt/ansible'
alias ansible-playbook='python /opt/ansible-playbook'

alias sql='/greatdb/svr/greatdb/bin/greatsql'
alias sc='/greatdb/sh/sqlnode3316.sh'
# install greatdb
alias install='ansible-playbook deploy.yml -i inventory/deploy.ini -v'
# upgrade greatdb
alias update='ansible-playbook upgrade.yml -i inventory/upgrade.ini -v'
alias upgrade='ansible-playbook upgrade.yml -i inventory/upgrade.ini -v'
# clean greatdb
alias clean='ansible-playbook cleanup.yml -i inventory/deploy.ini -v'
##alias el='vi /greatdb/log'

