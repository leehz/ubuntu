### what done ###
    iPXE BOOT: dhcp server(dnsmasq) & tftp server (within dnsmasq)
    conf:
```
        interface=net
        dhcp-range=10.0.1.200,10.0.1.253,12h
        dhcp-match=set:IPXEBOOT,175 # tag ipxe
        dhcp-option=tag:!IPXEBOOT,67,”undionly.kpxe” #chainload
        dhcp-option=67,”pxelinux.0” #default option
        enable-tftp
        tftp-root=/var/lib/tftpboot
```

& the running command

```
/usr/sbin/dnsmasq -x /var/run/dnsmasq/dnsmasq.pid -u dnsmasq -r /var/run/dnsmasq/resolv.conf -7 /etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new --local-servicenetsta
```


pxelinux.cfg/default:

```
# Please use it to replace /home/tftpboot/pxelinux.cfg/default at the CCMP head node.

default casper

label casper
#kernel casper/vmlinuz
#append boot=casper toram netboot=nfs nfsroot=172.16.0.254:/home/nfs initrd=casper/initrd.lz ksdevice=bootif --
#ipappend 2
#kernel casper/vmlinuz.t
#append initrd=casper/initrd.t MODULES=nbd,kvm-intel,kvm,squashfs,overlayfs ~wget -q http://$CLOUD:9999/root.sfs; mount -o loop root.sfs ro; mount -t tmpfs none rw;mount -t overlayfs -o lowerdir=ro,upperdir=rw none newroot;wget http://$CLOUD:9999/rc.local -O - > /newroot/etc/rc.local~
kernel casper/vmlinuz.s
append initrd=casper/initrd.s MODULES=nbd,kvm-intel,kvm,virtio ~mount -t tmpfs -o size=2G none /newroot; wget -q -O - http://$CLOUD:9999/root.tar.gz | tar zxf - -C /newroot; wget http://10.0.1.254:9999/rc.local -O - > /newroot/etc/rc.local~
ipappend 3

label local
LOCALBOOT 0
```

### iptables rules ###
    iptables

### command ###

brctl addbr net
ifconfig net 10.0.1.1/24 up
/etc/init.d/dnsmaq start

qemu-system-x86_64 --enable-kvm -cpu host  -m 2G -net  nic -net tap,script=/etc/ifup,downscript=/etc/ifdown
