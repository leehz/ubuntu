### Net Device Rename ###

cat > /etc/udev/rules.d/99-rename-to-eth0.rules << EOF
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="$(cat /sys/class/net/ens33/address)", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
    EOF
    

### command ###
    ifconfig eth down
    ip link set eth name net up
