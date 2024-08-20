#!/bin/sh

protected_branch='dev'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $protected_branch = $current_branch ]
then
    echo "You're about to push to dev, is that what you intended? [y|n]"
    read -r answer
    if echo "$answer" | grep -iq "^y" ;then
        exit 0
    fi
    exit 1
fi
exit 0
