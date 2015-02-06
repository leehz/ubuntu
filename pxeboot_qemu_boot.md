### a kvm commond for pxeboot test ###

*you can find the qemu-ifup & qemu_ifdown in qemu_if*

```
qemu-system-x86_64 --enable-kvm -cpu host  -m 2G -net  nic -net tap,script=/etc/ifup,downscript=/etc/ifdown
```

