set up an Arch Linux container that compiles custom AUR packages
================================================================

what is needed?
---------------

* base image: archlinux:latest
* gnupg-key for signing
* volumes to mount to store the repository


build a container
-----------------

 1. install aurutils from aur
 2. configure custom repository
    add [custom] section to /etc/pacman.conf
 3. add user
 4. entrypoint.sh to add custom gpg-key [needs revision]

see build-aur-image.sh for details


how does the container work?
----------------------------

you need to mount some volumes

* /home/custompkgs
* /home/user/gpg [needs revision]
* /var/cache/pacman/pkg
* /var/lib/pacman/sync 


if you run with --rm the container is deleted.
see `aur*.sh` on how to run the container

