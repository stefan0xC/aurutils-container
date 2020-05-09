#!/bin/bash

AUR_PACKAGE_URL="https://aur.bagru.at/custom/aurutils-git-2.3.1.r33.g859f9a6-1-any.pkg.tar.xz"
container=$(buildah from archlinux)

echo "pacman -Syu devtools pacman-contrib base-devel vi"
buildah run $container pacman -Syu devtools pacman-contrib base-devel vi --noconfirm
echo "install aurutils"
buildah run $container curl ${AUR_PACKAGE_URL} -o aurutils-git.pkg.tar.xz
buildah run $container pacman -U aurutils-git.pkg.tar.xz --noconfirm
echo "remove package cache"
buildah run $container pacman -Sc --noconfirm

echo "create user"
buildah run $container useradd -m user
buildah run $container sed -i "$ a user ALL=(ALL) NOPASSWD: ALL" /etc/sudoers

echo "create /home/custompkgs"
buildah run $container install -d /home/custompkgs -o user -g user
echo "enable custom repo"
LINESTART=$(buildah run $container grep -nr "\[custom\]" /etc/pacman.conf | cut -d : -f1)
LINEEND=$((LINESTART+2))
buildah run $container sed -i "${LINESTART},${LINEEND} s/#//" /etc/pacman.conf

buildah run $container chown -R user:user /home

echo "commit image"
buildah commit $container archlinux-aurutils
buildah rm $container
