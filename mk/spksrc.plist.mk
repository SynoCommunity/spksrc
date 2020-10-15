### plist rule
# 
# Variables:
#  PLIST_TRANSFORM    Command to transform PLIST (default: cat)

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM= cat
endif

.PHONY: cat_PLIST
cat_PLIST:
	@echo Processing PLIST dependencies 1>&2
	@for depend in `$(MAKE) dependency-list` ; \
	do                          \
	  if [ "$${depend%/*}" = "cross" ] && [ -s ../../$${depend}/PLIST ]; then \
	    echo "$${depend}" 1>&2 ; \
	    cat ../../$${depend}/PLIST 1>&2 ; \
	    $(PLIST_TRANSFORM) ../../$${depend}/PLIST ; \
	  fi ; \
	done ; \
	$(PLIST_TRANSFORM) $(WORK_DIR)/../PLIST
