#!/bin/bash

script_dir=$(dirname "$0")
. $script_dir/cmd.sh

aur_run aur sync -r -s "$@"
