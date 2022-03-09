# WG Automation

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
