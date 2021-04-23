### Checksum rules
#   Validate the downloaded files with sha256 or similar.
# Target are executed in the following order:
#  checksum_msg_target
#  pre_checksum_target   (override with PRE_CHECKSUM_TARGET)
#  checksum_target       (override with CHECKSUM_TARGET)
#  post_checksum_target  (override with POST_CHECKSUM_TARGET)
# Variables:
#  LOCAL_FILE            name of file to check 
# Files:
#  digests               File with filename, hash-type and checksum values

DIGESTS_FILE = digests
CHECKSUM_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)checksum_done

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
	@$(MSG) "Verifying files for $(NAME)"

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

	@echo $(DIST_FILE)

post_checksum_target: $(CHECKSUM_TARGET) 

ifeq ($(wildcard $(CHECKSUM_COOKIE)),)
checksum: $(CHECKSUM_COOKIE)

$(CHECKSUM_COOKIE): $(POST_CHECKSUM_TARGET)
	$(create_target_dir)
	@touch -f $@
else
checksum: ;
endif

