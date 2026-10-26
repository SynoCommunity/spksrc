###############################################################################
# spksrc.driver-virtual.mk
#
# Source-less driver/<pkg> that builds one version of a driver per kernel: the
# first of its DEPENDS, driver/* listed in order of preference, that does not
# skip that kernel (spksrc.driver.mk, DRIVER_SKIP). The counterpart of
# $(call depend,a|b|c) for drivers, whose choice depends on the kernel and gcc
# of each sub-arch rather than on the generic arch an spk is built for.
#
# kernel-depend builds it like any driver, after each kernel; DEPENDS lists every
# version, so dependency lists, downloads and CI see them all.
#
# A kernel no version builds for is an error: an arch the driver does not
# support is excluded from the spk, not shipped without its modules.
###############################################################################

NAME = $(PKG_NAME)

.DEFAULT_GOAL := all

include ../../mk/spksrc.common.mk

# Nothing of its own to fetch, verify or package: the spk PLIST covers what the
# chosen version installs
.PHONY: download checksum cat_PLIST
download checksum cat_PLIST:
	@:

.PHONY: all
ifneq ($(filter $(ARCH),$(GENERIC_ARCHS) noarch),)
all:
	@$(MSG) "Skipping $(NAME) for $(ARCH)-$(TCVERSION): $(ARCH) is a generic arch"
else
all:
	@for driver in $(DEPENDS) ; do \
	  skip=$$($(MAKE) -s --no-print-directory -C ../../$${driver} driver-skip) ; \
	  if [ -z "$${skip}" ]; then \
	    $(MSG) "$(NAME): $${driver} for $(ARCH)-$(TCVERSION)" ; \
	    $(MAKE) --no-print-directory -C ../../$${driver} ; \
	    exit $$? ; \
	  fi ; \
	  $(MSG) "$(NAME): not $${driver}, $${skip}" ; \
	done ; \
	$(MSG) "$(NAME): no version builds for $(ARCH)-$(TCVERSION)" ; \
	exit 1
endif

.PHONY: driver-skip
driver-skip:
	@:

include ../../mk/spksrc.rules/supported.mk
