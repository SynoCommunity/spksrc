SPK_NAME = mercurial
SPK_VERS = 6.0
SPK_REV = 8
SPK_ICON = src/mercurial.png

BUILD_DEPENDS = cross/python310

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt
SPK_DEPENDS = "python310"

MAINTAINER = SynoCommunity
DESCRIPTION = Mercurial is a free, distributed source control management tool
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = "1. Update mercurial to 6.0<br/>2. Update to Python 3.10"

HOMEPAGE = https://www.mercurial-scm.org/
LICENSE  = MPL1.1

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/hg

include ../../mk/spksrc.spk.mk
