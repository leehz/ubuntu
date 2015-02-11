### IPxe Boot step by step ###

1. brctl addbr net
2. ifconfig net 10.0.1.1/24 up
3. edit the `dnsmasq.conf` like `dnsmasq.conf_pxe_boot`
4. /etc/init.d/dnsmasq start 
    - enable tftp server; then you should disable tftp-hpa service `service tftp-hpa stop`
    - configure the `interface` as your need
    - configure `dhcp-sequential-ip`  get a ip in order
    - !! or you can use the command line to start the dnsmasq 
        - `/usr/sbin/dnsmasq  -C /etc/dnsmasq.conf -x /var/run/dnsmasq/dnsmasq.pid -u dnsmasq -r /var/run/dnsmasq/resolv.conf -7 /etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new --local-service`
        - `dnsmasq --strict-order --bind-interfaces --conf-file= --listen-address 10.0.1.1 --dhcp-range 10.0.1.2,10.0.1.254 --dhcp-lease-max=253 --dhcp-no-override --except-interface=lo --interface=net --dhcp-sequential-ip --dhcp-leasefile=/var/lib/misc/dnsmasq.lxcbr0.leases --dhcp-authoritative`
        - ` dnsmasq --strict-order --bind-interfaces  --conf-file= --listen-address 10.0.1.1 --dhcp-range 10.0.1.2,10.0.1.254 --dhcp-lease-max=253 --dhcp-no-override --except-interface=lo --interface=net --dhcp-sequential-ip --enable-tftp --tftp-root=/var/lib/tftpboot --dhcp-match=set:IPXEBOOT,175 --dhcp-option=tag:!IPXEBOOT,67,undionly.kpxe --dhcp-option=67,pxelinux.0   --dhcp-leasefile=/var/lib/misc/dnsmasq.lxcbr0.leases --dhcp-authoritative`
    5. Ipxe boot test !!! PXEBOOT conf is not here!
    qemu-system-x86_64 --enable-kvm -cpu host  -m 2G -net  nic -net tap,script=/etc/ifup,downscript=/etc/ifdown
    example for `/etc/qemu-ifup`
```
#!/bin/sh
set -x

switch=net

if [ -n "$1" ];then
 #       /usr/bin/sudo /usr/sbin/tunctl -u `whoami` -t $1
        /usr/bin/sudo /sbin/ip link set $1 up
        sleep 0.5s
        /usr/bin/sudo /sbin/brctl addif $switch $1
        exit 0
else
        echo "Error: no interface specified"
        exit 1
fi

```

`/etc/qemu-ifdown`
```
#!/bin/sh
set -x

switch=net

echo "Executing /etc/qemu-ifdown"
sudo /sbin/ip link set $1 down
sudo /sbin/brctl delif $switch $1
sudo /sbin/ip link delete dev $1
```
    6. iptables conf for net
` iptables -t nat -A POSTROUTING -s 10.0.1.0/24 ! -d 10.0.1.0/24 -j MASQUERADE` -- enable net
port forward:

` iptables -t nat -A PREROUTING -p tcp -i eth0 --dport 587 -j DNAT \
    --to-destination 10.0.3.100:587`

nothing to be done else! & enjoy it!!!
