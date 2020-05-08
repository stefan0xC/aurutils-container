#!/bin/bash

sudo chown -R user:user /home/custompkgs
sudo -u user gpg --import /home/user/gpg/secret.asc 2> /dev/null
sudo -u user gpg --import /home/user/gpg/public.asc 2> /dev/null
sudo pacman-key -a /home/user/gpg/public.asc 2> /dev/null
exec $@
