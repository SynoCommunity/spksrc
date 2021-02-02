DSM 7
=====

PLEASE consider: DSM 7 is not officially released yet. The beta release is available since December 08 2020 and there will (hopefully) be a Release Candidate (RC 1) in the near future. We expect an official Release of DSM 7 by Synology later in 2021 (be not surprised when DSM 7 is not officially released before summer 2021).

In SynoCommunity there are no DSM 7 compatible packages released yet.
---------------------------------------------------------------------

* Despite you see packages of SynoCommunity in the Package Center of your Diskstation with DSM 7, these packages are not compatible with DSM 7.
* PLEASE do not create issues saying that package _xy_ cannot be installed on DSM 7.
* We will create an issue here that will give an overview of the packages, whether available for DSM 7 or not. But this will not start before the dsm7 branch is merged back into master and we have official DSM 7 toolchains available from synology.
* If you want to try preview versions of packages for DSM 7 that are built on the dsm7 branch, you can look into PR #4395 https://github.com/SynoCommunity/spksrc/pull/4395. From time to time you will find preview versions for manual installation on DSM 7.
* And we have issue #4215 for DSM 7 related discussions https://github.com/SynoCommunity/spksrc/issues/4215.
* You are welcome to contribute: checkout the dsm7 branch and try to build and test the installation of your favorite package and give related feedback. This will shorten the time from official DSM 7 release until the package is available in the SynoCommunity Package Center for download.
* As this is a community project where people spend there spare time for contribution, it may take a long time until most of the packages are ported to DSM 7. (There are still packages here that are not ported from DSM 5 to DSM 6 yet).

spksrc
======
spksrc is a cross compilation framework intended to compile and package software for Synology NAS devices. Packages are made available via the `SynoCommunity repository`_.


Contributing
------------
Before opening a new issue, check the `FAQ`_ and search open issues.
If you can't find an answer, or if you want to open a package request, read `CONTRIBUTING`_ to make sure you include all the information needed for contributors to handle your request.


Setup Development Environment
-----------------------------
Docker
^^^^^^
* `Fork and clone`_ spksrc: ``git clone https://github.com/YOUR-USERNAME/spksrc ~/spksrc``
* Install Docker on your host OS: `Docker installation`_. A wget-based alternative for linux: `Install Docker with wget`_.
* Download the spksrc docker container: ``docker pull synocommunity/spksrc``
* Run the container with ``docker run -it -v ~/spksrc:/spksrc synocommunity/spksrc /bin/bash``


Virtual machine
^^^^^^^^^^^^^^^
A virtual machine based on an 64-bit version of Debian 10 stable OS is recommended. Non-x86 architectures are not supported.

* Install the requirements (in sync with Dockerfile)::

    sudo dpkg --add-architecture i386 && sudo apt-get update
    sudo apt update
    sudo apt install autogen automake bc bison build-essential check cmake curl cython debootstrap ed expect flex g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial ncurses-dev ninja-build php pkg-config python3 python3-distutils rename scons subversion swig texinfo unzip xmlto zlib1g-dev
    wget https://bootstrap.pypa.io/2.7/get-pip.py -O - | sudo python2
    sudo pip2 install wheel httpie
    wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python3
    sudo pip3 install meson==0.56.0

* You may need to install some packages from testing like autoconf. Read about Apt-Pinning to know how to do that.
* Some older toolchains may require 32-bit development versions of packages, e.g. `zlib1g-dev:i386`


Usage
-----
Once you have a development environment set up, you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people.
See the `Developers HOW TO`_ for information on how to use spksrc.


Donate
------
To support SynoCommunity, you can make a donation to its founder

  .. image:: https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif
    :target: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F6GDE5APQ4SBN


License
-------
When not explicitly set, files are placed under a `3 clause BSD license`_

.. _3 clause BSD license: http://www.opensource.org/licenses/BSD-3-Clause

.. _bug tracker: https://github.com/SynoCommunity/spksrc/issues
.. _CONTRIBUTING: https://github.com/SynoCommunity/spksrc/blob/master/CONTRIBUTING.md
.. _Fork and clone: https://docs.github.com/en/github/getting-started-with-github/fork-a-repo
.. _Developers HOW TO: https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO
.. _Docker installation: https://docs.docker.com/engine/installation
.. _FAQ: https://github.com/SynoCommunity/spksrc/wiki/Frequently-Asked-Questions
.. _Install Docker with wget: https://docs.docker.com/linux/step_one
.. _SynoCommunity repository: http://www.synocommunity.com
