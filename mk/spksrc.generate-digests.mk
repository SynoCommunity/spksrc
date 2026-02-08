###############################################################################
# spksrc.generate-digests.mk
#
# Generate digests file for downloaded distribution files.
#
# Targets are executed in the following order:
#  digests
#   ├─ download            (implicit, per architecture if required)
#   └─ digests-<arch>      (per-architecture leaf execution)
#
# Variables:
#  DIGESTS_FILE           : Output file containing checksum entries
#  LOCAL_FILE             : Logical filename recorded in DIGESTS_FILE
#  DIST_FILE              : Downloaded file to checksum
#  PKG_DIST_ARCH_LIST     : Optional list of distribution architectures
#                           (2 or more entries enable multi-arch orchestration)
#  PKG_DIST_ARCH          : Optional current distribution architecture
#                           (single element used during leaf execution)
#
# Notes:
#  - When PKG_DIST_ARCH_LIST is empty or contains a single element, digests are
#    generated directly for the downloaded file.
#  - When PKG_DIST_ARCH_LIST contains 2 or more elements, digests acts as an
#    orchestrator and iterates over each architecture.
#  - Sub-make calls force PKG_DIST_ARCH_LIST to a single element to ensure
#    leaf execution and avoid recursion.
#  - DIGESTS_FILE is generated explicitly and not used as a dependency to
#    prevent circular dependency resolution by make.
#
###############################################################################

# Architecture-specific digest generation.
# This target appends checksum entries for the currently selected architecture
# into the shared DIGESTS_FILE.
.PHONY: digests-%
digests-%:
	@$(MSG) "Generate digests for $(NAME) [$*]"
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $${type} $$($${tool} $(DIST_FILE) | cut -d' ' -f1)" >> $(DIGESTS_FILE) ; \
	done

.PHONY: digests
ifeq ($(filter 0 1,$(words $(PKG_DIST_ARCH_LIST))),)

# Multi-architecture package.
# Iterate over PKG_DIST_ARCH_LIST and invoke download and digest generation
# once per architecture, resetting PKG_DIST_ARCH_LIST to a single value
# for each sub-make invocation.
$(DIGESTS_FILE):
	@rm -f $(DIGESTS_FILE) && touch -f $(DIGESTS_FILE) ; \
	for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  $(MAKE) -s PKG_DIST_ARCH_LIST=$${pkg_arch} PKG_DIST_ARCH=$${pkg_arch} download ; \
	  $(MAKE) -s PKG_DIST_ARCH_LIST=$${pkg_arch} PKG_DIST_ARCH=$${pkg_arch} digests-$${pkg_arch} ; \
	done
else

# Single-architecture package.
# Generate digests directly from the downloaded file without setting
# PKG_DIST_ARCH, producing a single DIGESTS_FILE.
$(DIGESTS_FILE): download
	@$(MSG) "Generate digests for $(NAME)"
	@rm -f $@ && touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $$type $$($$tool $(DIST_FILE) | cut -d' ' -f1)" >> $@ ; \
	done
endif
