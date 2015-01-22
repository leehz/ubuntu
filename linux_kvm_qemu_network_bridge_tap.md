1. userspace network : `-net nic,model=virtio,macaddr=xx-xx-xx-xx-xx -net user`
2. bridge network: `-net nic,xxxx  -net  -tap`


### Kvm network bridge tap ###
1.  edit */etc/network/interfaces*
Install  :
``` sudo apt-get install bridge-utils  uml-utilities```

```
auto lo
iface lo inet loopback

#auto eth0
#iface eth0 inet dhcp
# add by hz 

auto waln0
iface wlan0 inet dhcp

auto br0
iface br0 inet dhcp
    bridge_ports eth0
    bridge_stp off
    bridge_maxwait 0
    bridge-fd 0

```
2. edit `/etc/qemu-ifup`

```
ip=$(which ip)

if [ -n "$ip" ]; then
   ip link set "$1" up
else
   brctl=$(which brctl)
   if [ ! "$ip" -o ! "$brctl" ]; then
     echo "W: $0: not doing any bridge processing: neither ip nor brctl utility not found" >&2
     exit 0
   fi
   ifconfig "$1" 0.0.0.0 up
fi

switch=$(ip route ls | \
    awk '/^default / {
          for(i=0;i<NF;i++) { if ($i == "dev") { print $(i+1); next; } }
         }'
        )
switch=br0
# only add the interface to default-route bridge if we
# have such interface (with default route) and if that
# interface is actually a bridge.
# It is possible to have several default routes too
for br in $switch; do
    if [ -d /sys/class/net/$br/bridge/. ]; then
        if [ -n "$ip" ]; then
          ip link set "$1" master "$br"
        else
          brctl addif $br "$1"
        fi
        exit    # exit with status of the previous command
    fi
done
```

you can follow [this link](www.linux-kvm.org/page/Networking) to get it

### Start the KVM  ###
```
kvm -smp 4 -m 2048 -name f15 -drive file=~/cn_winxp_pro_sp3_x32.4G.qcow2,if=virtio -vga qxl  -net nic,model=virtio,macaddr=00-11-22-33-55-44 -net tap  -localtime -soundhw es1370 -spice port=5900,addr=192.168.3.148,disable-ticketing

```

