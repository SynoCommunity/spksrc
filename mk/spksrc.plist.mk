### plist rule
# 
# Variables:
#  PLIST_TRANSFORM    Command to transform PLIST (default: cat)

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM= cat
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
	elif [ -f PLIST.auto ] ; \
	then \
	  for file in $$(cat $(WORK_DIR)/$(PKG_NAME).plist | sort) ; \
	  do \
	    type=$$(file -F, $(INSTALL_DIR)/$(INSTALL_PREFIX)/$$file | awk -F',[[:blank:]]' '{print $$2}') ; \
	    case $$type in \
	       ELF*LSB[[:space:]]executable ) echo "bin:$$file" ;; \
	                               ELF* ) echo "lib:$$file" ;; \
	           symbolic[[:space:]]link* ) echo "lnk:$$file" ;; \
	                                  * ) echo "rsc:$$file" ;; \
	    esac \
	  done \
	else \
	  $(MSG) "No PLIST for $(NAME)" >&2; \
	fi

