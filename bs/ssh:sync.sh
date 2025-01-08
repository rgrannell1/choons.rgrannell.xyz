#! /usr/bin/env bash

source /home/rg/Code/websites/choons.rgrannell.xyz/.env

sudo mkdir -p /mnt/volume_ams3_01/music
rsync -avz -e "ssh -i $CHOONS_KEYPATH" music/ $CHOONS_USER@$CHOONS_IP:/mnt/volume_ams3_01/music
