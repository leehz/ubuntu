  ip link add link eth0 name macvtap0 type macvtap mode bridge
  qemu-kvm -nographic -kernel /boot/vmlinuz-guest     -append "console=ttyS0 root=/dev/vda"     -drive file=/tmp/testroot.img,if=virtio,cache=none     -net nic,model=virtio,macaddr=ea:2b:e4:95:ea:f5     -net tap,fd=3 3<>/dev/tap8
