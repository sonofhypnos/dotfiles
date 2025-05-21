#!/usr/bin/env bash   
#title          :safe_force_push.sh
#description    :Fix force pushing
#author         :Tassilo Neubauer
#date           :20240521
#version        :0.1    
#usage          :./safe_force_push.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================

for arg in "$@"
do
    shift
    if [ "$arg" == "--force" ]; then
        echo "Consider using --force-with-lease instead of --force to avoid overwriting work."
        arg="--force-with-lease"  # Optionally enforce --force-with-lease
    fi
    set -- "$@" "$arg"
done

# Execute git push with potentially modified arguments
git push "$@"
