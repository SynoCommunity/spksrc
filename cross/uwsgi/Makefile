PKG_NAME = uwsgi
PKG_VERS = 2.0.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/u/uWSGI
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pcre

HOMEPAGE = https://pypi.python.org/pypi/uWSGI
COMMENT  = The uWSGI server
LICENSE  = GPL2

ifeq ($(findstring $(ARCH),ppc853x qoriq),$(ARCH))
ADDITIONAL_CFLAGS = -DUWSGI_EVENT_TIMER_USE_TIMERFD_NOINC
endif
ifeq ($(findstring $(ARCH),ppc854x ppc824x),$(ARCH))
ADDITIONAL_CFLAGS = -DOBSOLETE_LINUX_KERNEL
endif
#fixes x86/64-4.3
ifeq ($(findstring $(TCVERSION),4.3),$(TCVERSION))
ADDITIONAL_CFLAGS = -DOBSOLETE_LINUX_KERNEL
endif


include ../../mk/spksrc.python-wheel.mk
