#!/bin/bash -   
#title          :github-clone.sh
#description    :Use git clone with ssh instead of http address. Use 
#author         :Tassilo Neubauer
#date           :20211208
#version        :0.1    
#usage          :./github-clone.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================
inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)" #https://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository

#repos="$HOME/repos/"

#echo "Going into $repos directory"
#if [ 
#cd "$repos" || echo "$repos directory does not exist. github-clone aborting"
#TODO check if in repos directory and whether to continue

if [ "$inside_git_repo" ]; then #checks if inside git repository: 
	read -p "You are inside a git repository. Github-clone will create a new submodule for you. Are you sure you want to continue?" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "Downloading and Installing git submodule"
	echo "$1" | sed 's/.*github.com\//git@github.com:/' | sed 's/$/.git/' | xargs git submodule add
	git submodule update --init --recursive
	fi
else
	echo "Downloading and installing git repository"
	echo "$1" | sed 's/.*github.com\//git@github.com:/' | sed 's/$/.git/' | xargs git clone --recurse-submodules
fi;


