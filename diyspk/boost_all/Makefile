SPK_NAME = boost_all
SPK_VERS = 1.78.0
SPK_REV = 1

DEPENDS = cross/boost

MAINTAINER = SynoCommunity
DESCRIPTION = Makefile to build all boost libraries (except boost-python).
STARTABLE = no

BOOST_LIBRARIES += all
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.spk.mk
