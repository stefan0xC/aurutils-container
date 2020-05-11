Set up an Arch Linux container that compiles custom AUR packages
================================================================

Why?
----

In case you want to build packages for Arch Linux e.g. on a Debian host.

What is needed?
---------------

* Base image: archlinux:latest
* GnuPG-keys for signing [TODO: make signing optional?]
* Volumes to mount to store the repository and auxiliary files
* [podman](https://podman.io/) and [buildah](https://buildah.io/)


Build a container
-----------------

 1. Install aurutils from AUR. It should be built only if you don't supply `AURUTILS_PACKAGE_FILE`
 2. Configure custom repository
    add [custom] section to /etc/pacman.conf
 3. Add user (since makepkg shoult not run as root)
 4. entrypoint.sh to add custom gpg-key

See `build-aur-image.sh` for details


Usage
-----

 1. You need to generate or export a private and public key for key signing to work.
Save them as `private.key` and `public.key` or specify the environment variables.

 2. If you already have a custom repository, set the environment variable `CUSTOM_REPO_DIR`
to the directory of the repository. e.g. `export CUSTOM_REPO_DIR=/home/custompkgs`

 3. By default the directories will be located under `/srv/aur`. If you want to change them
 see `cmd.sh` for other environment variables you can set. The purpose of most directories is
 to have an up-to-date repository, so the container does not need to update its repositories,
 pacman cache or the gnupg directories relevant to building packages every time it is run.

On the first run, after creating the image with `build-aur-image.sh`, you should run `pacman-init.sh`.

* `./pacman-init.sh` adds the private key to user gpg, the public key to the pacman keyring and updates the repository databases.
* `./aursync.sh <packagename>` is a wrapper for aur sync -R -r -s
  which builds a package from AUR and adds it to the custom repository.
*`./aurrm.sh <packagename>` is a wrapper that uses paccache and repo-remove to remove a package
  from the repository.
* `./run-bash.sh` is a wrapper to run bash for testing, debugging and maintenance purposes.
* `./cmd.sh` defines how podman is run and sets the volume paths and other configuration for each command.
* `./build-aur-image.sh` creates a new container image based on archlinux and installs aurutils-git from AUR.

NOTE: If you don't want to use **custom** as the repository name, you need to adapt the following scripts:

* `cmd.sh`
* `pacman-init.sh`
* `build-aur-image.sh`

