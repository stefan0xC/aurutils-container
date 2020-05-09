#!/bin/bash

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

if [ ! -f "$PUBLIC_KEY" ]
then
	echo "$PUBLIC_KEY does not exist!"
	exit -1
fi
if [ ! -f "$PRIVATE_KEY" ]
then
	echo "$PRIVATE_KEY does not exist!"
	exit -1
fi

aur_run gpg --import /home/user/private.key
aur_run sudo pacman-key --init
aur_run sudo pacman-key --populate
aur_run sudo pacman-key -a /home/user/public.key
aur_run repo-add -s /home/custompkgs/custom.db.tar
aur_run sudo pacman -Sy
