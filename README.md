# Discord
SynoCommunity is now on Discord!

[![Discord](https://img.shields.io/discord/732558169863225384?color=7289DA&label=Discord&logo=Discord&logoColor=white&style=for-the-badge)](https://discord.gg/nnN9fgE7EF)

# spksrc
spksrc is a cross compilation framework intended to compile and package software for Synology NAS devices. Packages are made available via the [SynoCommunity repository].


# DSM 7
DSM 7 was released on June 29 2021 as Version 7.0.41890.

* The main issue we had with our reposity is fixed in [spkrepo](https://github.com/SynoCommunity/spkrepo/pull/112) and online since February 2024
  - before the repository deliverd DSM 6 packages for Systems with DSM 7, when no DSM 7 package was available
  - this gave errors like "invalid file format" (or "package requires root privileges")
  - you still get this error when manually installing a DSM 6 package on DSM 7
* You find the status of the former packages in the issue [#4524] **Meta: DSM7 package status**
* New packages support DSM 7 from initial package version (and some require at least DSM 7).
* **ATTENTION**: As reported, package configuration settings may be lost following the upgrade to DSM 7 and the execution of a Package repair. Make sure to backup your settings and configuration for your SynoCommunity packages before installation of DSM 7 to facilitate restoration if needed.


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
docker run -it --platform=linux/amd64 -v $(pwd):/spksrc -w /spksrc ghcr.io/synocommunity/spksrc /bin/bash

# If running on macOS:
docker run -it --platform=linux/amd64 -v $(pwd):/spksrc -w /spksrc -e TAR_CMD="fakeroot tar" ghcr.io/synocommunity/spksrc /bin/bash
```
5. From there, follow the instructions in the [Developers HOW TO].



### Virtual machine
A virtual machine based on an 64-bit version of Debian 12 stable OS is recommended. Non-x86 architectures are not supported.

Install the requirements (in sync with `Dockerfile`):
```bash
sudo dpkg --add-architecture i386 && sudo apt-get update
sudo apt update
sudo apt install autoconf-archive autogen automake autopoint bash \
                 bash-completion bc bison build-essential check cmake \
                 curl cython3 debootstrap ed expect fakeroot flex \
                 g++-multilib gawk gettext gh git gperf httpie imagemagick \
                 intltool jq libtool-bin libbz2-dev libc6-i386 libcppunit-dev libffi-dev \
                 libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev \
                 libpcre3-dev libssl-dev libtool libunistring-dev lzip \
                 man-db manpages-dev mercurial meson mlocate moreutils nasm \
                 ninja-build patchelf php pkg-config python3 python3-distutils \
                 python3-mako python3-pip python3-virtualenv python3-yaml \
                 rename ripgrep ruby-mustache rsync scons subversion \
                 swig texinfo time tree unzip xmlto yasm zip zlib1g-dev
```
From there, follow the instructions in the [Developers HOW TO].

* You may need to install some packages from testing like autoconf. Read about Apt-Pinning to know how to do that.
* Some older toolchains may require 32-bit development versions of packages, e.g. `zlib1g-dev:i386`



### LXC
A container based on 64-bit version of Debian 12 stable OS is recommended. Non-x86 architectures are not supported.  The following assumes your LXD/LXC environment is already initiated (e.g. `lxc init`) and you have minimal LXD/LXC basic knowledge :
1. Create a new container (will use x86_64/amd64 arch by default): `lxc launch images:debian/12 spksrc`
2. Enable i386 arch: `lxc exec spksrc -- /usr/bin/dpkg --add-architecture i386`
3. Update apt channels: `lxc exec spksrc -- /usr/bin/apt update`
4. Install all required packages:
```bash
lxc exec spksrc -- /usr/bin/apt install autoconf-archive autogen automake autopoint bash \
                                        bash-completion bc bison build-essential check cmake \
                                        curl cython3 debootstrap ed expect fakeroot flex \
                                        g++-multilib gawk gettext gh git gperf httpie imagemagick \
                                        intltool jq libtool-bin libbz2-dev libc6-i386 libcppunit-dev libffi-dev \
                                        libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev \
                                        libpcre3-dev libssl-dev libtool libunistring-dev lzip \
                                        man-db manpages-dev mercurial meson mlocate moreutils nasm \
                                        ninja-build patchelf php pkg-config python3 python3-distutils \
                                        python3-mako python3-pip python3-virtualenv python3-yaml \
                                        rename ripgrep ruby-mustache rsync scons subversion \
                                        swig texinfo time tree unzip xmlto yasm zip zlib1g-dev
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
