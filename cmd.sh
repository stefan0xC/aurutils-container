#!/bin/bash

script_dir=$(dirname "$0")

mkdir -p $SRV_PATH/aur/{repo/custom,gpg,cache,sync}

aur_run()
{
	podman run \
		-v $SRV_PATH/aur/repo/custom:/home/custompkgs \
		-v $SRV_PATH/aur/gpg:/home/user/gpg:Z \
		-v $script_dir/entrypoint.sh:/opt/entrypoint.sh \
		-v $SRV_PATH/aur/cache:/var/cache/pacman/pkg \
		-v $SRV_PATH/aur/sync:/var/lib/pacman/sync \
		--dns=1.1.1.1 \
		--entrypoint=/opt/entrypoint.sh \
		--rm -ti \
		--name aur \
		--user user \
		archlinux-aurutils \
		"$@"
}
