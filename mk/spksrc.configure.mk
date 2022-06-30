### Configure rules
#   Run the GNU configure script or any similar configure tool. 
# Targets are executed in the following order:
#  configure_msg_target
#  pre_configure_target    (override with PRE_CONFIGURE_TARGET)
#  configure_target        (override with CONFIGURE_TARGET)
#  post_configure_target   (override with POST_CONFIGURE_TARGET)
# Variables:
#  GNU_CONFIGURE           If set, configure is assumed to be an autoconf generated script
#                          which accepts --host=, --build, and --prefix= options.
#  TC_CONFIGURE_ARGS       --host/--build pair to pass to configure.
#  INSTALL_PREFIX          Directory for the --prefix option of configure.
#  INSTALL_DIR             Where the install (at build time) will be done. INSTALL_PREFIX
#                          will be added. 

CONFIGURE_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)configure_done

ifeq ($(strip $(PRE_CONFIGURE_TARGET)),)
PRE_CONFIGURE_TARGET = pre_configure_target
else
$(PRE_CONFIGURE_TARGET): configure_msg
endif
ifeq ($(strip $(CONFIGURE_TARGET)),)
CONFIGURE_TARGET = configure_target
else
$(CONFIGURE_TARGET): $(PRE_CONFIGURE_TARGET)
endif
ifeq ($(strip $(POST_CONFIGURE_TARGET)),)
POST_CONFIGURE_TARGET = post_configure_target
else
$(POST_CONFIGURE_TARGET): $(CONFIGURE_TARGET)
endif

.PHONY: configure configure_msg
.PHONY: $(PRE_CONFIGURE_TARGET) $(CONFIGURE_TARGET) $(POST_CONFIGURE_TARGET)

REAL_CONFIGURE_ARGS  =
ifneq ($(strip $(GNU_CONFIGURE)),)
REAL_CONFIGURE_ARGS += $(TC_CONFIGURE_ARGS)
REAL_CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX)
# DSM7 appdir
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
REAL_CONFIGURE_ARGS += --localstatedir=$(INSTALL_PREFIX_VAR)
endif
endif
REAL_CONFIGURE_ARGS += $(CONFIGURE_ARGS)

configure_msg:
	@$(MSG) "Configuring for $(NAME)"
	@$(MSG)     - Configure ARGS: $(CONFIGURE_ARGS)
	@$(MSG)     - Install prefix: $(INSTALL_PREFIX)
	@$(MSG)     - Install prefix [var]:  $(INSTALL_PREFIX_VAR)

pre_configure_target: configure_msg

configure_target:  $(PRE_CONFIGURE_TARGET)
	$(RUN) ./configure $(REAL_CONFIGURE_ARGS)

post_configure_target: $(CONFIGURE_TARGET)

ifeq ($(wildcard $(CONFIGURE_COOKIE)),)
configure: $(CONFIGURE_COOKIE)

$(CONFIGURE_COOKIE): $(POST_CONFIGURE_TARGET)
	$(create_target_dir)
	@touch -f $@
else
configure: ;
endif

