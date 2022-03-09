apt update && apt upgrade -y
apt install wireguard qrencode git -y
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
