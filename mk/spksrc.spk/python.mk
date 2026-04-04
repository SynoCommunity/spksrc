
# Set default python package name
ifeq ($(strip $(PYTHON_PACKAGE)),)
  PYTHON_PACKAGE = python312
endif

# set default spk/python* path to use
PYTHON_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(PYTHON_PACKAGE))
PYTHON_PACKAGE_WORK_DIR = $(PYTHON_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

PYTHON_DEPENDS += cross/$(PYTHON_PACKAGE)
META_DEPENDS += $(PYTHON_DEPENDS)
OPTIONAL_DEPENDS += $(PYTHON_DEPENDS)

.PHONY: PYTHON_meta
PYTHON_meta:
	@# EXCEPTION: Do not symlink cross/* wheel builds
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   if grep -q spksrc.python-wheel.mk $${makefile} ; then \
	      pkgstr=$$(grep ^PKG_NAME $${makefile}) ; \
	      pkgname=$$(echo $${pkgstr#*=} | xargs) ; \
	      find $(WORK_DIR)/$${pkgname}* $(WORK_DIR)/.$${pkgname}* -maxdepth 0 -type l -exec rm -fr {} \; 2>/dev/null || true ; \
	   fi ; \
	done

ifneq ($(and $(wildcard $(PYTHON_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export PYTHON_PACKAGE
  export PYTHON_PACKAGE_DIR
  export PYTHON_PACKAGE_WORK_DIR
  export PYTHON_DEPENDS
  export META_DEPENDS
  $(eval $(call SPK_BASE_TEMPLATE,PYTHON))
else
  DEPENDS += $(PYTHON_DEPENDS)
endif
