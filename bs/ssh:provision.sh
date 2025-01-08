#! /usr/bin/env bash

source /home/rg/Code/websites/choons.rgrannell.xyz/.env

ssh -i $CHOONS_KEYPATH "$CHOONS_USER@$CHOONS_IP" << 'EOF'
sudo apt update
sudo apt upgrade -y
sudo apt install -y vim ffmpeg

sudo useradd --system --no-create-home --group --shell /usr/sbin/nologin navidrome

sudo mkdir /opt/navidrome
sudo mkdir /var/lib/navidrome

sudo install -d -o navidrome -g navidrome /opt/navidrome
sudo install -d -o navidrome -g navidrome /var/lib/navidrome

wget https://github.com/navidrome/navidrome/releases/download/v0.54.3/navidrome_0.54.3_linux_amd64.tar.gz -O Navidrome.tar.gz
sudo tar -xvzf Navidrome.tar.gz -C /opt/navidrome/
sudo chmod +x /opt/navidrome/navidrome
sudo chown -R <user>:<group> /opt/navidrome

sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/deb/debian/caddy-stable.list' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

echo 'done'
EOF

rsync -avz -e "ssh -i $CHOONS_KEYPATH" /home/rg/Code/websites/choons.rgrannell.xyz/config/navidrome.service "$CHOONS_USER@$CHOONS_IP":/etc/systemd/system/navidrome.service
rsync -avz -e "ssh -i $CHOONS_KEYPATH" /home/rg/Code/websites/choons.rgrannell.xyz/config/navidrome.toml "$CHOONS_USER@$CHOONS_IP":/var/lib/navidrome/navidrome.toml
rsync -avz -e "ssh -i $CHOONS_KEYPATH" /home/rg/Code/websites/choons.rgrannell.xyz/config/Caddyfile "$CHOONS_USER@$CHOONS_IP":/etc/caddy/Caddyfile

ssh -i $CHOONS_KEYPATH "$CHOONS_USER@$CHOONS_IP" << 'EOF'

sudo systemctl daemon-reload
sudo systemctl stop navidrome.service
sudo systemctl start navidrome.service
sudo systemctl status navidrome.service
sudo systemctl enable navidrome.service

sudo systemctl enable caddy
sudo systemctl start caddy
sudo systemctl reload caddy

EOF
