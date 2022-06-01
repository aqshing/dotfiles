#!/data/data/com.termux/files/usr/bin/bash
###################################################
# Filename: termux.sh
# Author: shing
# Email: www.asm.best
# Created: 2020年11月23日 星期一 14时04分59秒
# Changed: 2021-09-10 14:31:36
###################################################

##set -xeuo pipefail

function Transhman()
{
	if [ ! -d "$HOME/.backups" ]; then
	    mkdir "$HOME/.backups"
	fi

	nowtime=$(date +%Y-%m-%d_%H:%M:%S)
	for i in "$@";
	do
		filename=$(basename "$i")
		mv "$i" "$HOME/.backups/$filename.$nowtime"
	done
}

echo -e "Installing dependencies ..."
## 必安装
## C/C++ code base
pkg install -y clang cmake zsh vim-python git
pkg install -y libcurl curl wget unzip file
## 选安装
## Third-party tools
pkg install -y openssh python nodejs neovim
pkg install -y nginx php mariadb
## Third-party libs
pkg install -y perl openssl openssl-tool ffmpeg
## Better *nux tools
pkg install -y htop bat zip ncdu ag fd
pkg install -y tree unrar bat zip
## C/C++ code tools
pkg install -y gdb valgrind doxygen ctags
## optional tools
pkg install -y nmap
echo -e "Successfully Installed"


if [ -d "$HOME/.termux" ]; then
    Transhman "$HOME/.termux"
fi

if [ ! -d $HOME/.termux ]; then
    mkdir $HOME/.termux
fi

#curl -fsLo $HOME/.termux/colors.properties --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/colors.properties
#curl -fsLo $HOME/.termux/termux.properties --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/termux.properties
#curl -fsLo $HOME/.termux/font.ttf --create-dirs https://github.com/einverne/dotfiles/raw/master/termux/font.ttf

#git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh --depth 1
#cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
#sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' $HOME/.zshrc
chsh -s zsh

cd $(dirname $0)
cd ../shell
chmod u+x zinit.sh
source zinit.sh

termux-setup-storage
termux-reload-settings

echo "Done! "

exit

##cp ./termux.properties ~/.termux/termux.properties
##echo "extra-keys=[ \
##['ESC','CTRL','ALT','|','PGUP','HOME','UP','END'], \
##['TAB','~','/','\"','PGDN','LEFT','DOWN','RIGHT']]" \
##> ~/.termux/termux.properties
