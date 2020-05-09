#!/bin/bash

if [ $# -eq 0 ]
then
    echo "No package"
    exit -1
fi

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

if [ -z "$(ls -A $AUR_GNUPG_DIR)" ]
then
	echo "$AUR_GNUPG_DIR is empty, you should run pacman-init.sh first."
	exit -1
fi

# remove file from repository
aur_run paccache -rvk 0 -c /home/custompkgs/ "$@"
# remove entry in repository database
aur_run repo-remove -s /home/custompkgs/custom.db.tar "$@"
