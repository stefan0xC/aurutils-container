set up an Arch Linux container that compiles custom AUR packages
================================================================

what is needed?
---------------

* base image: archlinux:latest
* gnupg-key for signing [TODO: make signing optional?]
* volumes to mount to store the repository and auxiliary files


build a container
-----------------

 1. install aurutils from aur [TODO: build it if you don't supply `AURUTILS_URL`]
 2. configure custom repository
    add [custom] section to /etc/pacman.conf
 3. add user
 4. entrypoint.sh to add custom gpg-key

see build-aur-image.sh for details


usage
-----

 1. you need to generate or export a private and public key for key signing to work.
save them as `private.key` and `public.key` or specify the environment variables

 2. if you already have a custom repository, set the environment variable `CUSTOM_REPO_DIR`
to the directory of the repository. e.g. `export CUSTOM_REPO_DIR=/home/custompkgs`

 3. by default the directories will be located under /srv/aur if you want to change them
 see `cmd.sh` for other environment variables you can set.

on the first run, you should run `pacman-init.sh`.

NOTE: if you don't use custom.db.tar you may want to adapt the following scripts:
* `cmd.sh`
* `pacman-init.sh`
* `build-aur-image.sh`
