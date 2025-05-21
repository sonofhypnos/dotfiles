#!/usr/bin/env bash
#title          :enable_services.sh
#description    :Enable systemd services from dotfiles
#author         :Tassilo Neubauer
#date           :20230130
#version        :0.1
#usage          :./enable_services.sh
#notes          :
#bash_version   :5.1.16(1)-release
#============================================================================

# Notify that this should be run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

t_path=$(realpath "./config/systemd/user/borg.timer")
s_path=$(realpath "./config/systemd/user/borg.timer")

systemctl enable "$s_path"
#systemctl enable borg.service
#systemctl enable borg.timer

#cp $(realpath "./config/systemd/user/borg.timer") $HOME config/systemd/user/borg.timer
systemctl start borg.timer

systemctl --user enable writing-tracker.service
systemctl --user enable writing-tracker.timer
systemctl --user start writing-tracker.timer
