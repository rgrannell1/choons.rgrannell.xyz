#! /usr/bin/env bash

source /home/rg/Code/websites/choons.rgrannell.xyz/.env

ssh -i $CHOONS_KEYPATH "$CHOONS_USER@$CHOONS_IP"
