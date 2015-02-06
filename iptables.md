### rules ###

 iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o net -j MASQUERADE
 iptables -A FORWARD -s 10.0.1.0/24 -i net -j ACCEPT

-A OUTPUT -o virbr0 -p udp -m udp --dport 68 -j ACCEPT
 added for ip forward

[network](http://wiki.qemu.org/Documentation/Networking/NAT)

### what is work ###
**!!! important**

` iptables -t nat -A POSTROUTING -s 10.0.1.0/24 ! -d 10.0.1.0/24 -j MASQUERADEa`


### port forward ###

` iptables -t nat  -A PREROUTING -d 192.168.3.130/32 -i br0 -p tcp -m tcp --dport 16666 -j DNAT --to-destination 10.0.1.212:22`
