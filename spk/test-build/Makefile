SPK_NAME = test-build
SPK_VERS = 1.0
SPK_REV = 1

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# [pycairo]
DEPENDS += python/pycairo

# [pygobject] - depends on [pycairo]
DEPENDS = python/pygobject

MAINTAINER = mreid-tt
STARTABLE = no

include ../../mk/spksrc.python.mk
