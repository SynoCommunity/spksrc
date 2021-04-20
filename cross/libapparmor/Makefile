PKG_NAME = libapparmor
include ./apparmor.pkg.mk

COMMENT  = Library for interacting with the AppArmor linux kernel security module
LICENSE  = GPLv2

DEPENDS =

PRE_CONFIGURE_TARGET = libapparmor_pre_configure
CONFIGURE_TARGET = libapparmor_configure

COMPILE_TARGET = libapparmor_compile

INSTALL_TARGET = libapparmor_install

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-man-pages
ifeq ($(strip $(AA_BINDING_PYTHON)),y)
CONFIGURE_ARGS += --with-python
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(strip $(AA_BINDING_PYTHON)),y)
# Fetch python variables
# Deliberately fail if you forgot to depend on cross/pythonXY
include $(WORK_DIR)/python-cc.mk

HOST_PYTHON_DIR=$(dir $(HOSTPYTHON))
HOST_PYTHON_CONFIG=$(HOST_PYTHON_DIR)python-config

PYTHONPATH = $$(realpath swig/python):$(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/

PYTHON_CPPFLAGS  = -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include
PYTHON_CPPFLAGS += -I$(INSTALL_DIR)$(INSTALL_PREFIX)/include/python$(PYTHON_VERSION)
PYTHON_CPPFLAGS += -Wno-unused-result -Wsign-compare -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DNDEBUG -g -fwrapv -O3 -Wall

PYTHON_LDFLAGS  = -L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib
PYTHON_LDFLAGS += -L$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)
PYTHON_LDFLAGS += -lpython$(PYTHON_VERSION) -lcrypt -lpthread -ldl -lpthread -lutil -lm

PYTHON_SITE_PKG = $(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/

PYTHON_EXTRA_LIBS = -Wl,-rpath,/usr/local/libapparmor/lib -L. -lpython$(PYTHON_VERSION)  -lcrypt -lpthread -ldl -lpthread -lutil -lm

PYTHON_EXTRA_LDFLAGS  = -L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib
PYTHON_EXTRA_LDFLAGS += -Xlinker -export-dynamic -lpython$(PYTHON_VERSION) -lcrypt -lpthread -ldl  -lpthread -lutil -lm

ENV += PYTHONPATH=$(PYTHONPATH)
ENV += PYTHON=$$(. $(CROSSENV) && which python)
ENV += PYTHON_CPPFLAGS="$(PYTHON_CPPFLAGS)"
ENV += PYTHON_LDFLAGS="$(PYTHON_LDFLAGS)"
ENV += PYTHON_SITE_PKG="$(PYTHON_SITE_PKG)"
ENV += PYTHON_EXTRA_LIBS="$(PYTHON_EXTRA_LIBS)"
ENV += PYTHON_EXTRA_LDFLAGS="$(PYTHON_EXTRA_LDFLAGS)"
endif

LAA_RUN = cd $(WORK_DIR)/$(PKG_DIR)/libraries/libapparmor && env $(ENV)

.PHONY: libapparmor_pre_configure
libapparmor_pre_configure:
	@. $(CROSSENV) && $(LAA_RUN) ./autogen.sh

.PHONY: libapparmor_configure
libapparmor_configure:
	@. $(CROSSENV) && $(LAA_RUN) ./configure $(REAL_CONFIGURE_ARGS)

.PHONY: libapparmor_compile
libapparmor_compile:
	@. $(CROSSENV) && $(LAA_RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: libapparmor_install
libapparmor_install:
	@. $(CROSSENV) && $(LAA_RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install prefix=$(INSTALL_PREFIX)
