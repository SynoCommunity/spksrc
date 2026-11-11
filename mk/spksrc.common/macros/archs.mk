###############################################################################
# spksrc.common/macros/archs.mk
#
# Which toolchain an overlay, or its producer, stands for.
#
# A generic arch (x64, armv7, aarch64) uses the toolchain of a real arch, so it uses that
# arch's overlay archive too: x64-6.2.4 takes the one of x86-6.2.4, x64-7.1 the one of
# apollolake-7.1. Any other arch takes its own. Both sides of the archive name agree on it:
#
#   producer  native/<component>   names the archive it publishes
#   consumer  overlay/<dir>        names the archive it downloads
#
# The revision in that name is the consumer's PKG_REV; a producer builds the next one
# (toolchain_published_rev).
#
# These read the toolchain Makefiles, so only producers and consumers ever expand them --
# never a package build.
###############################################################################

# Macro: the arch an overlay archive is named after
#
#   OVERLAY_DIST_ARCH := $(call overlay_dist_arch,$(TC_ARCH),$(TC_VERS))
#
# <arch> itself, unless its base toolchain is a generic one declaring several TC_ARCH:
# then the real arch of the same DSM version whose base toolchain is the same archive
# (TC_DIST). Same toolchain in, same overlay out -- one build serves both. Reads the
# toolchain Makefiles in sorted order, so the answer is stable; a single shell.
define overlay_dist_arch
$(shell cd $(CURDIR)/../../toolchain && \
  if [ $$(sed -n 's/^TC_ARCH *= *//p' syno-$(1)-$(2)/Makefile | wc -w) -le 1 ] ; then echo $(1) ; else \
    dist=$$(sed -n 's/^TC_DIST *= *//p' syno-$(1)-$(2)/Makefile) ; \
    for tc in syno-*-$(2) ; do \
      [ "$$tc" = "syno-$(1)-$(2)" ] && continue ; \
      [ $$(sed -n 's/^TC_ARCH *= *//p' $$tc/Makefile | wc -w) -eq 1 ] || continue ; \
      [ "$$(sed -n 's/^TC_DIST *= *//p' $$tc/Makefile)" = "$$dist" ] || continue ; \
      tc=$${tc#syno-} ; echo $${tc%-$(2)} ; break ; \
    done ; \
  fi)
endef

# Macro: the toolchain a producer builds an <arch>-<dsm> as
#
#   $(call toolchain_real,x64-7.1)   -> apollolake-7.1
#
# Where the component sets TOOLCHAIN_DIST_SHARED, a generic arch is built as the real arch
# whose toolchain, hence archive, it shares (overlay_dist_arch); otherwise as itself.
define toolchain_real
$(if $(call is_true,$(TOOLCHAIN_DIST_SHARED)),$(call overlay_dist_arch,$(firstword \
  $(subst -, ,$(1))),$(lastword $(subst -, ,$(1))))-$(lastword $(subst -, ,$(1))),$(1))
endef

# Macro: the revision a toolchain archive is published at
#
#   $(call toolchain_published_rev,apollolake,7.1,gcc-8.5)   -> v6
#
# The PKG_REV of the overlay that installs it: the arch's own, or else that of a generic
# arch built as it (overlay_dist_arch) -- x64-7.1 fetches apollolake-7.1's archive, which
# has no overlay of its own. Empty where neither exists.
define toolchain_published_rev
$(strip $(foreach f,$(firstword $(or $(wildcard $(BASEDIR)/overlay/syno-$(1)-$(2)_$(3)/Makefile),\
  $(foreach d,$(wildcard $(BASEDIR)/overlay/syno-*-$(2)_$(3)),$(if $(filter $(1),\
    $(call overlay_dist_arch,$(patsubst syno-%-$(2)_$(3),%,$(notdir $(d))),$(2))),$(d)/Makefile)))),\
  $(call read_makefile_var,$(f),PKG_REV)))
endef

# Macro: the archs a producer builds for a DSM version
#
#   $(call toolchain_archs,7.1)
#
# The archs of that DSM version with an overlay of the component (TOOLCHAIN_CONSUMER, the
# overlay directory suffix), each as the arch it is built as, once.
define toolchain_archs
$(sort $(foreach d,$(wildcard $(BASEDIR)/overlay/syno-*-$(1)_$(TOOLCHAIN_CONSUMER)),\
  $(patsubst %-$(1),%,$(call toolchain_real,$(patsubst syno-%,%,$(firstword $(subst _, ,$(notdir $(d)))))))))
endef
