###rules###

 iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o net -j MASQUERADE

 added for ip forward
