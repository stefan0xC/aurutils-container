#!/bin/bash

container=$(buildah from archlinux)

echo "pacman -Syu devtools pacman-contrib base-devel vim vifm"
buildah run $container pacman -Syu devtools pacman-contrib base-devel vim vifm --noconfirm --needed

echo "create user"
buildah run $container useradd -m user
buildah run $container sed -i "$ a user ALL=(ALL) NOPASSWD: ALL" /etc/sudoers

echo "install aurutils"
if [ -z "$AURUTILS_PACKAGE_FILE" ]
then
    buildah copy --chown user:user $container https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils.tar.gz /tmp/aurutils.tar.gz
    buildah config --workingdir /tmp $container
    buildah run --user user $container tar xzf aurutils.tar.gz
    buildah config --workingdir /tmp/aurutils $container
    buildah run --user user $container gpg --recv-keys DBE7D3DD8C81D58D0A13D0E76BC26A17B9B7018A
    buildah run --user user $container makepkg -s -i --noconfirm
else
    buildah copy $container $AURUTILS_PACKAGE_FILE /tmp/aurutils.pkg.tar.xz
    buildah run $container pacman -U /tmp/aurutils.pkg.tar.xz --noconfirm
fi

echo "remove package cache"
buildah run $container pacman -Sc --noconfirm

echo "create /home/custompkgs"
buildah run $container install -d /home/custompkgs -o user -g user
echo "copy pacman-extra.conf from devtools"
buildah run $container cp /usr/share/devtools/pacman-extra.conf /etc/aurutils/pacman-custom.conf

echo "enable custom repo"
LINESTART=$(buildah run $container grep -nr "\[custom\]" /etc/pacman.conf | cut -d : -f1)
LINEEND=$((LINESTART+2))
buildah run $container sed -i "${LINESTART},${LINEEND} s/#//" /etc/pacman.conf

buildah run $container chown -R user:user /home
buildah config --workingdir /home/user $container

echo "commit image"
buildah commit $container archlinux-aurutils
buildah rm $container
