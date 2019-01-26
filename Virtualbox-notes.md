# VirtualBox Notes:

Some useful notes, if you're planning to use docker in virtualbox.


## Shared folders:

### On Host:

Assuming:
* The **VM NAME** is `CentOS-Docker`.
* The **shared folder** called `Media-Data`.
* The **shared folder path** is `/srv/Media`.

To add a shared folder:

```
VBoxManage sharedfolder add "CentOS-Docker" --name "Media-Data" --hostpath "/srv/Media"
```

To remove a shared folder:

```
VBoxManage sharedfolder remove "CentOS-Docker" --name "Media-Data"
```

To find the IDE Controller device numbers:

```
VBoxManage showvminfo "CentOS-Docker" | grep "Storage Controller Name"
```

To find the port and device numbers of the IDE controller: (#port, #device)

```
VBoxManage showvminfo "CentOS-Docker" | grep "IDE"
```

&nbsp;&nbsp;&nbsp;&nbsp;If you didn't find it, you can add it:

```
VBoxManage storagectl "CentOS-Docker" --name "IDE" --add ide
```

To attach the VBoxGuestAdditions.iso as dvd drive:

Assuming:
* **Storage controller name** is `IDE`.
* **Storage controller port** is `1`.
* **Storage controller device** is `0`.
* **VBoxGuestAdditions.iso location** is `/usr/share/virtualbox/VBoxGuestAdditions.iso`.

```
VBoxManage storageattach "CentOS-Docker" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso
```

&nbsp;&nbsp;&nbsp;&nbsp;To find out where is VBoxGuestAdditions.iso:

```
find / -path /mnt -prune -o -name 'VBoxGuestAdditions*.iso'
```

&nbsp;&nbsp;&nbsp;&nbsp;If you have the virtualbox-guestadditions packages installed on your host, then you can alternatively try:

```
VBoxManage storageattach "CentOS-Docker" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium additions
```

To detach the VBoxGuestAdditions.iso:

```
VBoxManage storageattach "CentOS-Docker" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium emptydrive
```

&nbsp;&nbsp;&nbsp;&nbsp;If that didn't work, just force it:

```
VBoxManage storageattach "CentOS-Docker" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium emptydrive --forceunmount
```

### On Guest:

1. Install the Guest Additions.

On CentOS 7 and RedHat (RHEL) 7, we need to add (EPEL) repo:

```
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum update
```

Then install the following needed packages:

```
yum install gcc kernel-devel kernel-headers dkms make bzip2 perl
```

Now, Add KERN_DIR environment variable:

```
KERN_DIR=/usr/src/kernels/`uname -r`/build
export KERN_DIR
```

Create the MOUNTPOINT and mount VBoxGuestAdditions.iso:

```
mkdir /media/cdrom0
mount -t iso9660 -o ro /dev/cdrom /media/cdrom0
```

Install VBoxGuestAdditions:

```
cd /media/cdrom0
./VBoxLinuxAdditions.run
```

&nbsp;&nbsp;&nbsp;&nbsp;If you're installing it on a server without GUI, add this flag: `--nox11`.

When we're done, let's unmount it:

```
umount /media/cdrom0
```

Then remove the attached ISO from host.

Finally, just reboot:

```
rebooot
```

2. Tell the guest-os about our shared folder:

Assuming:
* The **shared folder** called `Media-Data`.
* The **MOUNTPOINT** in the guest-os is `/mnt/Media`.
* The **UserID** is `1000`.
* We want the read and write permissions.

Modify `/etc/fstab` and add the following:

```
Media-Data      /mnt/Media      vboxsf  uid=1000,rw      0       0
```

## Macvlan Network:

> If you use VirtualBox, you will have to update your VM network settings. Open the settings panel for the VM, go the the "Network" tab, pull down the "Advanced" settings. Here, the "Adapter Type" should be pcnet (the full name is something like "PCnet-FAST III"), instead of the default e1000 (Intel PRO/1000). Also, "Promiscuous Mode" should be set to "Allow All".
> 
> If you don't do that, bridged containers won't work, because the virtual NIC will filter out all packets with a different MAC address. If you are running VirtualBox in headless mode, the command line equivalent of the above is modifyvm --nicpromisc1 allow-all.. 
> [Source](https://github.com/jpetazzo/pipework#virtualbox)
