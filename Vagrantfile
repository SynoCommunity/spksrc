# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
  config.vm.provision "shell", inline: <<~EOF
    dpkg --add-architecture i386
    apt-get update
    apt-get install --yes \
      autoconf-archive autogen automake bc bison build-essential check \
      cmake curl cython debootstrap ed expect fakeroot flex \
      g++-multilib gawk gettext git gperf imagemagick intltool jq\
      libbz2-dev libc6-i386 libcppunit-dev libffi-dev libgc-dev \
      libgmp3-dev libltdl-dev libmount-dev libncurses-dev libpcre3-dev \
      libssl-dev libtool libunistring-dev lzip mercurial ncurses-dev \
      ninja-build php pkg-config python3 python3-distutils rename scons \
      subversion swig texinfo unzip xmlto zlib1g-dev
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | python2
    pip2 install wheel httpie
    wget https://bootstrap.pypa.io/get-pip.py -O - | python3
    pip3 install meson==0.56.0
  EOF

  config.vm.post_up_message = <<~EOF
    For further instructions, see:
      https://github.com/SynoCommunity/spksrc/wiki/Developers-HOW-TO#build-a-package
  EOF
end
