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
    sudo apt udpate
    sudo apt install autogen automake bc bison build-essential check cmake curl cython debootstrap ed expect flex g++-multilib gawk gettext git gperf imagemagick intltool jq libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev libssl-dev libtool libunistring-dev lzip mercurial ncurses-dev ninja-build php pkg-config python3 python3-distutils rename scons subversion swig texinfo unzip xmlto zlib1g-dev
    wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python2
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
