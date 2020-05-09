#!/bin/bash

sudo chown -R user:user /home/custompkgs
sudo chown -R user:user /home/user
sudo chmod 700 /home/user/.gnupg
exec $@
