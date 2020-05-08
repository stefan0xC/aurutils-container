#!/bin/bash
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
	  aur sync -r -s "$@"
