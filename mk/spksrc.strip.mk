### Strip rules
#   Strip the binary files (exec and libs) in the staging directory. 
# Targets are executed in the following order:
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

TC_LIBRARY_PATH = $(realpath $(TC_PATH)..)/$(TC_LIBRARY)

.PHONY: strip strip_msg
.PHONY: $(PRE_STRIP_TARGET) $(STRIP_TARGET) $(POST_STRIP_TARGET)

strip_msg:
	@$(MSG) "Stripping binaries and libraries of $(NAME)"

include_libatomic:
	@cat $(INSTALL_PLIST) | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    lib|bin) \
	      if [ "$$(objdump -p $(STAGING_DIR)/$${file} 2>/dev/null | grep NEEDED | grep libatomic\.so)" ]; then \
	        _libatomic_="$$(readlink $(TC_LIBRARY_PATH)/libatomic.so)" ; \
	        echo  "===>  Add libatomic from toolchain ($${_libatomic_})" ; \
	        install -d -m 755 $(STAGING_DIR)/lib ; \
	        install -m 644 $(TC_LIBRARY_PATH)/$${_libatomic_} $(STAGING_DIR)/lib/ ; \
	        cd $(STAGING_DIR)/lib/ && ln -sf $${_libatomic_} libatomic.so.1 ; \
	        cd $(STAGING_DIR)/lib/ && ln -sf $${_libatomic_} libatomic.so ; \
	        break ; \
	      fi \
	    ;; \
	  esac ; \
	done

pre_strip_target: strip_msg

strip_target: $(PRE_STRIP_TARGET) $(INSTALL_PLIST) include_libatomic
	@cat $(INSTALL_PLIST) | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    lib|bin) \
	      echo -n "Stripping $${file}... " ; \
	      chmod u+w $(STAGING_DIR)/$${file} ; \
	      $(STRIP) $(STAGING_DIR)/$${file} > /dev/null 2>&1 && echo "ok" || echo "failed!" \
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
	
