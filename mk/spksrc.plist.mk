### plist rule
# 
# Variables:
#  PLIST_TRANSFORM    Command to transform PLIST (default: cat)

INSTALL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)plist_done

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM = cat
endif

###
### When processing PLIST entries where we are re-using existing
### shared object from another spk (ex: python* or ffmpeg),
### always check that a $(PKG_NAME).plist exists as it won't
### be created when the shared build environment is being
### populated with symlinks to $(PKG_NAME)*_done
###
.PHONY: cat_PLIST
cat_PLIST:
	@for depend in $(DEPENDS) ; \
	do                          \
	  $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../$$depend cat_PLIST ; \
	done
	@if [ -f PLIST ] && [ -f $(WORK_DIR)/$(PKG_NAME).plist ] ; \
	then \
	  $(PLIST_TRANSFORM) PLIST ; \
	# If there is a PLIST.auto file or if parent directory is kernel \
	elif [ -f PLIST.auto -o $$(basename $$(dirname $(CURDIR))) = "kernel" ] ; \
	then \
	  cat $(WORK_DIR)/$(PKG_NAME).plist | sort | while read -r file ; \
	  do \
	    type=$$(file --brief "$(INSTALL_DIR)/$(INSTALL_PREFIX)/$$file" | cut -d , -f1) ; \
	    case $$type in \
	       ELF*LSB[[:space:]]*executable ) echo "bin:$$file" ;; \
	                            *script* ) echo "rsc:$$file" ;; \
	                                ELF* ) echo "lib:$$file" ;; \
	            symbolic[[:space:]]link* ) echo "lnk:$$file" ;; \
	                                   * ) echo "rsc:$$file" ;; \
	    esac \
	  done \
	else \
	  $(MSG) "No PLIST for $(NAME)" >&2; \
	fi
	@touch -f $(INSTALL_COOKIE)
