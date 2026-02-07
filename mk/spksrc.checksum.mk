###############################################################################
# spksrc.checksum.mk
#
# Verify checksums of downloaded distribution files.
#
# Targets are executed in the following order:
#  checksum_msg
#  pre_checksum_target    (override with PRE_CHECKSUM_TARGET)
#  checksum_target        (override with CHECKSUM_TARGET)
#  post_checksum_target   (override with POST_CHECKSUM_TARGET)
#
# Variables:
#  LOCAL_FILE             : Name of the downloaded file to verify
#  DIGESTS_FILE           : File containing checksum entries
#  PKG_DIST_ARCH_LIST     : Optional list of distribution architectures
#                           (2 or more entries enable multi-arch orchestration)
#  PKG_DIST_ARCH          : Optional current distribution architecture
#                           (single element used during leaf execution)
#
# Files:
#  $(WORK_DIR)/.$(COOKIE_PREFIX)checksum_done
#                           Generic checksum completion cookie
#                           (used when PKG_DIST_ARCH is unset)
#  $(WORK_DIR)/.$(COOKIE_PREFIX)<arch>-checksum_done
#                           Architecture-specific checksum completion cookie
#                           (used when PKG_DIST_ARCH is set)
#  $(DIGESTS_FILE)        : List of filename, checksum type and checksum value
#
# Notes:
#  - The checksum target is idempotent and guarded by a completion cookie.
#  - When PKG_DIST_ARCH is unset, a single generic cookie is used, preserving
#    the classic single-archive behavior.
#  - When PKG_DIST_ARCH is set, the cookie is architecture-specific, allowing
#    checksum verification to be tracked independently per architecture.
#  - When PKG_DIST_ARCH_LIST contains 2 or more elements, checksum acts as an
#    orchestrator and invokes sub-make executions per architecture.
#  - Sub-make calls force PKG_DIST_ARCH_LIST to a single element to ensure
#    leaf execution and avoid recursive orchestration.
#
###############################################################################

DIGESTS_FILE = digests

ifneq ($(strip $(PKG_DIST_ARCH)),)
CHECKSUM_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)$(PKG_DIST_ARCH)-checksum_done
else
CHECKSUM_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)checksum_done
endif

ifeq ($(strip $(PRE_CHECKSUM_TARGET)),)
PRE_CHECKSUM_TARGET = pre_checksum_target
else
$(PRE_CHECKSUM_TARGET): checksum_msg
endif
ifeq ($(strip $(CHECKSUM_TARGET)),)
CHECKSUM_TARGET = checksum_target
else
$(CHECKSUM_TARGET): $(PRE_CHECKSUM_TARGET)
endif
ifeq ($(strip $(POST_CHECKSUM_TARGET)),)
POST_CHECKSUM_TARGET = post_checksum_target
else
$(POST_CHECKSUM_TARGET): $(CHECKSUM_TARGET)
endif

.PHONY: checksum checksum_msg
.PHONY: $(PRE_CHECKSUM_TARGET) $(CHECKSUM_TARGET) $(POST_CHECKSUM_TARGET)

checksum_msg:
ifneq ($(strip $(PKG_DIST_ARCH)),)
	@$(MSG) "Verifying files for $(NAME) [$(PKG_DIST_ARCH)]"
else
	@$(MSG) "Verifying files for $(NAME)"
endif

pre_checksum_target: checksum_msg

# validate file integrity with the provided digests.
checksum_target: $(PRE_CHECKSUM_TARGET)
	@if [ ! -f $(DIGESTS_FILE) ] ; then \
	  $(MSG) "No digests file for $(NAME)" ; \
	  exit 1 ; \
	else \
	  # validate file in digests \
	  if [ $$(cat $(DIGESTS_FILE) | grep -c $(LOCAL_FILE) || true) -eq 0 ]; then \
	     $(MSG) "  Downloaded file $(LOCAL_FILE) is not in digests file" ; \
	     exit 1 ; \
	  # validate checksum entries in digests \
	  elif [ $$(cat $(DIGESTS_FILE) | sed '/MD5/{/SHA1/{/SHA256/p;};}' | grep -c $(LOCAL_FILE)) -lt 3 ]; then \
	     $(MSG) "  Downloaded file $(LOCAL_FILE) has less than 3 checksum entries. Please update the digests file" ; \
	     exit 1 ; \
	  # validated, proceed \
	  else \
	    cat $(DIGESTS_FILE) | grep $(LOCAL_FILE) | ( \
	      cd $(DISTRIB_DIR) ; \
	      while read file type value ; \
	      do \
	        if [ ! -f $$file ] ; then \
	          $(MSG) "  File $$file not downloaded" ; \
	          rm $(DOWNLOAD_COOKIE) ; \
	          exit 1 ; \
	        fi ; \
	        case $$type in \
	          SHA1|sha1)     tool=sha1sum ;; \
	          SHA256|sha256) tool=sha256sum ;; \
	          MD5|md5)       tool=md5sum ;; \
	          *) $(MSG) "Unsupported digest type $$type" ; exit 1 ;; \
	        esac ; \
	        $(MSG) "  Checking $$tool of file $$file"; \
	        if echo "$$value $$file" | $$tool --status -c - ; then \
	          true; \
	        else  \
	          $(MSG) "    Wrong $$tool for file $$file" ; \
	          [ -f $$file.wrong ] && rm $$file.wrong ; \
	          mv $$file $$file.wrong ; \
	          $(MSG) "    Renamed as $$file.wrong" ; \
	          rm $(DOWNLOAD_COOKIE) ; \
	          $(MSG) "    Download cookie removed to trigger the download again" ; \
	          exit 1 ; \
	        fi ; \
	      done ; \
	    ) ; \
	  fi ; \
	fi

# Multi-arch orchestration:
# - words(PKG_DIST_ARCH_LIST) >= 2 → iterate over architectures
# - words(PKG_DIST_ARCH_LIST) <= 1 → single execution
ifeq ($(filter 0 1,$(words $(PKG_DIST_ARCH_LIST))),)
post_checksum_target:
	@for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  rm -f $(CHECKSUM_COOKIE) ; \
	  $(MAKE) -s \
	    PKG_DIST_ARCH_LIST=$${pkg_arch} \
	    PKG_DIST_ARCH=$${pkg_arch} \
	    checksum ; \
	done ;
else
post_checksum_target: $(CHECKSUM_TARGET)
endif

ifeq ($(wildcard $(CHECKSUM_COOKIE)),)
checksum: $(CHECKSUM_COOKIE)

$(CHECKSUM_COOKIE): $(POST_CHECKSUM_TARGET)
	$(create_target_dir)
	@touch -f $@
else
checksum: ;
endif
