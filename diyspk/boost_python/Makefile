SPK_NAME = boost_python
SPK_VERS = 1.78.0
SPK_REV = 1

BUILD_DEPENDS = cross/python310
DEPENDS = cross/boost

MAINTAINER = SynoCommunity
DESCRIPTION = Makefile to build boost-python library.
STARTABLE = no

BOOST_LIBRARIES += python
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.spk.mk
