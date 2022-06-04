# Discord
SynoCommunity is now on Discord!

[![Discord](https://img.shields.io/discord/732558169863225384?color=7289DA&label=Discord&logo=Discord&logoColor=white&style=for-the-badge)](https://discord.gg/nnN9fgE7EF)

# DSM 7
DSM 7 was released on June 29 2021 as Version 7.0.41890.

## In SynoCommunity some packages are available for DSM 7 but some are not.
* You find the status of the packages in the issue [#4524] **Meta: DSM7 package status**
* Despite you see packages of SynoCommunity in the Package Center of your Diskstation with DSM 7, some of the packages are not compatible with DSM 7.
* PLEASE do not create issues saying that package `xy` cannot be installed on DSM 7. All packages not yet ported to DSM 7 will refuse the installation with a message about "package requires root privileges" (or "invalid file format", ...).
* Please regard all DSM 7 packages as beta versions (the synocommunity package repository is not capable to declare packages as beta only for DSM 7).
* **ATTENTION**: As reported, package configuration settings may be lost following the upgrade to DSM 7 and the execution of a Package repair. Make sure to backup your settings and configuration for your SynoCommunity packages before installation of DSM 7 to facilitate restoration if needed.
* Packages of the following kind will need some time to make DSM 7 compatible
  * Packages depending MySQL database must be migrated to MariaDB 10
  * Packages with installation Wizard to configure a shared folder (all download related packages and others)
  * Packages that integrate into DSM webstation
* As this is a community project where people spend there spare time for contribution, it may take a long time until most of the packages are ported to DSM 7. (There are still packages here that are not ported from DSM 5 to DSM 6 yet).

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
docker run -it -v $(pwd):/spksrc ghcr.io/synocommunity/spksrc /bin/bash

# If running on macOS:
docker run -it -v $(pwd):/spksrc -e TAR_CMD="fakeroot tar" ghcr.io/synocommunity/spksrc /bin/bash
```
5. From there, follow the instructions in the [Developers HOW TO].

### LXC
A container based on 64-bit version of Debian 10 stable OS is recommended. Non-x86 architectures are not supported.  The following assumes your `lxd` environment is already initiated (e.g. `lxc init`) and you have minimal LXD/LXC knowledge :
1. Create a new container (will use x864_64/amd64 arch by default): `lxc launch images:debian/10 spksrc`
2. Enable i386 arch: `lxc exec spksrc -- /usr/bin/dpkg --add-architecture i386`
3. Update apt channels: `lxc exec spksrc -- /usr/bin/apt update`
4. Install all required packages:
```
lxc exec spksrc -- /usr/bin/apt install autogen autoconf-archive automake autopoint bc bison build-essential check \
                                cmake curl cython debootstrap ed expect flex g++-multilib gawk gettext git gperf \
                                imagemagick intltool jq libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev \
                                libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev libssl-dev \
                                libtool libunistring-dev lzip mercurial moreutils ncurses-dev ninja-build patchelf php \
                                pkg-config python3 python3-distutils rename scons subversion swig texinfo unzip \
                                xmlto zlib1g-dev
```
5. Install `python2` wheels:
```
lxc exec spksrc -- /bin/bash -c "wget https://bootstrap.pypa.io/get-pip.py -O - | python2"
lxc exec spksrc -- /bin/bash -c "pip2 install virtualenv httpie"
```
6. Install `python3` wheels:
```
lxc exec spksrc -- /bin/bash -c "wget https://bootstrap.pypa.io/get-pip.py -O - | python3"
lxc exec spksrc -- /bin/bash -c "pip3 install virtualenv httpie"
```
7. Install `meson` (requires `autoconf-archive`):
```lxc exec spksrc -- /bin/bash -c "pip3 install meson==0.62.2"```
8. (OPTIONAL) Install misc base tools:
```
lxc exec spksrc -- /usr/bin/apt install bash-completion man-db manpages-dev mlocate ripgrep rsync tree time
lxc exec spksrc -- /usr/bin/updatedb
```

#### LXC: Shared `spksrc` user (OPTIONAL)
You can create a shared user between your Ubuntu and the LXC Debian container which simplifies greatly file management between the two.  The following assumes you already create a user `spksrc` with uid 1001 in your Ubuntu environment and that you which to share its `/home` userspace.
1. Create the `spksrc` user: `lxc exec spksrc -- /usr/sbin/adduser --uid 1001 spksrc`
2. Create a mapping rule between the hosts and the LXC image:
```
lxc config set spksrc raw.idmap "both 1001 1001"
lxc restart spksrc
Remapping container filesystem
```
3. Add `/home/spksrc` from the hsot to the LXC container:
```
lxc config device add spksrc home disk path=/home/spksrc source=/home/spksrc
Device home added to spksrc
```
4. Connect as `spksrc` user:
```
lxc exec spksrc -- su --login spksrc
spksrc@spksrc:~$
```
5. Set a defualt shell environment:
```
lxc exec spksrc -- su --login spksrc
spksrc@spksrc:~$ cp /etc/skel/.profile /etc/skel/.bashrc .
```
#### LXC: Proxy (OPTIONAL)
The following assume you have a running proxy on your LAN setup at IP 192.168.1.1 listening on port 3128 that will allow caching files.
1. Enforce using a proxy:
```
lxc config set spksrc environment.http_proxy http://192.168.1.1:3128
lxc config set spksrc environment.https_proxy http://192.168.1.1:3128
```
2. Enforce using a proxy with `wget` in the spksrc container user account:
```
lxc exec spksrc -- su --login spksrc
spksrc@spksrc:~$ cat << EOF > $HOME/.wgetrc
use_proxy = on
http_proxy = http://192.168.1.1:3128/
https_proxy = http://192.168.1.1:3128/
ftp_proxy = http://192.168.1.1:3128/
EOF
```


### Virtual machine
A virtual machine based on an 64-bit version of Debian 10 stable OS is recommended. Non-x86 architectures are not supported.

* Install the requirements (in sync with Dockerfile):
```bash
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt update
sudo apt install autoconf-archive autogen automake bc bison build-essential check cmake curl cython debootstrap ed expect fakeroot flex g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial moreutils ncurses-dev ninja-build patchelf php pkg-config python3 python3-distutils rename scons subversion sudo swig texinfo unzip xmlto zlib1g-dev
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | sudo python2
sudo pip2 install wheel httpie
wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python3
sudo pip3 install meson==0.62.2
```
* You may need to install some packages from testing like autoconf. Read about Apt-Pinning to know how to do that.
* Some older toolchains may require 32-bit development versions of packages, e.g. `zlib1g-dev:i386`


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
