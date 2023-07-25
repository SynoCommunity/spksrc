###
### Reuse Python libraries
###

# Default python version to use
ifeq ($(strip $(PYTHON_VERSION)),)
export PYTHON_VERSION = 311
endif

# set default spk/python* path to use
export PYTHON_DIR = $(realpath $(shell pwd)/../python$(PYTHON_VERSION)/work-$(ARCH)-$(TCVERSION)/install/var/packages/python$(PYTHON_VERSION)/target)

# set PYTHONPATH for spksrc.python-module.mk
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(PYTHON_DIR)/lib/python$(shell echo $${PYTHON_VERSION%??}).$(shell echo $${PYTHON_VERSION#?})/site-packages/

# always define SPK_DEPENDS
SPK_DEPENDS := "python$(PYTHON_VERSION)>=$(shell sed -n 's/^SPK_VERS = \(.*\)/\1/p' $(shell pwd)/../python$(PYTHON_VERSION)/Makefile)-$(shell sed -n 's/^SPK_REV = \(.*\)/\1/p' $(shell pwd)/../python$(PYTHON_VERSION)/Makefile)"

ifneq ($(wildcard $(PYTHON_DIR)),)
export ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(PYTHON_DIR)/lib -Wl,--rpath,/var/packages/python$(PYHTON_VERSION)/target/lib
PRE_DEPEND_TARGET = python_pre_depend
else
BUILD_DEPENDS += cross/python$(PYTHON_VERSION)
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
PYTHON_LIBS += python-$(shell echo $${PYTHON_VERSION%??}).$(shell echo $${PYTHON_VERSION#?})-embed.pc
PYTHON_LIBS += python-$(shell echo $${PYTHON_VERSION%??}).$(shell echo $${PYTHON_VERSION#?}).pc
PYTHON_LIBS += python$(shell echo $${PYTHON_VERSION%??})-embed.pc
PYTHON_LIBS += python$(shell echo $${PYTHON_VERSION%??}).pc
PYTHON_LIBS += readline.pc
PYTHON_LIBS += sqlite3.pc
PYTHON_LIBS += uuid.pc
PYTHON_LIBS += zlib.pc

include ../../mk/spksrc.spk.mk

.PHONY: python_pre_depend
python_pre_depend:
	@mkdir -p $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/
	@$(foreach lib,$(PYTHON_LIBS),ln -sf $(PYTHON_DIR)/lib/pkgconfig/$(lib) $(STAGING_INSTALL_PREFIX)/lib/pkgconfig/ ;)
	@ln -sf $(realpath $(shell pwd)/../python$(PYTHON_VERSION)/work-$(ARCH)-$(TCVERSION)/crossenv) $(STAGING_INSTALL_PREFIX)/crossenv
