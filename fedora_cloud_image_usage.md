### linux环境下 ### 
> 也许你本来就在linux的环境下了， 或者安装在硬盘上，或者运行在虚拟机里。
但是更多的时候你不需要那么大、那么全的整个 大块系统。
之前 我也是一直是 使用archlinux来 实现最小化的系统安装。

那么问题来了？假如你需要的是：
1. 小型linux运行环境
2. 可定制可升级的系统环境
3. 大量的可用的方便安装的软件包

那么下面的这些你绝对感兴趣。

### Fedora Cloud Images ###

这个不过多解释， [官网](https://getfedora.org/cloud/download/)自行查看下载。

### 环境配置和运行 ###
现在下载下来的cloud images大小一定会让你吃惊，因为 大小不过100M多。
但是raw， qcow2的文件格式， 没有玩过kvm qemu的人一定不会懂。 这个自行Google


2种运行的方式：
#### linux kvm（qemu）中运行 ####

- linux kvm qemu Bridge Tap 的网络配置参见 ： [http://i.huaixiaoz.com/linux/kvm_qemu.html](http://i.huaixiaoz.com/linux/kvm_qemu.html)
- #### 运行方式的改进：#### 
    * 一般的运行方式： (spice 方式 tap bridge方式)
    ```
    kvm -smp 4 -m 2048 -name f15 -drive file=~/Fedora-Cloud-Base-20141203-21.x86_64.qcow2,if=virtio -vga qxl -net nic,model=virtio,macaddr=00-11-22-33-55-44 -net tap -localtime -soundhw es1370 -spice port=5900,addr=192.168.3.148,disable-ticketing
    ```
    * 可以改进的： （nohup commond &）
     ```
     nohup kvm -smp 4 -m 2048 -name f15 -drive file=~/Fedora-Cloud-Base-20141203-21.x86_64.qcow2,if=virtio -vga qxl -net nic,model=virtio,macaddr=00-11-22-33-55-44 -net tap -localtime -soundhw es1370 -spice port=5900,addr=192.168.3.148,disable-ticketing &
    ```
    * 继续改进： （虚拟串口，后台运行， 不需要图形连接: 串口很多种方法， 具体参见手册）
     ```
     nohup kvm -smp 4 -m 2048 -name f15 -drive file=~/Fedora-Cloud-Base-20141203-21.x86_64.qcow2,if=virtio  -net nic,model=virtio,macaddr=00-11-22-33-55-44 -net tap -nographic -serial pty &
    ```

####  windows（或者随便其他环境）下vmware （或者 virtualbox）运行 ####

对于这一种方式，只需要转换为相应的磁盘文件格式就OK了。
示例如下：
```
qemu-img convert -f qcow2 -O vmdk Fedora-Cloud-Base-20141203-21.x86_64.qcow2  fedora.vmdk
```
然后就可以拿去vmware中 作为磁盘运行了，
同样， virtualbox磁盘转换：
```
qemu-img convert -f qcow2 -O vdi Fedora-Cloud-Base-20141203-21.x86_64.qcow2  fedora.vdi
```
其他磁盘格式参见qemu-img， qemu的手册
>题外话： 同样对于厌倦了vmware，virtualbox的 一样可以吧vmdk， vdi等转换为raw ，qcow2格式
示例如下：
```
qemu-img convert  -f vmdk -O qcow2   src.vmdk  dest.qcow2
```

#### Tips ####

由于fedora cloud Image默认root用户的密码不知道。。 具体参见 官方wiki。

修改办法：

```
virt-customize -a fedora.qcow2 --root-password password:123456 
```
修改密码为： 123456
其他 参考 [http://libguestfs.org/virt-customize.1.html](http://libguestfs.org/virt-customize.1.html)。
