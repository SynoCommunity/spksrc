### Striop rules
#   Strip the binary files (exec and libs) in the staging directory. 
# Target are executed in the following order:
#  strip_msg_target
#  pre_strip_target   (override with PRE_STRIP_TARGET)
#  strip_target       (override with STRIP_TARGET)
#  post_strip_target  (override with POST_STRIP_TARGET)
# Variables:
#  TC                 If set, TC_ENV will be parsed to find the strip utility.
#  TC_ENV             List of variables defining the build environment.
#  STAGING_DIR        Directory where the strip files.
# Files
#  $(INSTALL_PLIST)  Pair of type:filepath, type can be bin, lib, lnk, or rsc. Only bin and lib
#                    files will be stripped. 

ifeq ($(TC),)
STRIP=strip
else
STRIP=$(patsubst STRIP=%,%,$(filter STRIP=%,$(TC_ENV)))
endif

STRIP_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)strip_done

ifeq ($(strip $(PRE_STRIP_TARGET)),)
PRE_STRIP_TARGET = pre_strip_target
else
$(PRE_STRIP_TARGET): strip_msg
endif
ifeq ($(strip $(STRIP_TARGET)),)
STRIP_TARGET = strip_target
else
$(STRIP_TARGET): $(PRE_STRIP_TARGET)
endif
ifeq ($(strip $(POST_STRIP_TARGET)),)
POST_STRIP_TARGET = post_strip_target
else
$(POST_STRIP_TARGET): $(STRIP_TARGET)
endif

.PHONY: strip strip_msg
.PHONY: $(PRE_STRIP_TARGET) $(STRIP_TARGET) $(POST_STRIP_TARGET)

strip_msg:
	@$(MSG) "Striping binaries and libraries of $(NAME)"

pre_strip_target: strip_msg

strip_target: $(PRE_STRIP_TARGET) $(INSTALL_PLIST)
	@cat $(INSTALL_PLIST) | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    lib|bin) \
	      echo "Stripping $${file}" ; \
	      chmod u+w $(STAGING_DIR)/$${file} ; \
	      $(STRIP) $(STAGING_DIR)/$${file} \
	      ;; \
	  esac ; \
	done

post_strip_target: $(STRIP_TARGET)

ifeq ($(wildcard $(STRIP_COOKIE)),)
strip: $(STRIP_COOKIE)

$(STRIP_COOKIE): $(POST_STRIP_TARGET)
	$(create_target_dir)
	@touch -f $@
else
strip: ;
endif
	