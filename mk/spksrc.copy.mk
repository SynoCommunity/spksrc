### Copy rules
#   Copy files from the installation directory to the staging directory,
#   ready to be packed.
# Target are executed in the following order:
#  copy_msg_target
#  pre_copy_target   (override with PRE_COPY_TARGET)
#  copy_target       (override with COPY_TARGET)
#  post_copy_target  (override with POST_COPY_TARGET)
# Variables:
#  STAGING_DIR:      Files will be copied in this directory
#  DEPENDS:          List of dependencies, used to build $(WORK_DIR)/PLIST 
# Files:
#  $(WORK_DIR)/PLIST List of files to copy to the staging directory

INSTALL_PLIST = $(WORK_DIR)/PLIST

COPY_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)copy_done

ifeq ($(strip $(PRE_COPY_TARGET)),)
PRE_COPY_TARGET = pre_copy_target
else
$(PRE_COPY_TARGET): copy_msg
endif
ifeq ($(strip $(COPY_TARGET)),)
COPY_TARGET = copy_target
else
$(COPY_TARGET): $(PRE_COPY_TARGET)
endif
ifeq ($(strip $(POST_COPY_TARGET)),)
POST_COPY_TARGET = post_copy_target
else
$(POST_COPY_TARGET): $(COPY_TARGET)
endif

.PHONY: copy copy_msg
.PHONY: $(PRE_COPY_TARGET) $(COPY_TARGET) $(POST_COPY_TARGET)

copy_msg:
	@$(MSG) "Creating target installation dir of $(NAME)"
	@rm -fr $(STAGING_DIR)
	@mkdir $(STAGING_DIR)

pre_copy_target: copy_msg

copy_target: $(PRE_COPY_TARGET) $(INSTALL_PLIST)
	(cd $(INSTALL_DIR)/$(INSTALL_PREFIX) && tar cpf - `cat $(INSTALL_PLIST) | cut -d':' -f2`) | \
	  tar xpf - -C $(STAGING_DIR)

post_copy_target: $(COPY_TARGET)

ifeq ($(wildcard $(COPY_COOKIE)),)
copy: $(COPY_COOKIE)

$(COPY_COOKIE): $(POST_COPY_TARGET)
	$(create_target_dir)
	@touch -f $@
else
copy: ;
endif

ifeq ($(strip $(PLIST_TRANSFORM)),)
PLIST_TRANSFORM= cat
endif

$(INSTALL_PLIST):
	@(\
	  for depend in $(DEPENDS) ; \
	  do                          \
	    $(MAKE) WORK_DIR=$(WORK_DIR) --no-print-directory -C ../../$${depend} cat_PLIST ; \
	  done ; \
	  if [ -f PLIST ] ; \
	  then \
	    cat PLIST ; \
	  else \
	    $(MSG) "No PLIST for $(NAME)" >&2; \
	  fi \
	) | $(PLIST_TRANSFORM) | sort -u > $@

