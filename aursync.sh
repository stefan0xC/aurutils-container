#!/bin/bash

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

if [ -z "$(ls -A $AUR_GNUPG_DIR)" ]
then
	echo "$AUR_GNUPG_DIR is empty, you should run pacman-init.sh first."
	exit -1
fi

aur_run aur sync -R -r -S --noconfirm "$@"
