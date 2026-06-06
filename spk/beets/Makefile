SPK_NAME = beets
SPK_VERS = 2.11.0
SPK_REV = 13
SPK_ICON = src/beets.png

PYTHON_PACKAGE = python314

# numpy, pygobject, llvm (for librosa/autobpm via llvmlite)
REQUIRED_MIN_DSM = 7.2
REQUIRED_MIN_SRM = 1.3

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = ymartin59
DESCRIPTION = Beets is the media library management system for obsessive music geeks. The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music.

DISPLAY_NAME = beets
STARTABLE = no
CHANGELOG = "1. Update beets to 2.11.0. <br/>2. Migrate to Python 3.14. <br/>3. Add autobpm plugin support (requires DSM 7.2+)."

HOMEPAGE = https://beets.io/
LICENSE  = MIT

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/beet
SPK_COMMANDS += bin/mp3gain

# NOTE: Built with support for the following plugins:
# autobpm, beatport, chroma, discogs, embedart, embyupdate, fetchart, kodiupdate, lastgenre, lastimport, lyrics, metasync, plexupdate, replaygain, scrub, sonosupdate.

### dependencies for plugins:
### -------------------------

### plugin: metasync
# [dbus-python]
DEPENDS += python/dbus-python

### plugin: sonosupdate
# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

### plugins: embedart, fetchart
# [Pillow]
DEPENDS += python/pillow

### plugin: replaygain
# [pycairo]
DEPENDS += python/pycairo

# [pygobject] - depends on [pycairo]
DEPENDS += python/pygobject

### plugin: replaygain
DEPENDS += cross/mp3gain

### -------------------------

# [PyYAML]
DEPENDS += cross/libyaml

# [llvmlite] - requires LLVM
DEPENDS += cross/llvm-20.0

# [scipy] - built via requirements-crossenv.txt, needs OpenBLAS
DEPENDS += cross/openblas

include ../../mk/spksrc.common.mk

ENV += CMAKE_PREFIX_PATH=$(STAGING_INSTALL_PREFIX)
ENV += PIP_FIND_LINKS=$(WHEELHOUSE)

# Workaround for GCC 12.2.0 ICE on aarch64 in scikit-learn vectorization
WHEELS_CFLAGS = [scikit_learn] -fno-tree-vectorize

# Cross-python: swap PYTHONPATH order so build-side (native) packages are found first
POST_CROSSENV_TARGET = beets_post_crossenv
.PHONY: beets_post_crossenv
beets_post_crossenv: $(CROSSENV_TARGET)
	$(MAKE) $(CROSSENV_PATH)/build/python-cc.mk
	@cross_bin="$(CROSSENV_PATH)/cross/bin/python3"; \
	if [ -f "$$cross_bin" ]; then \
	   sed -i "s/os.pathsep.join(\[newpath, oldpath\])/os.pathsep.join([oldpath, newpath])/g" "$$cross_bin"; \
	fi

include ../../mk/spksrc.spk-meta.mk
