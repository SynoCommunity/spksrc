SPK_NAME = ruby
SPK_VERS = 3.0.2
SPK_REV = 9
SPK_ICON = src/ruby.png

DEPENDS = cross/$(SPK_NAME)

# even it compiles with older cross/gdbm, ruby crashes at runtime
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

CHANGELOG = "1. Update ruby to v3.0.2.<br/>2. Update OpenSSL to v1.1.1l.<br/>3. Update bdb to v6.2.32."

MAINTAINER = SynoCommunity
DESCRIPTION = Ruby Programming Language.
DESCRIPTION_FRE = Langage de programmation Ruby.
DESCRIPTION_SPN = Lenguaje de programación Ruby.
STARTABLE = no
DISPLAY_NAME = Ruby

HOMEPAGE = http://www.ruby-lang.org/
LICENSE  = 2-clause BSDL

SPK_COMMANDS  = bin/bundle bin/bundler bin/erb bin/gem bin/irb bin/racc
SPK_COMMANDS += bin/rake bin/rbs bin/rdoc bin/ri bin/ruby bin/typeprof

include ../../mk/spksrc.spk.mk
