#!/usr/bin/env bash

git init --bare $HOME/.dotfiles
dotfiles config --local status.showUntrackedFiles no
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bash_aliases
source $HOME/.bash_aliases

# Example
#dotfiles status
#dotfiles add .vimrc
#dotfiles commit -m "Add vimrc"
#dotfiles add .bashrc
#dotfiles commit -m "Add bashrc"
#dotfiles push
