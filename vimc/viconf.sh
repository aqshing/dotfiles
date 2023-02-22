#!/bin/bash
###################################################
# Filename: configure.sh
# Author: shing
# E-mail: www.asm.best
# Created: Fri 09 Oct 2020 07:18:13 PM CST
# Changed: 2022-07-01 17:00:41
###################################################

##set -xeuo pipefail

function Transh()
{
	if [ ! -d $HOME/.backups ]; then
	    mkdir $HOME/.backups
	fi

	nowtime=`date +%Y-%m-%d_%H:%M:%S`
	for i in $*;
	do
		filename=`basename $i`
		mv $i $HOME/.backups/$filename.$nowtime
	done
}

cd $(dirname $0)
echo $(dirname $0)

if [ ! -d $HOME/.vim ]; then
	mkdir $HOME/.vim
fi
cp -r -a ./vim/* $HOME/.vim

if [ -e $HOME/.vimrc ]; then
	Transh $HOME/.vimrc
fi
cp ./vimrc $HOME/.vimrc

##cp ./nvim.appimage $HOME/optapp/neovim/bin
##cd $HOME/optapp/neovim/bin
##chmod u+x nvim.appimage
##ln -s nvim.appimage nvim
##ln -s nvim.appimage vi
##cd -

if [ ! -e $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
	git clone https://github.com/junegunn/vim-plug.git $HOME/.local/share/nvim/site/autoload
fi


##vi +PlugInstall
