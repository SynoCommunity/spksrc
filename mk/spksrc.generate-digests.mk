###############################################################################
# spksrc.generate-digests.mk
#
# Generate digests file for downloaded distribution files.
#
# This makefile is responsible for:
#  - computing SHA1, SHA256, and MD5 checksums for downloaded files
#  - supporting multi-architecture packages via PKG_DIST_ARCH_LIST
#  - supporting multi-site packages via PKG_DIST_SITE_LIST
#
# Include this file after the rule "all:"
#
###############################################################################

ifeq ($(strip $(PKG_DIST_ARCH_LIST)),)

# Single architecture: generate digests for the one downloaded file
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

else

# Multi-architecture: generate digests for each arch-specific file

digests-%:
	@$(MSG) "Add digests for PKG_DIST_ARCH = $*"
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $${type} $$($${tool} $(DIST_FILE) | cut -d' ' -f1)" >> $(DIGESTS_FILE) ; \
	done

# The download target now auto-orchestrates for multi-arch packages,
# so we just need to iterate for digest generation.
$(DIGESTS_FILE): download
	@rm -f $(DIGESTS_FILE) && touch -f $(DIGESTS_FILE)
	@for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  $(MAKE) -s PKG_DIST_ARCH=$${pkg_arch} digests-$${pkg_arch} ; \
	done

endif
