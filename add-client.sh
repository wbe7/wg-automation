#!/bin/bash

# We read from the input parameter the name of the client
if [ -z "$1" ]
  then 
    read -p "Enter VPN user name: " USERNAME
    if [ -z $USERNAME ]
      then
      echo "[#]Empty VPN user name. Exit"
      exit 1;
    fi
  else USERNAME=$1
fi


mkdir -p /etc/wireguard/clients/$USERNAME
wg genkey | tee /etc/wireguard/clients/$USERNAME/$USERNAME.privatekey | wg pubkey | tee /etc/wireguard/clients/$USERNAME/$USERNAME.publickey


read SERVER_PUBLIC_KEY < /etc/wireguard/publickey
read SERVER_PRIVATE_KEY < /etc/wireguard/privatekey
read CLIENT_PUBLIC_KEY < /etc/wireguard/clients/$USERNAME/$USERNAME.publickey
read CLIENT_PRIVATE_KEY < /etc/wireguard/clients/$USERNAME/$USERNAME.privatekey

# Read my IP
MYIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"

# We get the following client IP address
read OCTET_IP < /etc/wireguard/last_used_ip.var
OCTET_IP=$(($OCTET_IP+1))
echo $OCTET_IP > /etc/wireguard/last_used_ip.var

CLIENT_IP="10.0.0.$OCTET_IP/32"

# Create a blank configuration file client 
cat > /etc/wireguard/clients/$USERNAME/$USERNAME.conf << EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP
DNS = 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $MYIP:51830
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 20
EOF

# Add new client data to the Wireguard configuration file
cat >> /etc/wireguard/wg0.conf << EOF
[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP

EOF

# Restart Wireguard
systemctl restart wg-quick@wg0

# Show QR config to display
qrencode -t ansiutf8 < /etc/wireguard/clients/$USERNAME/$USERNAME.conf

# Show config file
echo "# Display $USERNAME.conf"
cat /etc/wireguard/clients/$USERNAME/$USERNAME.conf

