#!/bin/bash

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

if [ ! -f "$GPG_PRIVATE_KEY" ]
then
	echo "$GPG_PRIVATE_KEY does not exist!"
	exit -1
fi

aur_run echo "$GPG_PRIVATE_KEY" > /home/user/private.key
aur_run gpg --import /home/user/private.key
aur_run sudo pacman-key --init
aur_run sudo pacman-key --populate
aur_run repo-add -s /home/custompkgs/custom.db.tar
aur_run sudo pacman -Sy
