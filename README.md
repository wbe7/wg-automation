# WG Automation

## Prerequisites

1. You should open port 51830 on your server.
2. This automation has been tested on an Ubuntu 20.04 server.

## Install Command

```bash
apt update && apt upgrade -y
apt install wireguard qrencode git -y
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
git clone https://gitlab.com/wbe7/wg-automation.git
```

## Init WG server configuration

```bash
./init.sh
```

## Add new user

```bash
./add-client.sh user1
```
