# general rule for "make digests"
# 
# include this file after the rule "all:"
#

ifeq ($(strip $(PKG_DIST_ARCH_LIST)),)

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

# download different files for multiple PKG_DIST_ARCH and add digests for all of them

digests-%:
	$(MSG) "Add digests for PKG_DIST_ARCH = $*"
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $${type} $$($${tool} $(DIST_FILE) | cut -d' ' -f1)" >> $(DIGESTS_FILE) ; \
	done


ifeq ($(strip $(PKG_DIST_SITE_LIST)),)

# download with individual dist archs
$(DIGESTS_FILE): download
	@for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  rm $(DOWNLOAD_COOKIE) ; \
	  $(MAKE) -s PKG_DIST_ARCH=$${pkg_arch} download ; \
	done ; \
	rm -f $(DIGESTS_FILE) && touch -f $(DIGESTS_FILE) ; \
	for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  $(MAKE) -s PKG_DIST_ARCH=$${pkg_arch} digests-$${pkg_arch} ; \
	done ; \

else

# download with individual dist sites
$(DIGESTS_FILE): download
	@for pkg_dist_url in $(PKG_DIST_SITE_LIST); do \
	  rm $(DOWNLOAD_COOKIE) ; \
	  $(MAKE) -s URLS=$${pkg_dist_url} download ; \
	done ; \
	rm -f $(DIGESTS_FILE) && touch -f $(DIGESTS_FILE) ; \
	for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  $(MAKE) -s PKG_DIST_ARCH=$${pkg_arch} digests-$${pkg_arch} ; \
	done ; \

endif

endif
