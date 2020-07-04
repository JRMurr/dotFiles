#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $script_dir

delete_and_link() {
    link_path=$1
    dest_path=$2
    rm -rf $link_path
    ln -s $script_dir/$dest_path $link_path
}

# Fish
echo "Initializing fish..."
delete_and_link ~/.config/fish fish
echo "  You'll need to install fish and set it as your shell manually"

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig