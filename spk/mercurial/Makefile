SPK_NAME = mercurial
SPK_VERS = 6.5
SPK_REV = 9
SPK_ICON = src/mercurial.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Mercurial is a free, distributed source control management tool
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = "1. Update mercurial to 6.5.<br/>2. Update to Python 3.11."

HOMEPAGE = https://www.mercurial-scm.org/
LICENSE  = MPL1.1

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/hg

include ../../mk/spksrc.python.mk
