#!/bin/bash

HOME_DIR="/home/$(whoami)"
dotfiles=("kitty" "nvim" "sway" "waybar" "yazi")

for folder in "${dotfiles[@]}"; do 
    if [ -d "$HOME_DIR/.config/$folder/" ]; then
        echo -e "ERROR: $folder. Config files already exist. Remove ~/.config/$folder/ to overwrite them.\n" >&2
    else
        ln -s "$HOME_DIR/dotfiles/$folder/" "$HOME_DIR/.config/"
        if [ $? -ne 0 ]; then
            echo -e "ERROR: 'ln -s $HOME_DIR/dotfiles/$folder/ $HOME_DIR/.config/' failed to execute\n" >&2
            continue
        else
            echo -e "$folder: done\n"
        fi
    fi
done
