### plist rule
# 
# Variables:
#  PLIST_TRANSFORM    Command to transform PLIST (default: cat)

INSTALL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)plist_done

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM = cat
endif

.PHONY: cat_PLIST
cat_PLIST:
	@for depend in $(DEPENDS) ; \
	do                          \
	  $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../$$depend cat_PLIST ; \
	done
	@if [ -f PLIST ] ; \
	then \
	  $(PLIST_TRANSFORM) PLIST ; \
	# If there is a PLIST.auto file or if parent directory is kernel \
	elif [ -f PLIST.auto -o $$(basename $$(dirname $$(pwd))) = "kernel" ] ; \
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
