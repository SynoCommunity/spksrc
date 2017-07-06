PKG_NAME = PyAudio
PKG_VERS = 0.2.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/P/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/portaudio

HOMEPAGE = http://people.csail.mit.edu/hubert/pyaudio/
COMMENT  = Provide Python bindings for PortAudio, the cross-platform audio I/O library
LICENSE  = MIT

include ../../mk/spksrc.python-wheel.mk
