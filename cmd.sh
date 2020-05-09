#!/bin/bash

script_dir=$(dirname "$0")

aur_run()
{
	sudo podman run \
		-v /srv/aur/repo/custom:/home/custompkgs \
		-v /srv/aur/gpg:/home/user/gpg \
		-v $script_dir/entrypoint.sh:/opt/entrypoint.sh \
		-v /srv/aur/cache:/var/cache/pacman/pkg \
		-v /srv/aur/sync:/var/lib/pacman/sync \
		--dns=1.1.1.1 \
		--entrypoint=/opt/entrypoint.sh \
		--rm -ti \
		--name aur \
		--user user \
		archlinux-aurutils \
		"$@"
}
