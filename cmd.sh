#!/bin/bash

script_dir=$(dirname "$0")

# persistent directories
SRV_DIR=${SRV_DIR:-/srv}
AUR_GNUPG_DIR=${AUR_GNUPG_DIR:-$SRV_DIR/aur/user_gpg}
CUSTOM_REPO_DIR=${CUSTOM_REPO_DIR:-$SRV_DIR/aur/repo/custom}
PACMAN_GNUPG_DIR=${PACMAN_GNUPG_DIR:-$SRV_DIR/aur/pacman_gnupg}
PACMAN_CACHE_DIR=${PACMAN_CACHE_DIR:-$SRV_DIR/aur/cache}
PACMAN_DBSYNC_DIR=${PACMAN_DBSYNC_DIR:-$SRV_DIR/aur/sync}


# create the directories if the don't exist
mkdir -p $CUSTOM_REPO_DIR \
	$AUR_GNUPG_DIR \
	$PACMAN_GNUPG_DIR \
	$PACMAN_CACHE_DIR \
	$PACMAN_DBSYNC_DIR

aur_run()
{

	podman run \
		-v $CUSTOM_REPO_DIR:/home/custompkgs:z \
		-v $AUR_GNUPG_DIR:/home/user/.gnupg:z \
		-v $PACMAN_CACHE_DIR:/var/cache/pacman/pkg:z \
		-v $PACMAN_DBSYNC_DIR:/var/lib/pacman/sync:z \
		-v $PACMAN_GNUPG_DIR:/etc/pacman.d/gnupg:z \
		-v $script_dir/entrypoint.sh:/opt/entrypoint.sh:z \
		--dns=1.1.1.1 \
		--entrypoint=/opt/entrypoint.sh \
		--rm -ti \
		--name aur \
		--user user \
		archlinux-aurutils \
		"$@"

	# if podman is run as rootless: root is mapped to the id from $USER
	# while the rest are shifted by 100000 (depending on the value in /etc/subuid)
	if [ "$EUID" -ne 0 ]
	then
		podman unshare chown -R 0:0 ${AUR_GNUPG_DIR} ${CUSTOM_REPO_DIR}
	fi
}
