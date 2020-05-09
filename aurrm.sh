#!/bin/bash

if [ $# -eq 0 ] then
    echo "No package"
    exit -1
fi

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

# remove file from repository
aur_run paccache -rvk 0 -c /home/custompkgs/ "$@"
# remove entry in repository database
aur_run repo-remove -s /home/custompkgs/custom.db.tar "$@"
