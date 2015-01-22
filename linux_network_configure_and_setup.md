### linux network tools ###
```
#: dpkg --search `which ifconfig` (rpm  : search it with you hand)
```
1.  net-tools: /sbin/ifconfig
2.  iproute2: /sbin/ip
3. network-manager: /usr/bin/nmcli
4. isc-dhcp-client: /sbin/dhclient
and so on ...

### wireless-tools: /sbin/iwconfig ###
you can find more information in [archlinux wiki](https://wiki.archlinux.org) 
And [here is ](https://wiki.archlinux.org/index.php/Wireless_network_configuration) the wireless network setup.
1.  iw dev waln0 link : check the status of the wlan0
2. # iw dev wlan0 connect "your_essid" key 0:your_key
 or: # iw dev wlan0 connect "your_essid" key d:2:your_key
3.  wpa_supplicant -D nl80211,wext -i wlan0 -c <(wpa_passphrase "your_SSID" "your_key")
4. get the ip for wlan0: dhcpcd wlan0 or dhclient -4 waln0

### stop the networkmanager (ubuntu) ###

$ sudo /etc/init.d/network-manager stop
$ sudo update-rc.d network-manager remove 

**OR: **
$ sudo stop network-manager
$ echo "manual" | sudo tee /etc/init/network-manager.override 

ARCHLINUX:
 $ sudo systemctl stop NetworkManager.service
$ sudo systemctl disable NetworkManager.service 

### /etc/network/interfaces setup ###
```
# interfaces(5) file used by ifup(8) and ifdown(8)
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

and some useful commond：
```
#auto eth0
#iface eth0 inet dhcp

#auto br0
#iface br0 inet dhcp
#pre-up tunctl -t tap0 -u hz -g hz
#pre-up ip link set dev eth0 down
#pre-up brctl addbr br0
#pre-up brctl addif br0 eth0
#pre-up brctl addif br0 tap0
#pre-up ip link set dev tap0 up
#up chmod 0666 /dev/net/tun
#post-down ip link set dev tap0 down
#post-down ip link set dev br0 down
#post-down brctl delif br0 eth0
#post-down brctl delif br0 tap0
#post-down brctl delbr br0
    #bridge_ports eth0
    #bridge_fd 0
    #bridge_maxpage 12
    #bridge_stp off
```

[https://help.ubuntu.com/community/KVM/Directly](https://help.ubuntu.com/community/KVM/Directly)
[http://www.h7.dion.ne.jp/~qemu-win/HowToNetwork-en.html#card](http://www.h7.dion.ne.jp/~qemu-win/HowToNetwork-en.html#card)

