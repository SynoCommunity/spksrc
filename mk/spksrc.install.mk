### Install rules
#   Install the freshly compiled software, and correct the pkg_config files.
#   This installation will be used to configure and compile other pieces of softwares. This is
#   not the target directory, theses files are copied in the stating directory.
# Target are executed in the following order:
#  install_msg_target
#  $(PRE_INSTALL_PLIST)
#  pre_install_target              (override with PRE_INSTALL_TARGET)
#  install_destdir_target          (default override with INSTALL_TARGET)
#  install_target                  (alternative for INSTALL_TARGET)
#  post_install_target             (override with POST_INSTALL_TARGET)
#  $(INSTALL_PLIST)
#  install_correct_lib_files
# Variables:
#  INSTALL_PREFIX          Target directory where the software will be run.
#  INSTALL_DIR             Where to install files. INSTALL_PREFIX will be added.
#  STAGING_INSTALL_PREFIX  Where to install files, in extenso.
# Files:
#  $(WORK_DIR)/$(PKG_NAME).plist   List of files installed. Can be used to build the PLIST file
#                                  of each software.

INSTALL_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)install_done

INSTALL_PLIST = $(WORK_DIR)/$(PKG_NAME).plist
PRE_INSTALL_PLIST = $(INSTALL_PLIST).tmp

$(PRE_INSTALL_PLIST): install_msg_target
ifeq ($(strip $(PRE_INSTALL_TARGET)),)
PRE_INSTALL_TARGET = pre_install_target
else
$(PRE_INSTALL_TARGET): $(PRE_INSTALL_PLIST)
endif
ifeq ($(strip $(INSTALL_TARGET)),)
INSTALL_TARGET = install_destdir_target
else
$(INSTALL_TARGET): $(PRE_INSTALL_TARGET)
endif
ifeq ($(strip $(POST_INSTALL_TARGET)),)
POST_INSTALL_TARGET = post_install_target
else
$(POST_INSTALL_TARGET): $(INSTALL_TARGET)
endif
$(INSTALL_PLIST): $(POST_INSTALL_TARGET)

install_msg_target:
	@$(MSG) "Installing for $(NAME)"

$(PRE_INSTALL_PLIST):
	$(create_target_dir)
	@mkdir -p $(INSTALL_DIR)/$(INSTALL_PREFIX)
	find $(INSTALL_DIR)/$(INSTALL_PREFIX)/ \! -type d -printf '%P\n' | sort > $@

pre_install_target: install_msg_target $(PRE_INSTALL_PLIST)

install_target: $(PRE_INSTALL_TARGET)
	$(RUN) $(MAKE) install prefix=$(INSTALL_PREFIX)

install_destdir_target: $(PRE_INSTALL_TARGET)
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install prefix=$(INSTALL_PREFIX)

post_install_target: $(INSTALL_TARGET)

$(INSTALL_PLIST):
	find $(INSTALL_DIR)/$(INSTALL_PREFIX)/ \! -type d -printf '%P\n' | sort | \
	  diff $(PRE_INSTALL_PLIST) -  | grep '>' | cut -d' ' -f2- > $@

install_correct_lib_files: $(INSTALL_PLIST)
	@for pc_file in `grep -e "^lib/pkgconfig/.*\.pc$$" $(INSTALL_PLIST)` ; \
	do \
	  $(MSG) "Correcting pkg-config file $${pc_file}" ; \
	  sed -i -e 's#=\($(INSTALL_PREFIX)\)#=$(INSTALL_DIR)\1#g' \
	         -e 's#-rpath,\([^ ,]*\)#-rpath,\1,-rpath-link,$(INSTALL_DIR)\1#g' \
	         -e 's#$$(libdir)#$${libdir}#g' $(INSTALL_DIR)/$(INSTALL_PREFIX)/$${pc_file} ; \
	done
	@for la_file in `grep -e "^lib/.*\.la$$" $(INSTALL_PLIST)` ; \
	do \
	  $(MSG) "Correcting libtool file $${la_file}" ; \
	  perl -p -i -e 's#(?<!\Q$(INSTALL_DIR)\E/)$(INSTALL_PREFIX)#$(INSTALL_DIR)/$(INSTALL_PREFIX)#g' $(INSTALL_DIR)/$(INSTALL_PREFIX)/$${la_file} ; \
	done

ifeq ($(wildcard $(INSTALL_COOKIE)),)
install: $(INSTALL_COOKIE)

$(INSTALL_COOKIE): install_correct_lib_files
	$(create_target_dir)
	@touch -f $@
else
install: ;
endif
