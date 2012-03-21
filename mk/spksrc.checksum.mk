### Checksum rules
#   Validate the downloaded files with sha256 or similar.
# Target are executed in the following order:
#  checksum_msg_target
#  pre_checksum_target   (override with PRE_CHECKSUM_TARGET)
#  checksum_target       (override with CHECKSUM_TARGET)
#  post_checksum_target  (override with POST_CHECKSUM_TARGET)
# Variables:
#  DIST_FILE             List of file to check. TODO
# Files:
#  Checksums             File wich type, checksum values and file name

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

# TODO: do something with sha256sum to check the file integrity.
checksum_target: $(PRE_CHECKSUM_TARGET)
	@if [ -f $(DIGESTS_FILE) ] ; \
	then \
	  cat $(DIGESTS_FILE) | (cd $(DISTRIB_DIR) && while read file type value ; \
	  do \
	    if [ ! -f $$file ] ; \
	    then \
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
	    if echo "$$value  $$file" | $$tool --status -c - ; \
	    then \
	      true ; \
	    else  \
	      $(MSG) "    Wrong $$tool for file $$file" ; \
	      [ -f $$file.wrong ] && rm $$file.wrong ; \
	      mv $$file $$file.wrong ; \
	      $(MSG) "    Renamed as $$file.wrong" ; \
	      rm $(DOWNLOAD_COOKIE) ; \
	      $(MSG) "    Download cookie removed to trigger the download again" ; \
	      exit 1 ; \
	    fi \
	  done) ; \
	else \
	  $(MSG) "No digests file for $(NAME)" ; \
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

