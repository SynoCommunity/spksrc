How to use the spk toolchain-gcc47 package
==========================================

Toolchain-gcc47 is a package which creates a new toolchain for a synology architecture.
The new toolchain consists of binutils 2.23.2, gcc 4.7.3 and glibc 2.18.
Currently only the cedarview architecture is "tested" but the package is enabled for:

cedarview, bromolow, x86 and 88f6281

Status of the toolchains::

	architecture    ( toolchain:    binutils    gcc    glibc )    generate binaries    helloworld

	cedarview             ok           ok       ok       ok               ok              ok
	bromolow              ok           ok       ok       ok               ok              (cannot test)
	x86                   ok           ok       ok       ok               ok              (cannot test)
	88f6281               ok           ok       ok       ok               ok              ok


Generating the toolchain
------------------------

Let's start with cloning the repository and switch to the experimental branch::

    git clone https://github.com/Ximi1970/spksrc.git
    cd spksrc
    git checkout experimental
    make setup
    
Now we can build the package::

    cd spk/toolchain-gcc47
    make arch-cederview

To make use of parallel making, you could add the option::

	MAKE_OPT="-j4"

to your local.mk setup file.
Compiling the toolchain will take a LONG time. (core i7-2630QM 2Ghz, 20 minutes)


What is generated and what can we do now?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* You now have a new toolchain in the spksrc/toolchains directory called "syno-cedarview-gcc47".
* You can use this new toolchain to compile a package by using::

    cd spksrc/spk/helloworld
    make arch-cedarview-gcc47

* Packages build with the new toolchain will get the extension "<package_name>_cederview-gcc47_<version>.spk".
* There is a "toolchain-gcc47_cedarview_4.7.3" package in the spksrc/packages directory. You will need
  to install this package on your synology if you want to run the packages compiled with the new toolchain.

  
Removing the toolchain
----------------------

You can remove a toolchain by running::

    cd spksrc/spk/toolchain-gcc47
    make clean-cedarview

If you want to remove all toolchains::

    cd spksrc/spk/toolchain-gcc47
    make clean-all-arch

