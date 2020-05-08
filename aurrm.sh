#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No package"
    exit -1
fi

sudo podman run \
	-v /srv/aur/repo/custom:/home/custompkgs \
	-v /srv/aur/gpg:/home/user/gpg \
	-v /srv/aur/cache:/var/cache/pacman/pkg \
	-v /srv/aur/sync:/var/lib/pacman/sync \
	--dns=1.1.1.1 \
	--entrypoint=/home/user/gpg/entrypoint.sh \
	--rm -ti \
	--name aur \
	--user user \
	archlinux-aurutils \
	paccache -rvk 0 -c /home/custompkgs/ "$@"

sudo podman run \
	-v /srv/aur/repo/custom:/home/custompkgs \
	-v /srv/aur/gpg:/home/user/gpg \
	-v /srv/aur/cache:/var/cache/pacman/pkg \
	-v /srv/aur/sync:/var/lib/pacman/sync \
	--dns=1.1.1.1 \
	--entrypoint=/home/user/gpg/entrypoint.sh \
	--rm -ti \
	--name aur \
	--user user \
	archlinux-aurutils \
	  repo-remove -s /home/custompkgs/custom.db.tar "$@"
