#!/bin/bash

container=$(buildah from archlinux)

echo "pacman -Syu devtools pacman-contrib base-devel vi"
buildah run $container pacman -Syu devtools pacman-contrib base-devel vi --noconfirm

echo "create user"
buildah run $container useradd -m user
buildah run $container sed -i "$ a user ALL=(ALL) NOPASSWD: ALL" /etc/sudoers

echo "install aurutils"
if [ -z "$AURUTILS_PACKAGE_FILE" ]
then
    buildah copy --chown user:user $container https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils-git.tar.gz /tmp/aurutils-git.tar.gz
    buildah config --workingdir /tmp $container
    buildah run --user user $container tar xzf aurutils-git.tar.gz
    buildah config --workingdir /tmp/aurutils-git $container
    buildah run --user user $container makepkg -s -i --noconfirm 
else
    buildah copy $container $AURUTILS_PACKAGE_FILE /tmp/aurutils-git.pkg.tar.xz
    buildah run $container pacman -U /tmp/aurutils-git.pkg.tar.xz --noconfirm
fi

echo "remove package cache"
buildah run $container pacman -Sc --noconfirm

echo "create /home/custompkgs"
buildah run $container install -d /home/custompkgs -o user -g user
echo "enable custom repo"
LINESTART=$(buildah run $container grep -nr "\[custom\]" /etc/pacman.conf | cut -d : -f1)
LINEEND=$((LINESTART+2))
buildah run $container sed -i "${LINESTART},${LINEEND} s/#//" /etc/pacman.conf

buildah run $container chown -R user:user /home
buildah config --workingdir /home/user $container

echo "commit image"
buildah commit $container archlinux-aurutils
buildah rm $container
