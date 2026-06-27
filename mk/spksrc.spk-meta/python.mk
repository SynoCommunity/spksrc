###############################################################################
# spksrc.spk-meta/python.mk
#
# Python meta integration: selects the python* meta and its constraints
# when PYTHON_PACKAGE is set.
###############################################################################

# Set default python package name
ifeq ($(strip $(PYTHON_PACKAGE)),)
  PYTHON_PACKAGE = python312
endif

# Mark default unsupported archs
ifeq ($(call version_ge, $(PYTHON_PACKAGE), python312),1)
  UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
endif

# set default spk/python* path to use
PYTHON_PACKAGE_DIR = $(abspath $(CURDIR)/../../spk/$(PYTHON_PACKAGE))
PYTHON_PACKAGE_WORK_DIR = $(PYTHON_PACKAGE_DIR)/work-$(ARCH)-$(TCVERSION)

PYTHON_DEPENDS += cross/$(PYTHON_PACKAGE)
META_DEPENDS += $(PYTHON_DEPENDS)
OPTIONAL_DEPENDS += $(PYTHON_DEPENDS)

# Build the meta source spk/$(PYTHON_PACKAGE) in spk-stage1 so its work dir
# exists for the stage2 SPK_BASE_TEMPLATE parse (distinct from
# cross/$(PYTHON_PACKAGE), the embeddable python library).
BUILD_DEPENDS := $(call uniq,spk/$(PYTHON_PACKAGE) $(BUILD_DEPENDS))

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

# Export the python package name for every goal (used by the crossenv / wheel
# machinery).
export PYTHON_PACKAGE
export PYTHON_PACKAGE_DIR

# Share the meta's libraries at spk-stage2, where its work dir exists (built by
# stage1); SPK_BASE_TEMPLATE runs $(shell)/realpath that require the built meta.
ifneq ($(and $(wildcard $(PYTHON_PACKAGE_WORK_DIR)),$(filter spk-stage2,$(MAKECMDGOALS))),)
  export PYTHON_PACKAGE_WORK_DIR
  $(eval $(call SPK_BASE_TEMPLATE,PYTHON))
endif
