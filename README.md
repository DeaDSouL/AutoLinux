# IMPORTANT
The repository has been moved to [GitLab.com/DeaDSouL/AutoLinux](https://gitlab.com/DeaDSouL/AutoLinux).


# AutoLinux
I found myself keep on doing same things over and over to all the new servers installation as part of their configuration, specially to virtual machines with dockers. That's where the idea of `AutoLinux` came from. As it should take care of all the common server's configuration that I usually do. It works and acts based on the pre-set values in its config file: `CentOS-7/al.config`.

### Installation
```
curl -s 'https://gitlab.com/DeaDSouL/AutoLinux/-/raw/master/installer-centos.sh' | bash
```

### Dependencies
It should not rely on anything. Since it focuses on the fresh CentOS-7 installation.
Although you should have the following packages installed:
* `rpm`
* `yum`

### What does it contain?
It currently has the following BASH scripts:



#### installer-centos.sh :
An installer for `AutoLinux` scripts on CentOS 7. Which will install the following:
* `git`.
* `DeaDSouL/AutoLinux` on `/usr/local/src/`.
* `AutoLinux/al.systemadmin-env`.
* `AutoLinux/al.vim-env`.
* `AutoLinux/al.docker`.


#### CentOS-7/al.config
Which contains all the `AutoLinux` used configuration.


#### CentOS-7/al.sysadmin-env

**Info:**
Manages your needed packages.

**Configuration:**
* `AL_SYSADMIN_ENVIRONMENT_PKGS` : Is a BASH array variable, that holds all the packages you'd like to have.

**Command options:**
* `./al.systemadmin-env help` : Prints the help menu.
* `./al.systemadmin-env install` : Installs the pre-defined packages.
* `./al.systemadmin-env remove` : Removes the installed pre-defined packages.
* `./al.systemadmin-env purge` : Calls `remove`, then execute `yum -y autoremove`.

**Dependencies:**
None.


#### CentOS-7/al.vim-env

**Info:**
Manages [DeaDSouL/vimConfig](https://gitlab.com/DeaDSouL/vimConfig) git repository.

**Configuration:**
* `AL_GIT_REPOS_PATH` : Where would you like to store the cloned repository. 

**Command options:**
* `./al.vim-env help` : Prints the help menu.
* `./al.vim-env install` : Clones the [DeaDSouL/vimConfig](https://gitlab.com/DeaDSouL/vimConfig) and make the symlinks (`~/.vimrc` & `~/.vim`).
* `./al.vim-env remove` : Removes the symlinks.
* `./al.vim-env purge` : Calls `remove`, then remove the cloned `vimConfig`.

**Dependencies:**
* `CentOS-7/al.sysadmin-env` should be installed, or manually install `vim` and `git`.


#### CentOS-7/al.docker

**Info:**
Manages the installation of Docker.

**Configuration:**
* `AL_DOCKER_PATH_SYS` : Holds the Docker system path, which is `/var/lib/docker` in CentOS 7.
* `AL_DOCKER_PATH_ENG` : Holds the Docker Engine path, which is `/var/lib/docker-engine` in CentOS 7.
* `AL_DOCKER_PATH` : Where would you like to store the container's related shared folders/volumes/configuration.. etc.
* `AL_DOCKER_ALIAS` : Where to install the Docker's helper commands/aliases.

**Command options:**
* `./al.docker help` : Prints the help menu.
* `./al.docker install` : Installs Docker, Docker's helper aliases and EPEL repository..
* `./al.docker remove` : Removes Docker and unload the Docker's helper aliases from `~/.bashrc`.
* `./al.docker purge` : Calls `remove`, then removes: `AL_DOCKER_PATH_SYS`, `AL_DOCKER_PATH_ENG` and `AL_DOCKER_ALIAS`.

**Dependencies:**
None.

**Docker's helper aliases:**
Once `CentOS-7/al.docker` is installed, the following aliases will be ready to be called in terminal.
* `d.stat` : Shows the docker's statistics.
* `d.pid` : Prints the PID of a given container. (Ex: `d.pid emby0`).
* `d.ip` : Prints the IP-Address a given container. (Ex: `d.ip emby0`).
* `d.vols` : Shows the attached volumes to a given container. (Ex: `d.vols emby0`).
* `d.gen-mac` : Generates a random MAC-Address based on a given phrase. (Ex: `d.gen-mac some-phrase`).
* `d.nw-gw` : Prints the Gateway. (Ex: `d.nw-gw`).
* `d.nw-sn` : Prints the Subnet. (Ex: `d.nw-sn`).


#### CentOS-7/al.docker-network

**Info:**
Manages your Docker networks.

**Configuration:**
* `AL_DOCKER_NETWORK_NAME` : The name of the network you'd like to create.
* `AL_DOCKER_NETWORK_DRIVER` : Which driver would you like to use.
* `AL_DOCKER_NETWORK_GATEWAY` : The network's Gateway.
* `AL_DOCKER_NETWORK_SUBNET` : The network's Subnet.
* `AL_DOCKER_NETWORK_IPRANGE` : The network's usable IP range.
* `AL_DOCKER_NETWORK_OPTIONS` : To add extra options.

**Command options:**
* `./al.docker-network help` : Prints the help menu.
* `./al.docker-network install` : Creates the docker's network.
* `./al.docker-network remove` : Removes the docker's network if it wasn't being used by any container.
* `./al.docker-network purge` : Disconnect any connected container to this network, then removes the network.

**Dependencies:**
* `CentOS-7/al.vbox-guest` should be installed, or manually install `VBoxLinuxAddition.run`.


#### CentOS-7/al.docker-emby

**Info:**
Manages emby/embyserver docker image.

**Configuration:**
* `AL_DOCKER_EMBY_REPO_VER` : The repository and version of the `embyserver`.
* `AL_DOCKER_EMBY_NAME` : The name of the container.
* `AL_DOCKER_EMBY_VOLUMES` : The volumes you'd like to attach to the container. Each volume should be added as `BASH` array element. (format: `"/host/path:/container/mountpoint"`)
* `AL_DOCKER_EMBY_NETWORK` : The name of the network, that the container should be using.
* `AL_DOCKER_EMBY_HOSTNAME` : The `hostname` of the container.
* `AL_DOCKER_EMBY_MAC` : The given MAC-Address to the container's network adapter.
* `AL_DOCKER_EMBY_IP` : The given IP-Address to the container.
* `AL_DOCKER_EMBY_UID` : The User-id that `emby` process should run as.
* `AL_DOCKER_EMBY_GID` : The group-id that `emby` process should run as.
* `AL_DOCKER_EMBY_GIDLIST` : Additional GroupIDs to run `emby` as. (Comma-separated list).
* `AL_DOCKER_EMBY_RESTART` : The restart policy of the container.
* `AL_DOCKER_EMBY_OPTIONS` : Extra options to add if you want.

**Command options:**
* `./al.docker-emby help` : Prints the help menu.
* `./al.docker-emby install` : Pulls, install and run the emby image. Then, creates an executable run script in `AL_PATH_BIN` called `run.${AL_DOCKER_EMBY_NAME}`, and symlink it to `/usr/local/sbin/`. So it can be callable from anywhere in terminal.
* `./al.docker-emby remove` : Stops and removes the emby container.
* `./al.docker-emby purge` : Calls `remove`, then removes the emby image.

**Dependencies:**
* `CentOS-7/al.docker` should be installed, or manually install `docker`.
* `CentOS-7/al.vbox-guest` should be installed, or manually install `VBoxLinuxAddition.run`.


#### CentOS-7/al.vbox-guest

**Info:**
Manages the VirtualBox Guest Additions.

**Configuration:**
None.

**Command options:**
* `./al.vbox-guest help` : Prints the help menu.
* `./al.vbox-guest install` : Makes sure `EPEL` repository is installed, then installs the needed packages, finally installs the  VirtualBox Guest Additions.
* `./al.vbox-guest remove` : Removes the installed VirtualBox Guest Additions.
* `./al.vbox-guest purge` : An alias to `remove`.

**Dependencies:**
The VirtualBox Guest Additions CD Image should be inserted.


#### CentOS-7/al.fstab

**Info:**
Manages your custom mounts in `/etc/fstab`.
Once, it's been installed and you need to add/remove more custom mounts, you'd have to remove it first by using `./al.fstab remove` or `./al.fstab purge` then re-install it again using: `./al.fstab install`. Or manually modify `/etc/fstab`.

**Configuration:**
* `AL_FSTAB_X` : A `BASH` array variable, that holds the same 6 elements that's used by `/etc/fstab`. The `X` in the end of `AL_FSTAB_X` should be replaced with a number. Depends on the number of custom mounts you want to add to `/etc/fstab`.

**Command options:**
* `./al.fstab help` : Prints the help menu.
* `./al.fstab install` : Adds the custom mounts to `/etc/fstab`.
* `./al.fstab remove` : Removes the custom added mounts from `/etc/fstab`.
* `./al.fstab purge` : Un-mount all the custom added mounts, then calls `remove`.

**Dependencies:**
Depends of the mount-type you're going to use. if it was `vboxsf` then you'll need `CentOS-7/al.vbox-guest` or `VBoxLinuxAddition.run` to be installed.. etc.



### License
To be honest, I chose this license because it's the one that is being used by Linux kernel.

Although, this program is a free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see [gnu.org/licenses](http://www.gnu.org/licenses/).

Copyright (C) [DeaDSouL](https://gitlab.com/DeaDSouL)

