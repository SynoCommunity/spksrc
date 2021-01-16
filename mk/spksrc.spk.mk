# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME = $(SPK_NAME)

ifneq ($(ARCH),)
SPK_ARCH = $(TC_ARCH)
SPK_NAME_ARCH = $(ARCH)
SPK_TCVERS = $(TCVERSION)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
else
SPK_ARCH = noarch
SPK_NAME_ARCH = noarch
SPK_TCVERS = all
OS_MIN_VER = 3.1-1594
FIRMWARE = $(OS_MIN_VER)
endif

SPK_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)_$(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV).spk

#####

include ../../mk/spksrc.pre-check.mk

# Even though this makefile doesn't cross compile, we need this to setup the cross environment.
include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.depend.mk

copy: depend
include ../../mk/spksrc.wheel.mk

copy: wheel
include ../../mk/spksrc.copy.mk

strip: copy
include ../../mk/spksrc.strip.mk


# Scripts
DSM_SCRIPTS_DIR = $(WORK_DIR)/scripts

# Generated scripts
DSM_SCRIPTS_  = preinst postinst
DSM_SCRIPTS_ += preuninst postuninst
DSM_SCRIPTS_ += preupgrade postupgrade

# SPK specific scripts
ifneq ($(strip $(SSS_SCRIPT)),)
DSM_SCRIPTS_ += start-stop-status

$(DSM_SCRIPTS_DIR)/start-stop-status: $(SSS_SCRIPT)
	@$(dsm_script_copy)
endif

ifneq ($(strip $(INSTALLER_SCRIPT)),)
DSM_SCRIPTS_ += installer

$(DSM_SCRIPTS_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(dsm_script_copy)
endif

DSM_SCRIPTS_ += $(notdir $(basename $(ADDITIONAL_SCRIPTS)))

SPK_CONTENT = package.tgz INFO scripts

# conf
DSM_CONF_DIR = $(WORK_DIR)/conf

ifneq ($(CONF_DIR),)
export SPKSRC_CONF_DIR=$(CONF_DIR)
endif

# Generic service scripts
include ../../mk/spksrc.service.mk

icon: strip
ifneq ($(strip $(SPK_ICON)),)
include ../../mk/spksrc.icon.mk
endif

$(WORK_DIR)/INFO:
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@echo package=\"$(SPK_NAME)\" > $@
	@echo version=\"$(SPK_VERS)-$(SPK_REV)\" >> $@
	@/bin/echo -n "description=\"" >> $@
	@/bin/echo -n "${DESCRIPTION}" | sed -e 's/\\//g' -e 's/"/\\"/g' >> $@
	@echo "\"" >> $@
	@echo $(foreach LANGUAGE, $(LANGUAGES), \
          $(shell [ ! -z "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))" ] && \
            /bin/echo -n "description_$(LANGUAGE)=\\\"" && \
            /bin/echo -n "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))"  | sed -e 's/"/\\\\\\"/g' && \
            /bin/echo -n "\\\"\\\n")) | sed -e 's/ description_/description_/g' >> $@
	@echo arch=\"$(SPK_ARCH)\" >> $@
ifneq ($(strip $(MAINTAINER)),)
	@echo maintainer=\"$(MAINTAINER)\" >> $@
else
	$(error Set MAINTAINER in local.mk)
endif
	@echo maintainer_url=\"$(MAINTAINER_URL)\" >> $@
	@echo distributor=\"$(DISTRIBUTOR)\" >> $@
	@echo distributor_url=\"$(DISTRIBUTOR_URL)\" >> $@

ifneq ($(strip $(OS_MIN_VER)),)
	@echo os_min_ver=\"$(OS_MIN_VER)\" >> $@
else
	@echo os_min_ver=\"$(TC_OS_MIN_VER)\" >> $@
endif
ifeq ($(shell expr "$(TC_OS_MIN_VER)" \<= 6.1),1)
ifneq ($(strip $(FIRMWARE)),)
	@echo firmware=\"$(FIRMWARE)\" >> $@
else
	@echo firmware=\"$(TC_OS_MIN_VER)\" >> $@
endif
endif
ifneq ($(strip $(OS_MAX_VER)),)
	@echo os_max_ver=\"$(OS_MAX_VER)\" >> $@
endif
ifneq ($(strip $(BETA)),)
	@echo beta=\"yes\" >> $@
	@echo report_url=\"$(REPORT_URL)\" >> $@
endif
ifneq ($(strip $(HELPURL)),)
	@echo helpurl=\"$(HELPURL)\" >> $@
else
  ifneq ($(strip $(HOMEPAGE)),)
	@echo helpurl=\"$(HOMEPAGE)\" >> $@
  endif
endif
ifneq ($(strip $(SUPPORTURL)),)
	@echo support_url=\"$(SUPPORTURL)\" >> $@
endif
ifneq ($(strip $(INSTALL_DEP_SERVICES)),)
	@echo install_dep_services=\"$(INSTALL_DEP_SERVICES)\" >> $@
endif
ifneq ($(strip $(START_DEP_SERVICES)),)
	@echo start_dep_services=\"$(START_DEP_SERVICES)\" >> $@
endif
ifneq ($(strip $(INSTUNINST_RESTART_SERVICES)),)
	@echo instuninst_restart_services=\"$(INSTUNINST_RESTART_SERVICES)\" >> $@
endif
ifneq ($(strip $(RELOAD_UI)),)
	@echo reloadui=\"$(RELOAD_UI)\" >> $@
endif
ifeq ($(STARTABLE),no)
ifeq ($(shell expr "$(TC_OS_MIN_VER)" \<= 6.1),1)
	@echo startable=\"$(STARTABLE)\" >> $@
endif
	@echo ctl_stop=\"$(STARTABLE)\" >> $@
endif
	@echo displayname=\"$(DISPLAY_NAME)\" >> $@
ifneq ($(strip $(DSM_UI_DIR)),)
	@echo dsmuidir=\"$(DSM_UI_DIR)\" >> $@
endif
ifneq ($(strip $(DSM_APP_NAME)),)
	@echo dsmappname=\"$(DSM_APP_NAME)\" >> $@
else
	@echo dsmappname=\"com.synocommunity.$(SPK_NAME)\" >> $@
endif
ifneq ($(strip $(ADMIN_PROTOCOL)),)
	@echo adminprotocol=\"$(ADMIN_PROTOCOL)\" >> $@
endif
ifneq ($(strip $(ADMIN_PORT)),)
	@echo adminport=\"$(ADMIN_PORT)\" >> $@
endif
ifneq ($(strip $(ADMIN_URL)),)
	@echo adminurl=\"$(ADMIN_URL)\" >> $@
endif
ifneq ($(strip $(CHANGELOG)),)
	@echo changelog=\"$(CHANGELOG)\" >> $@
endif
ifneq ($(strip $(SPK_DEPENDS)),)
	@echo install_dep_packages=\"$(SPK_DEPENDS)\" >> $@
endif
ifneq ($(strip $(CONF_DIR)),)
	@echo support_conf_folder=\"yes\" >> $@
endif
ifneq ($(strip $(SPK_CONFLICT)),)
	@echo install_conflict_packages=\"$(SPK_CONFLICT)\" >> $@
endif
	@echo checksum=\"`md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1`\" >> $@

ifneq ($(strip $(DEBUG)),)
INSTALLER_OUTPUT = >> /root/$${PACKAGE}-$${SYNOPKG_PKG_STATUS}.log 2>&1
else
INSTALLER_OUTPUT = > $$SYNOPKG_TEMP_LOGFILE
endif

# Wizard
DSM_WIZARDS_DIR = $(WORK_DIR)/WIZARD_UIFILES

ifneq ($(WIZARDS_DIR),)
# export working wizards dir to the shell for use later at compile-time
export SPKSRC_WIZARDS_DIR=$(WIZARDS_DIR)
endif

# License
DSM_LICENSE_FILE = $(WORK_DIR)/LICENSE

DSM_LICENSE =
ifneq ($(LICENSE_FILE),)
DSM_LICENSE = $(DSM_LICENSE_FILE)
endif

define dsm_license_copy
$(MSG) "Creating $@"
cp $< $@
chmod 644 $@
endef

$(DSM_LICENSE_FILE): $(LICENSE_FILE)
	@echo $@
	@$(dsm_license_copy)

### Packaging rules
$(WORK_DIR)/package.tgz: icon service
	$(create_target_dir)
	@[ -f $@ ] && rm $@ || true
	(cd $(STAGING_DIR) && tar cpzf $@ --owner=root --group=root *)

DSM_SCRIPTS = $(addprefix $(DSM_SCRIPTS_DIR)/,$(DSM_SCRIPTS_))

define dsm_script_redirect
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/sh' > $@
echo '. `dirname $$0`/installer' >> $@
echo '`basename $$0` $(INSTALLER_OUTPUT)' >> $@
chmod 755 $@
endef

define dsm_script_copy
$(create_target_dir)
$(MSG) "Creating $@"
cp $< $@
chmod 755 $@
endef

$(DSM_SCRIPTS_DIR)/preinst:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/postinst:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/preuninst:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/postuninst:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/preupgrade:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/postupgrade:
	@$(dsm_script_redirect)

$(DSM_SCRIPTS_DIR)/%: $(filter %.sh,$(ADDITIONAL_SCRIPTS))
	@$(dsm_script_copy)

# Package Icons
.PHONY: icons
icons:
ifneq ($(strip $(SPK_ICON)),)
	$(create_target_dir)
	@$(MSG) "Creating PACKAGE_ICON.PNG for $(SPK_NAME)"
	(convert $(SPK_ICON) -thumbnail 72x72 -strip - > $(WORK_DIR)/PACKAGE_ICON.PNG)
	@$(MSG) "Creating PACKAGE_ICON_256.PNG for $(SPK_NAME)"
	(convert $(SPK_ICON) -thumbnail 256x256 -strip - > $(WORK_DIR)/PACKAGE_ICON_256.PNG)
	$(eval SPK_CONTENT +=  PACKAGE_ICON.PNG PACKAGE_ICON_256.PNG)
endif

.PHONY: info-checksum
info-checksum:
	@$(MSG) "Creating checksum for $(SPK_NAME)"
	@sed -i -e "s|checksum=\".*|checksum=\"`md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1`\"|g" $(WORK_DIR)/INFO

.PHONY: wizards
wizards:
ifneq ($(strip $(WIZARDS_DIR)),)
	@$(MSG) "Preparing DSM Wizards"
	@mkdir -p $(DSM_WIZARDS_DIR)
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -and \( -name "install_uifile" -or -name "install_uifile_???" -or -name "install_uifile.sh" -or -name "install_uifile_???.sh" -or -name "upgrade_uifile" -or -name "upgrade_uifile_???" -or -name "upgrade_uifile.sh" -or -name "upgrade_uifile_???.sh" -or -name "uninstall_uifile" -or -name "uninstall_uifile_???" -or -name "uninstall_uifile.sh" -or -name "uninstall_uifile_???.sh" \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
	@find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -not -name "*.sh" -print -exec chmod 0644 {} \;
	@find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -name "*.sh" -print -exec chmod 0755 {} \;
	$(eval SPK_CONTENT += WIZARD_UIFILES)
endif

.PHONY: conf
conf:
ifneq ($(strip $(CONF_DIR)),)
	@$(MSG) "Preparing conf"
	@mkdir -p $(DSM_CONF_DIR)
	@find $${SPKSRC_CONF_DIR} -maxdepth 1 -type f -print -exec cp -f {} $(DSM_CONF_DIR) \;
	@find $(DSM_CONF_DIR) -maxdepth 1 -type f -print -exec chmod 0644 {} \;
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif
endif

ifneq ($(strip $(DSM_LICENSE)),)
SPK_CONTENT += LICENSE
endif

$(SPK_FILE_NAME): $(WORK_DIR)/package.tgz $(WORK_DIR)/INFO info-checksum icons service $(DSM_SCRIPTS) wizards $(DSM_LICENSE) conf
	$(create_target_dir)
	(cd $(WORK_DIR) && tar cpf $@ --group=root --owner=root $(SPK_CONTENT))

package: $(SPK_FILE_NAME)

### Publish rules
publish: package
ifeq ($(PUBLISH_URL),)
	$(error Set PUBLISH_URL in local.mk)
endif
ifeq ($(PUBLISH_API_KEY),)
	$(error Set PUBLISH_API_KEY in local.mk)
endif
	http --verify=no --auth $(PUBLISH_API_KEY): POST $(PUBLISH_URL)/packages @$(SPK_FILE_NAME)


### Clean rules
clean:
	rm -fr work work-*

spkclean:
	rm -fr work-*/.copy_done \
	       work-*/.depend_done \
	       work-*/.icon_done \
	       work-*/.strip_done \
	       work-*/.wheel_done \
	       work-*/conf \
	       work-*/scripts \
	       work-*/staging \
	       work-*/package.tgz \
	       work-*/INFO \
	       work-*/PLIST \
	       work-*/PACKAGE_ICON* \
	       work-*/WIZARD_UIFILES

all: package

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_TOOLCHAINS))

.PHONY: publish-all-archs
publish-all-archs: $(addprefix publish-arch-,$(AVAILABLE_TOOLCHAINS))

####

ifeq (supported,$(subst all-,,$(subst publish-,,$(firstword $(MAKECMDGOALS)))))
ACTION = supported
ALL_ACTION = $(sort $(basename $(subst -,.,$(basename $(subst .,,$(SUPPORTED_ARCHS))))))
else ifeq (latest,$(subst all-,,$(subst publish-,,$(firstword $(MAKECMDGOALS)))))
ACTION = latest
ALL_ACTION = $(sort $(basename $(subst -,.,$(basename $(subst .,,$(DEFAULT_ARCHS))))))
endif

ifeq (publish,$(subst -all-latest,,$(subst -all-supported,,$(firstword $(MAKECMDGOALS)))))
PUBLISH = publish-
.NOTPARALLEL:
endif

KERNEL_REQUIRED = $(MAKE) kernel-required
ifeq ($(strip $(KERNEL_REQUIRED)),)
ALL_ACTION = $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_WITH_KERNEL_SUPPORT))))))
endif

####

.PHONY: publish-all-$(ACTION) all-$(ACTION) pre-build-native

pre-build-native:
	@$(MSG) Pre-build native dependencies for parallel build
	@for depend in $(sort $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS)) ; \
	do \
	  if [ "$${depend%/*}" = "native" ]; then \
	    echo "Pre-processing $${depend}" ; \
	    echo "env $(ENV) $(MAKE) -C ../../$$depend" ; \
	    env $(ENV) $(MAKE) -C ../../$$depend ; \
	  fi ; \
	done
	$(MAKE) $(addprefix $(PUBLISH)$(ACTION)-arch-,$(ALL_ACTION))

$(PUBLISH)all-$(ACTION): | pre-build-native

supported-arch-%:
	@$(MSG) BUILDING package for arch $* with SynoCommunity ${ACTION} toolchain
	-@MAKEFLAGS= PUBLISH=$(PUBLISH) $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(SUPPORTED_ARCHS)))))),$(sort $(filter $*%, $(SUPPORTED_ARCHS)))))))

publish-supported-arch-%:
	@$(MSG) BUILDING and PUBLISHING package for arch $* with SynoCommunity ${ACTION} toolchain
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(SUPPORTED_ARCHS)))))),$(sort $(filter $*%, $(SUPPORTED_ARCHS))))))) publish

latest-arch-%:
	@$(MSG) BUILDING package for arch $* with SynoCommunity ${ACTION} toolchain
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(AVAILABLE_TOOLCHAINS)))))),$(sort $(filter $*%, $(AVAILABLE_TOOLCHAINS)))))))

publish-latest-arch-%:
	@$(MSG) BUILDING and PUBLISHING package for arch $* with SynoCommunity ${ACTION} toolchain
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(AVAILABLE_TOOLCHAINS)))))),$(sort $(filter $*%, $(AVAILABLE_TOOLCHAINS))))))) publish

####

all-legacy:
	$(MAKE) legacy-toolchain-5.2 legacy-toolchain-1.2
	@$(MSG) Built legacy DSM and SRM archs

publish-all-legacy:
	$(MAKE) publish-legacy-toolchain-5.2
	@$(MSG) Published legacy DSM archs

####

legacy-toolchain-%:
	@$(MSG) Built packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(LEGACY_ARCHS))))))) ; \
	do \
	  $(MAKE) arch-$$arch-$* ; \
	done \

publish-legacy-toolchain-%:
	@$(MSG) Built packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(LEGACY_ARCHS))))))) ; \
	do \
	  $(MAKE) publish-arch-$$arch-$* ; \
	done \

####

arch-%:
	@$(MSG) Building package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))

publish-arch-%:
	@$(MSG) Building and publishing package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*))) publish

####

changelog:
	@echo $(shell git log --pretty=format:"- %s" -- $(PWD))

####

### For make kernel-required
include ../../mk/spksrc.kernel-required.mk

####
