# VirtualBox Notes:

Some useful notes, if you're planning to use docker in virtualbox.


## Shared folders:

### On Host:

To add a shared folder:

```
VBoxManage sharedfolder add "VM_NAME" --name NAME_OF_SHARED_FOLDER --hostpath "PATH/TO/DIR/ON/HOST"
```

To remove a shared folder:

```
VBoxManage sharedfolder remove "VM_NAME" --name NAME_OF_SHARED_FOLDER
```

To find the IDE Controller device numbers:

```
VBoxManage showvminfo "VM_NAME" | grep "Storage Controller Name"
```

To find the port and device numbers of the IDE controller: (#port, #device)

```
VBoxManage showvminfo "VM_NAME" | grep "IDE"
```

&nbsp;&nbsp;&nbsp;&nbsp;If you didn't find it, you can add it:

```
VBoxManage storagectl "VM_NAME" --name "IDE controller" --add ide
```

To attach the VBoxGuestAdditions.iso as dvd drive:

```
VBoxManage storageattach "VM_NAME" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium /PATH/TO/VBoxGuestAdditions.iso
```

&nbsp;&nbsp;&nbsp;&nbsp;To find out where is VBoxGuestAdditions.iso:

```
find / -path /mnt -prune -o -name 'VBoxGuestAdditions*.iso'
```

&nbsp;&nbsp;&nbsp;&nbsp;If you have the virtualbox-guestadditions packages installed on your host, then you can alternatively try:

```
VBoxManage storageattach "VM_NAME" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium additions
```

To detach the VBoxGuestAdditions.iso:

```
VBoxManage storageattach "VM_NAME" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium emptydrive
```

&nbsp;&nbsp;&nbsp;&nbsp;If that didn't work, just force it:

```
VBoxManage storageattach "VM_NAME" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium emptydrive --forceunmount
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

When we're done, let's unmount it:

```
umount /media/cdrom0

```

Then remove the attached ISO from host.

Finally, just reboot:

```
rebooot
```

2. Modify `/etc/fstab` and add the following (with modifications based on your needs):

```
NAME_OF_SHARED_FOLDER       /PATH/TO/MOUNTPOINT     vboxsf  uid=1000,rw      0       0
```

## Macvlan Network:

> If you use VirtualBox, you will have to update your VM network settings. Open the settings panel for the VM, go the the "Network" tab, pull down the "Advanced" settings. Here, the "Adapter Type" should be pcnet (the full name is something like "PCnet-FAST III"), instead of the default e1000 (Intel PRO/1000). Also, "Promiscuous Mode" should be set to "Allow All".
> 
> If you don't do that, bridged containers won't work, because the virtual NIC will filter out all packets with a different MAC address. If you are running VirtualBox in headless mode, the command line equivalent of the above is modifyvm --nicpromisc1 allow-all.. 
> [Source](https://github.com/jpetazzo/pipework#virtualbox)
