kvm -cpu host -smp 4 -m 2048  -cdrom /work/CentOS-7.0-1406-x86_64-DVD.iso -boot d -drive file=/work/cent7.qcow2,if=virtio  -net nic,model=virtio,macaddr=1a:46:0b:ca:bc:7a -net tap -spice port=5901,addr=192.168.3.119,disable-ticketing



kvm -cpu host -smp 4 -m 2048   -drive file=/work/cent55.qcow2,if=virtio  -net nic,model=virtio,macaddr=1a:46:0b:ca:bc:7b -net tap -spice port=5900,addr=192.168.3.119,disable-ticketing
