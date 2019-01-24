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

### On Guest:

* Install the Guest Additions.
* Modify `/etc/fstab` and add the following (with modifications based on your needs):

```
NAME_OF_SHARED_FOLDER       /PATH/TO/MOUNTPOINT     vboxsf  uid=1000,rw      0       0
```

## Macvlan Network:

If you use VirtualBox, you will have to update your VM network settings. Open the settings panel for the VM, go the the "Network" tab, pull down the "Advanced" settings. Here, the "Adapter Type" should be pcnet (the full name is something like "PCnet-FAST III"), instead of the default e1000 (Intel PRO/1000). Also, "Promiscuous Mode" should be set to "Allow All".

If you don't do that, bridged containers won't work, because the virtual NIC will filter out all packets with a different MAC address. If you are running VirtualBox in headless mode, the command line equivalent of the above is modifyvm --nicpromisc1 allow-all. If you are using Vagrant, you can add the following to the config for the same effect:
