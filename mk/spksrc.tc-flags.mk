TOOLS = ld ldshared:"gcc -shared" cpp nm cc:gcc as ranlib cxx:g++ ar strip objdump readelf

ifeq ($(strip $(TC_INCLUDE)),)
TC_INCLUDE = $(TC_SYSROOT)/usr/include
endif

ifeq ($(strip $(TC_LIBRARY)),)
TC_LIBRARY = $(TC_SYSROOT)/lib
endif

CFLAGS += -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_INCLUDE) $(TC_CFLAGS)
CFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CPPFLAGS += -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_INCLUDE) $(TC_CFLAGS)
CPPFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

CXXFLAGS += -I$(WORK_DIR)/$(TC_PREFIX)/$(TC_INCLUDE) $(TC_CFLAGS)
CXXFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include

LDFLAGS += -L$(WORK_DIR)/$(TC_PREFIX)/$(TC_LIBRARY) $(TC_CFLAGS)
LDFLAGS += -L$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath-link,$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib
LDFLAGS += -Wl,--rpath,$(INSTALL_PREFIX)/lib
