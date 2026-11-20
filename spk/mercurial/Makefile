SPK_NAME = mercurial
SPK_VERS = 7.2.4
SPK_REV = 12
SPK_ICON = src/mercurial.png

PYTHON_PACKAGE = python314

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Mercurial is a free, distributed source control management tool
STARTABLE = no
DISPLAY_NAME = Mercurial
CHANGELOG = "Update Mercurial to 7.2.4."

HOMEPAGE = https://www.mercurial-scm.org/
LICENSE  = MPL1.1

SERVICE_SETUP = src/service-setup.sh

SPK_USR_LOCAL_LINKS = bin:env/bin/hg

POST_SERVICE_TARGET = mercurial_extra_install

include ../../mk/spksrc.spk-meta.mk

.PHONY: mercurial_extra_install
mercurial_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
