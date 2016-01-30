spksrc
======
spksrc is a cross compilation framework intended to compile and package software for Synology NAS devices. Packages are made available via the `SynoCommunity repository`_.


Contributing
------------
Before opening issues or package requests, see `CONTRIBUTING`_.


Setup Development Environment
-----------------------------
Docker
^^^^^^
* Fork and clone spksrc: ``git clone https://You@github.com/You/spksrc.git ~/spksrc``
* Install Docker on your host OS: `Docker installation`_. A wget-based alternative for linux: `Install Docker with wget`_.
* Download the spksrc docker container: ``docker pull synocommunity/spksrc``
* Run the container with ``docker run -it -v ~/spksrc:/spksrc synocommunity/spksrc /bin/bash``


Virtual machine
^^^^^^^^^^^^^^^
A virtual machine based on an x86, 32-bit version of Debian stable OS is recommended. Non-x86 architectures or 64-bit architectures are not supported.

* Install the requirements::

    sudo aptitude install build-essential debootstrap python-pip automake libgmp3-dev libltdl-dev libunistring-dev libffi-dev ncurses-dev imagemagick libssl-dev pkg-config zlib1g-dev gettext git curl subversion check bjam intltool gperf flex bison xmlto php5 expect libgc-dev mercurial cython lzip cmake swig
    sudo pip install -U setuptools pip wheel httpie

* You may need to install some packages from testing like autoconf. Read about Apt-Pinning to know how to do that.
* Start the virtual machine

For further instructions, refer to Pull Requests section of `CONTRIBUTING`_.


Donate
------
If you like spksrc and packages created with it, consider making a donation to its core developers:

* Diaoul

  .. image:: https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif
    :target: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=F6GDE5APQ4SBN

  .. image:: http://api.flattr.com/button/flattr-badge-large.png
    :target: http://flattr.com/thing/718012/SynoCommunity

* moneytoo

  .. image:: https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif
    :target: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DQKBRZBVPC77L

* piwi82

  .. image:: https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif
    :target: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T6BU3QXYH4CMG

* bru7us

  .. image:: https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif
    :target: https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=W3UX3VM22WRQY&item_name=SynoCommunity

  .. image:: http://api.flattr.com/button/flattr-badge-large.png
    :target: http://flattr.com/thing/1106801/


License
-------
When not explicitly set, files are placed under a `3 clause BSD license`_


.. _3 clause BSD license: http://www.opensource.org/licenses/BSD-3-Clause
.. _bug tracker: https://github.com/SynoCommunity/spksrc/issues
.. _CONTRIBUTING: https://github.com/SynoCommunity/spksrc/blob/master/CONTRIBUTING.md
.. _Docker installation: https://docs.docker.com/engine/installation
.. _Install Docker with wget: https://docs.docker.com/linux/step_one
.. _SynoCommunity repository: http://www.synocommunity.com
