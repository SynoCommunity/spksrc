SPK_NAME = ruby
SPK_VERS = 3.0.0
SPK_REV = 0
SPK_ICON = src/ruby.png

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Ruby Programming Language.
DESCRIPTION_FRE = Langage de programmation Ruby.
DESCRIPTION_SPN = Lenguaje de programación Ruby.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Ruby
BETA = 1

HOMEPAGE   = http://www.ruby-lang.org/
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

SPK_COMMANDS  = bin/bundle bin/bundler bin/erb bin/gem bin/irb bin/racc
SPK_COMMANDS += bin/rake bin/rbs bin/rdoc bin/ri bin/ruby bin/typeprof

include ../../mk/spksrc.spk.mk
