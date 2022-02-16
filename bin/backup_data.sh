#!/bin/bash -   
#title          :backup_data.sh
#description    :Backup data from laptop to pc
#author         :Tassilo Neubauer
#date           :20220102
#version        :0.1    
#usage          :./backup_data.sh
#notes          :       
#bash_version   :5.1.4(1)-release
#============================================================================

sudo mount /media/tassilo/backup
# Setting this, so the repo does not need to be given on the commandline:
#
export BORG_REPO='/media/tassilo/backup/borgE15/'

# See the section "Passphrase notes" for more infos.
#export BORG_PASSPHRASE='XYZl0ngandsecurepa_55_phrasea&&123'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                            \
    --verbose                          \
    --filter AME                       \
    --list                             \
    --stats                            \
    --show-rc                          \
    --exclude-caches                   \
    --exclude '/home/*/.cache/*'       \
    --exclude '/home/*/CacheStorage/*' \
    --exclude '/home/*/CacheStorage/*' \
    --exclude '/var/tmp/*'             \
                                       \
    ::'{hostname}-{now}'               \
    /etc                               \
    /home                              \
    /root                              \
    /var                               \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}

#do borg backup stuff, if the thing is actually mounted otherwise inform that

sudo umount /media/tassilo/backup
