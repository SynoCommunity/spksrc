SPK_NAME = test-build
SPK_VERS = 1.0
SPK_REV = 1

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# [pycairo]
# --- Removed as a test ---
# DEPENDS += python/pycairo

# [pygobject] - depends on [pycairo]
DEPENDS += python/pygobject

MAINTAINER = mreid-tt
STARTABLE = no

include ../../mk/spksrc.python.mk
