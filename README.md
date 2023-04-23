# Discord
SynoCommunity is now on Discord!

[![Discord](https://img.shields.io/discord/732558169863225384?color=7289DA&label=Discord&logo=Discord&logoColor=white&style=for-the-badge)](https://discord.gg/nnN9fgE7EF)

# DSM 7
DSM 7 was released on June 29 2021 as Version 7.0.41890.

## In SynoCommunity some packages are available for DSM 7 but some are not.
* You find the status of the packages in the issue [#4524] **Meta: DSM7 package status**
* If you are running DSM7, some packages that are not compatible may continue appear in the Package Center of your Disk Station.
* PLEASE do not create issues saying that package `xy` cannot be installed on DSM 7. All packages not yet ported to DSM 7 will refuse the installation with a message about "package requires root privileges" (or "invalid file format", ...).
* Please regard all DSM 7 packages as beta versions (the synocommunity package repository is not capable to declare packages as beta only for DSM 7).
* **ATTENTION**: As reported, package configuration settings may be lost following the upgrade to DSM 7 and the execution of a Package repair. Make sure to backup your settings and configuration for your SynoCommunity packages before installation of DSM 7 to facilitate restoration if needed.
* Packages of the following kind will need some time to make DSM 7 compatible
  * Packages depending on MySQL database must be migrated to MariaDB 10
  * Packages that use an Installation Wizard to configure a shared folder (all download related packages and others)
  * Packages that integrate into DSM Webstation
* As this is a community project where people contribue in their spare time, it may take awhile until packages are ported to DSM 7. (There are still packages here that are not ported from DSM 5 to DSM 6 yet).

# spksrc
spksrc is a cross compilation framework intended to compile and package software for Synology NAS devices. Packages are made available via the [SynoCommunity repository].


## Contributing
Before opening a new issue, check the [FAQ] and search open issues.
If you can't find an answer, or if you want to open a package request, read [CONTRIBUTING] to make sure you include all the information needed for contributors to handle your request.


## Setup Development Environment
### Docker
*The Docker development environment supports Linux and macOS systems, but not Windows due to limitations of the underlying file system.*

1. [Fork and clone] spksrc: `git clone https://github.com/YOUR-USERNAME/spksrc`
2. Install Docker on your host OS (see [Docker installation], or use a `wget`-based alternative for linux [Install Docker with wget]).
3. Download the spksrc Docker container: `docker pull ghcr.io/synocommunity/spksrc`
4. Run the container with the repository mounted into the `/spksrc` directory with the appropriate command for your host Operating System:

```bash
cd spksrc # Go to the cloned repository's root folder.

# If running on Linux:
docker run -it -v $(pwd):/spksrc -w /spksrc ghcr.io/synocommunity/spksrc /bin/bash

# If running on macOS:
docker run -it -v $(pwd):/spksrc -w /spksrc -e TAR_CMD="fakeroot tar" ghcr.io/synocommunity/spksrc /bin/bash
```
5. From there, follow the instructions in the [Developers HOW TO].



### Virtual machine
A virtual machine based on an 64-bit version of Debian 11 stable OS is recommended. Non-x86 architectures are not supported.

Install the requirements (in sync with `Dockerfile`):
```bash
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt update
sudo apt install autoconf-archive autogen automake autopoint bash bc bison \
                 build-essential check cmake curl cython3 debootstrap ed expect fakeroot flex \
                 g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 \
                 libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev \
                 libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial moreutils ninja-build \
                 patchelf php pkg-config python2 python3 python3-distutils rename rsync scons subversion \
                 swig texinfo unzip xmlto zlib1g-dev
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | sudo python2
sudo pip2 install wheel httpie
wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python3
sudo pip3 install meson==1.0.0
```
From there, follow the instructions in the [Developers HOW TO].

* You may need to install some packages from testing like autoconf. Read about Apt-Pinning to know how to do that.
* Some older toolchains may require 32-bit development versions of packages, e.g. `zlib1g-dev:i386`



### LXC
A container based on 64-bit version of Debian 11 stable OS is recommended. Non-x86 architectures are not supported.  The following assumes your LXD/LXC environment is already initiated (e.g. `lxc init`) and you have minimal LXD/LXC basic knowledge :
1. Create a new container (will use x86_64/amd64 arch by default): `lxc launch images:debian/11 spksrc`
2. Enable i386 arch: `lxc exec spksrc -- /usr/bin/dpkg --add-architecture i386`
3. Update apt channels: `lxc exec spksrc -- /usr/bin/apt update`
4. Install all required packages:
```bash
lxc exec spksrc -- /usr/bin/apt install autoconf-archive autogen automake autopoint bash bc bison \
                                build-essential check cmake curl cython3 debootstrap ed expect fakeroot flex \
                                g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 \
                                libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev \
                                libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial moreutils ninja-build \
                                patchelf php pkg-config python2 python3 python3-distutils rename rsync scons subversion \
                                swig texinfo unzip xmlto zlib1g-dev
```
5. Install `python2` wheels:
```bash
lxc exec spksrc -- /bin/bash -c "wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | python2"
lxc exec spksrc -- /bin/bash -c "pip2 install virtualenv httpie"
```
6. Install `python3` `pip`:
```bash
lxc exec spksrc -- /bin/bash -c "wget https://bootstrap.pypa.io/get-pip.py -O - | python3"
```
7. Install `meson`:
```bash
lxc exec spksrc -- /bin/bash -c "pip3 install meson==1.0.0"
```


#### LXC: `spksrc` user
8. By default it is assumed that you will be running as `spksrc` user into the LXC container.  Such user needs to be created into the default container image:
```bash
lxc exec spksrc -- /usr/sbin/adduser --uid 1001 spksrc
```
9. Setup a default shell environment:
```bash
lxc exec spksrc --user 1001 -- cp /etc/skel/.profile /etc/skel/.bashrc ~spksrc/.
```

From there you can connect to your container as `spksrc` and follow the instructions in the [Developers HOW TO].
```bash
lxc exec spksrc -- su --login spksrc
spksrc@spksrc:~$
```

#### (OPTIONAL) Install misc base tools:
```bash
lxc exec spksrc -- /usr/bin/apt install bash-completion man-db manpages-dev \
                                        mlocate ripgrep rsync tree time
lxc exec spksrc -- /usr/bin/updatedb
```
Install github client:
```
$ lxc exec spksrc -- su --login root
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
# sudo apt update
# sudo apt install gh
# exit
```

#### (OPTIONAL) LXC: Shared `spksrc` user 
You can create a shared user between your Debian/Ubuntu host and the LXC Debian container which simplifies greatly file management between the two.  The following assumes you already created a user `spksrc` with uid 1001 in your Debian/Ubuntu host environment and that you which to share its `/home` userspace.
1. Create a mapping rule between the hosts and the LXC image:
```bash
lxc config set spksrc raw.idmap "both 1001 1001"
lxc restart spksrc
Remapping container filesystem
```
2. Add `/home/spksrc` from the hsot to the LXC container:
```bash
lxc config device add spksrc home disk path=/home/spksrc source=/home/spksrc
Device home added to spksrc
```
3. Connect as `spksrc` user:
```bash
lxc exec spksrc -- su --login spksrc
spksrc@spksrc:~$
```

#### LXC: Proxy (OPTIONAL)
The following assume you have a running proxy on your LAN setup at IP 192.168.1.1 listening on port 3128 that will allow caching files.
1. Enforce using a proxy:
```bash
lxc config set spksrc environment.http_proxy http://192.168.1.1:3128
lxc config set spksrc environment.https_proxy http://192.168.1.1:3128
```
2. Enforce using a proxy with `wget` in the spksrc container user account:
```bash
lxc exec spksrc --user $(id -u spksrc) -- bash -c "cat << EOF > ~spksrc/.wgetrc
use_proxy = on
http_proxy = http://192.168.1.1:3128/
https_proxy = http://192.168.1.1:3128/
ftp_proxy = http://192.168.1.1:3128/
EOF"
```


## Usage
Once you have a development environment set up, you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people.
See the [Developers HOW TO] for information on how to use spksrc.


## License
When not explicitly set, files are placed under a [3 clause BSD license]

[3 clause BSD license]: http://www.opensource.org/licenses/BSD-3-Clause
[#4524]: https://github.com/SynoCommunity/spksrc/issues/4524
[bug tracker]: https://github.com/SynoCommunity/spksrc/issues
[CONTRIBUTING]: https://github.com/SynoCommunity/spksrc/blob/master/CONTRIBUTING.md
[Fork and clone]: https://docs.github.com/en/github/getting-started-with-github/fork-a-repo
[Developers HOW TO]: https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO
[Docker installation]: https://docs.docker.com/engine/installation
[FAQ]: https://github.com/SynoCommunity/spksrc/wiki/Frequently-Asked-Questions
[Install Docker with wget]: https://docs.docker.com/linux/step_one
[SynoCommunity repository]: http://www.synocommunity.com
