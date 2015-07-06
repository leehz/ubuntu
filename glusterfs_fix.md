root@hz-cloud:/work# qemu-img  create -f qcow2    storage.qcow2 100G
Formatting 'storage.qcow2', fmt=qcow2 size=107374182400 encryption=off cluster_size=65536 lazy_refcounts=off

root@hz-cloud:/work# modprobe  nbd
root@hz-cloud:/work# qemu-nbd  -c /dev/nbd0 storage.qcow2

root@hz-cloud:/work# fdisk  -l /dev/nbd0 

Disk /dev/nbd0: 100 GiB, 107374182400 bytes, 209715200 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x70a097be

Device      Boot Start       End   Sectors  Size Id Type
/dev/nbd0p1       2048 209715199 209713152  100G 83 Linux

root@hz-cloud:/work# vgcreate  ccmp_glusterfs  /dev/nbd0p1
  Physical volume "/dev/nbd0p1" successfully created
  Volume group "ccmp_glusterfs" successfully created
root@hz-cloud:/work# pvscan 
  PV /dev/nbd0p1   VG ccmp_glusterfs   lvm2 [100.00 GiB / 100.00 GiB free]
  Total: 1 [100.00 GiB] / in use: 1 [100.00 GiB] / in no VG: 0 [0   ]
root@hz-cloud:/work# vgscan 
  Reading all physical volumes.  This may take a while...
  Found volume group "ccmp_glusterfs" using metadata type lvm2

##tips:
	inactive => active 
	vgchange -a y ccmp_glusterfs

root@hz-cloud:/work# lvcreate  -L 100M -n metadata  ccmp_glusterfs
  Logical volume "metadata" created
root@hz-cloud:/work# lvscan 
  ACTIVE            '/dev/ccmp_glusterfs/metadata' [100.00 MiB] inherit

root@hz-cloud:/work# lvcreate  -l +100%free -n data  ccmp_glusterfs
  Logical volume "data" created
root@hz-cloud:/work# lvscan 
  ACTIVE            '/dev/ccmp_glusterfs/metadata' [100.00 MiB] inherit
  ACTIVE            '/dev/ccmp_glusterfs/data' [99.90 GiB] inherit

root@hz-cloud:/work# lvscan 
  ACTIVE            '/dev/ccmp_glusterfs/metadata' [128.00 MiB] inherit


root@hz-cloud:/work# lvremove  -f ccmp_glusterfs/metadata
  /dev/nbd0p1: BLKDISCARD ioctl at offset 1048576 size 134217728 failed: 输入/输出错误.
  Logical volume "metadata" successfully removed

 mkfs.xfs /dev/mapper/ccmp_glusterfs-data
 mkfs.xfs /dev/mapper/ccmp_glusterfs-metadata


/dev/mapper/ccmp_glusterfs-data on /ccmp_glusterfs_data/ccmp type xfs (rw)
/dev/mapper/ccmp_glusterfs-metadata on /var/lib/glusterd type xfs (rw)
##tips: fix glusterfs
setfattr -x trusted.glusterfs.volume-id /ccmp_glusterfs
setfattr -x trusted.gfid /ccmp_glusterfs/ccmp
rm -rf /ccmp_glusterfs/ccmp/.glusterfs

rm -rf /var/lib/glusterd

gluster peer probe x.x.x.x (node1) x.x.x.x(node2)
gluster volume create ccmp_vol replica x transport tcp x.x.x.x:/ccmp_glusterfs/ccmp   x.x.x.x:/ccmp_glusterfs/ccmp
glusterfs volume start ccmp_vol
