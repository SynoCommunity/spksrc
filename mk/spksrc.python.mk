###
### Reuse Python libraries
###
# Variables:
#  PYTHON_PACKAGE       Must be set to the python spk folder (python310, python311, ...)


# set default spk/python* path to use
PYTHON_PACKAGE_ROOT = $(realpath $(shell pwd)/../$(PYTHON_PACKAGE)/work-$(ARCH)-$(TCVERSION))
export PYTHON_DIR = $(realpath $(PYTHON_PACKAGE_ROOT)/install/var/packages/$(PYTHON_PACKAGE)/target)

# get PYTHON_VERSION and other variables
-include $(PYTHON_PACKAGE_ROOT)/python-cc.mk

# set PYTHONPATH for spksrc.python-module.mk
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(PYTHON_DIR)/lib/python$(PYTHON_VERSION)/site-packages/

ifneq ($(wildcard $(PYTHON_DIR)),)
export ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(PYTHON_DIR)/lib -Wl,--rpath,/var/packages/$(PYTHON_PACKAGE)/target/lib
PRE_DEPEND_TARGET = python_pre_depend
else
BUILD_DEPENDS += cross/$(PYTHON_PACKAGE)
endif

# minimal set of libraries to use
PYTHON_LIBS  = expat.pc
PYTHON_LIBS += formw.pc
PYTHON_LIBS += history.pc
PYTHON_LIBS += libcrypto.pc
PYTHON_LIBS += libffi.pc
PYTHON_LIBS += liblzma.pc
PYTHON_LIBS += libssl.pc
PYTHON_LIBS += menuw.pc
PYTHON_LIBS += ncurses++w.pc
PYTHON_LIBS += ncursesw.pc
PYTHON_LIBS += openssl.pc
PYTHON_LIBS += panelw.pc
PYTHON_LIBS += python-$(PYTHON_VERSION)-embed.pc
PYTHON_LIBS += python-$(PYTHON_VERSION).pc
PYTHON_LIBS += python$(shell echo $${PYTHON_VERSION%??})-embed.pc
PYTHON_LIBS += python$(shell echo $${PYTHON_VERSION%??}).pc
PYTHON_LIBS += readline.pc
PYTHON_LIBS += sqlite3.pc
PYTHON_LIBS += uuid.pc
PYTHON_LIBS += zlib.pc

include ../../mk/spksrc.spk.mk

.PHONY: python_pre_depend
python_pre_depend:
	@$(MSG) Use existing python in $(PYTHON_PACKAGE_ROOT)
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(PYTHON_LIBS),ln -sf $(PYTHON_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@ln -sf $(PYTHON_PACKAGE_ROOT)/crossenv $(STAGING_INSTALL_PREFIX)/crossenv
	@ln -sf $(PYTHON_PACKAGE_ROOT)/python-cc.mk $(WORK_DIR)/python-cc.mk
