#!/bin/bash
wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

read SERVER_PUBLIC_KEY < /etc/wireguard/publickey
read SERVER_PRIVATE_KEY < /etc/wireguard/privatekey

# Add configuration
cat >> /etc/wireguard/wg0.conf << EOF
[Interface]
Address = 10.0.0.1/24
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51830
PrivateKey = $SERVER_PRIVATE_KEY

EOF

systemctl enable wg-quick@wg0
systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0
wg show wg0

echo 1 > /etc/wireguard/last_used_ip.var
