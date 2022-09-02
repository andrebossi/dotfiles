#!/usr/bin/env bash

git clone --bare https://github.com/andrebossi/dotfiles.git $HOME/.dotfiles
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bash_aliases
source $HOME/.bash_aliases
dotfiles checkout
