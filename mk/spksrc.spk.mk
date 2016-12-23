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
endif

SPK_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)_$(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV).spk

#####

# Check if package supports ARCH
ifneq ($(UNSUPPORTED_ARCHS),)
  ifneq (,$(findstring $(ARCH),$(UNSUPPORTED_ARCHS)))
    @$(error Arch '$(ARCH)' is not a supported architecture )
  endif
endif

# Check minimum DSM requirements of package
ifneq ($(REQUIRED_DSM),)
  ifneq ($(REQUIRED_DSM),$(firstword $(sort $(TCVERSION) $(REQUIRED_DSM))))
    @$(error Toolchain $(TCVERSION) is lower than required version in Makefile $(REQUIRED_DSM) )
  endif
endif

#####

# Even though this makefile doesn't cross compile, we need this to setup the cross environment.
include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.depend.mk

copy: depend
include ../../mk/spksrc.wheel.mk

copy: wheel
include ../../mk/spksrc.copy.mk

strip: copy
include ../../mk/spksrc.strip.mk


### Packaging rules
$(WORK_DIR)/package.tgz: strip
	$(create_target_dir)
	@[ -f $@ ] && rm $@ || true
	(cd $(STAGING_DIR) && tar cpzf $@ --owner=root --group=root *)

$(WORK_DIR)/INFO:
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@echo package=\"$(SPK_NAME)\" > $@
	@echo version=\"$(SPK_VERS)-$(SPK_REV)\" >> $@
	@echo description=\"$(DESCRIPTION)\" >> $@
	@echo $(foreach LANGUAGE, $(LANGUAGES), \
	    $(shell [ ! -z "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))" ] && \
	            echo -n description_$(LANGUAGE)=\\\"$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))\\\" \
	   ) \
	) | sed 's|"\s|"\n|' >> $@
	@echo arch=\"$(SPK_ARCH)\" >> $@
ifneq ($(strip $(MAINTAINER)),)
	@echo maintainer=\"$(MAINTAINER)\" >> $@
else
	$(error Set MAINTAINER in local.mk)
endif
	@echo maintainer_url=\"$(MAINTAINER_URL)\" >> $@
	@echo distributor=\"$(DISTRIBUTOR)\" >> $@
	@echo distributor_url=\"$(DISTRIBUTOR_URL)\" >> $@
ifneq ($(strip $(FIRMWARE)),)
	@echo firmware=\"$(FIRMWARE)\" >> $@
else
  ifneq ($(strip $(TC_FIRMWARE)),)
	@echo firmware=\"$(TC_FIRMWARE)\" >> $@
  else
	@echo firmware=\"3.1-1594\" >> $@
  endif
endif
ifneq ($(strip $(BETA)),)
	@echo report_url=\"$(REPORT_URL)\" >> $@
endif
ifneq ($(strip $(HELPURL)),)
	@echo helpurl=\"$(HELPURL)\" >> $@
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
	@echo reloadui=\"$(RELOAD_UI)\" >> $@
ifneq ($(strip $(STARTABLE)),)
	@echo startable=\"$(STARTABLE)\" >> $@
endif
	@echo displayname=\"$(DISPLAY_NAME)\" >> $@
ifneq ($(strip $(DSM_UI_DIR)),)
	@echo dsmuidir=\"$(DSM_UI_DIR)\" >> $@
endif
ifneq ($(strip $(DSM_APP_NAME)),)
	@echo dsmappname=\"$(DSM_APP_NAME)\" >> $@
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
	@echo checksum=\"`md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1`\" >> $@
ifneq ($(strip $(DEBUG)),)
INSTALLER_OUTPUT = >> /root/$${PACKAGE}-$${SYNOPKG_PKG_STATUS}.log 2>&1
else
INSTALLER_OUTPUT = > $$SYNOPKG_TEMP_LOGFILE
endif
ifneq ($(strip $(SPK_CONFLICT)),)
	@echo install_conflict_packages=\"$(SPK_CONFLICT)\" >> $@
endif

# Wizard
DSM_WIZARDS_DIR = $(WORK_DIR)/WIZARD_UIFILES

ifneq ($(WIZARDS_DIR),)
# export working wizards dir to the shell for use later at compile-time
export SPKSRC_WIZARDS_DIR=$(WIZARDS_DIR)
endif

# conf
DSM_CONF_DIR = $(WORK_DIR)/conf

ifneq ($(CONF_DIR),)
export SPKSRC_CONF_DIR=$(CONF_DIR)
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

# Package Icons
$(WORK_DIR)/PACKAGE_ICON.PNG: $(SPK_ICON)
	$(create_target_dir)
	@$(MSG) "Creating PACKAGE_ICON.PNG for $(SPK_NAME)"
	@[ -f $@ ] && rm $@ || true
	(convert $(SPK_ICON) -thumbnail 72x72 - >> $@)

$(WORK_DIR)/PACKAGE_ICON_120.PNG: $(SPK_ICON)
	$(create_target_dir)
	@$(MSG) "Creating PACKAGE_ICON_120.PNG for $(SPK_NAME)"
	@[ -f $@ ] && rm $@ || true
	(convert $(SPK_ICON) -thumbnail 120x120 - >> $@)

# Scripts
DSM_SCRIPTS_DIR = $(WORK_DIR)/scripts

# Generated scripts
DSM_SCRIPTS_  = preinst postinst
DSM_SCRIPTS_ += preuninst postuninst
DSM_SCRIPTS_ += preupgrade postupgrade
# SPK specific scripts
ifneq ($(strip $(SSS_SCRIPT)),)
DSM_SCRIPTS_ += start-stop-status
endif
DSM_SCRIPTS_ += installer
DSM_SCRIPTS_ += $(notdir $(FWPORTS))
DSM_SCRIPTS_ += $(notdir $(basename $(ADDITIONAL_SCRIPTS)))

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

$(DSM_SCRIPTS_DIR)/start-stop-status: $(SSS_SCRIPT) 
	@$(dsm_script_copy)
$(DSM_SCRIPTS_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(dsm_script_copy)
$(DSM_SCRIPTS_DIR)/%.sc: $(filter %.sc,$(FWPORTS))
	@$(dsm_script_copy)
$(DSM_SCRIPTS_DIR)/%: $(filter %.sh,$(ADDITIONAL_SCRIPTS))
	@$(dsm_script_copy)

SPK_CONTENT = package.tgz INFO PACKAGE_ICON.PNG PACKAGE_ICON_120.PNG scripts

.PHONY: checksum
checksum:
	@$(MSG) "Creating checksum for $(SPK_NAME)"
	@sed -i -e "s|checksum=\".*|checksum=\"`md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1`\"|g" $(WORK_DIR)/INFO

.PHONY: wizards
wizards:
ifneq ($(strip $(WIZARDS_DIR)),)
	@$(MSG) "Preparing DSM Wizards"
	@mkdir -p $(DSM_WIZARDS_DIR)
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
	@find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -print -exec chmod 0644 {} \;
	$(eval SPK_CONTENT += WIZARD_UIFILES)
endif

.PHONY: conf
conf:
ifneq ($(strip $(CONF_DIR)),)
	@$(MSG) "Preparing conf"
	@mkdir -p $(DSM_CONF_DIR)
	@find $${SPKSRC_CONF_DIR} -maxdepth 1 -type f -print -exec cp -f {} $(DSM_CONF_DIR) \;
	@find $(DSM_CONF_DIR) -maxdepth 1 -type f -print -exec chmod 0644 {} \;
	$(eval SPK_CONTENT += conf)
endif

ifneq ($(strip $(DSM_LICENSE)),)
SPK_CONTENT += LICENSE
endif

$(SPK_FILE_NAME): $(WORK_DIR)/package.tgz $(WORK_DIR)/INFO checksum $(WORK_DIR)/PACKAGE_ICON.PNG $(WORK_DIR)/PACKAGE_ICON_120.PNG $(DSM_SCRIPTS) wizards $(DSM_LICENSE) conf
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

all: package

dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME)
	@for depend in $(DEPENDS) ; \
	do \
	  $(MAKE) --no-print-directory -C ../../$$depend dependency-tree ; \
	done

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_ARCHS))

.PHONY: publish-all-archs
publish-all-archs: $(addprefix publish-arch-,$(AVAILABLE_ARCHS))

####

all-supported:
	@$(MSG) Build supported archs
	@if $(MAKE) kernel-required >/dev/null 2>&1 ; then \
	  for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_DUPES)))))) ; \
	  do \
	    $(MAKE) latest-arch-$$arch ; \
	  done \
	else \
	  for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_NO_KRNLSUPP)))))) ; \
	  do \
	    $(MAKE) latest-arch-$$arch ; \
	  done \
	fi

publish-all-supported:
	@$(MSG) Publish supported archs
	@if $(MAKE) kernel-required >/dev/null 2>&1 ; then \
	  for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_DUPES)))))) ; \
	  do \
	    $(MAKE) publish-latest-arch-$$arch ; \
	  done \
	else \
	  for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(ARCHS_NO_KRNLSUPP)))))) ; \
	  do \
	    $(MAKE) publish-latest-arch-$$arch ; \
	  done \
	fi

all-legacy: $(addprefix arch-,$(LEGACY_ARCHS))
	$(MAKE) all-toolchain-4.3
	@$(MSG) Built legacy archs

publish-all-legacy: $(addprefix publish-arch-,$(LEGACY_ARCHS))
	$(MAKE) all-toolchain-4.3
	@$(MSG) Published legacy archs

####

all-archs-latest:
	@$(MSG) Build all archs with latest DSM per FIRMWARE
	@if $(MAKE) kernel-required >/dev/null 2>&1 ; then \
	  $(MSG) Skipping duplicate arches; \
	  for arch in $(sort $(basename $(ARCHS_DUPES))) ; \
	  do \
	    $(MAKE) latest-arch-$$arch ; \
	  done \
	else \
	  $(MSG) Skipping arches without kernelsupport ; \
	  for arch in $(sort $(basename $(ARCHS_NO_KRNLSUPP))) ; \
	  do \
	    $(MAKE) latest-arch-$$arch ; \
	  done \
	fi

publish-all-archs-latest:
	@$(MSG) Publish all archs with latest DSM per FIRMWARE
	@if $(MAKE) kernel-required >/dev/null 2>&1 ; then \
	  $(MSG) Skipping duplicate arches; \
	  for arch in $(sort $(basename $(ARCHS_DUPES))) ; \
	  do \
	    $(MAKE) publish-latest-arch-$$arch ; \
	  done \
	else \
	  $(MSG) Skipping arches without kernelsupport ; \
	  for arch in $(sort $(basename $(ARCHS_NO_KRNLSUPP))) ; \
	  do \
	    $(MAKE) publish-latest-arch-$$arch ; \
	  done \
	fi

####

latest-arch-%:
	@$(MSG) Building package for arch $* with latest available toolchain
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(AVAILABLE_ARCHS)))))),$(sort $(filter $*%, $(AVAILABLE_ARCHS)))))))

publish-latest-arch-%:
	@$(MSG) Building package for arch $* with latest available toolchain
	-@MAKEFLAGS= $(MAKE) ARCH=$(basename $(subst -,.,$*)) TCVERSION=$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $*%, $(AVAILABLE_ARCHS)))))),$(sort $(filter $*%, $(AVAILABLE_ARCHS))))))) publish

####

all-toolchain-%:
	@$(MSG) Built packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(AVAILABLE_ARCHS))))))) ; \
	do \
	  $(MAKE) arch-$$arch-$* ; \
	done \

publish-all-toolchain-%:
	@$(MSG) Built packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(AVAILABLE_ARCHS))))))) ; \
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

.PHONY: kernel-required
kernel-required:
	@if [ -n "$(REQ_KERNEL)" ]; then \
	  exit 1 ; \
	fi
	@for depend in $(DEPENDS) ; do \
	  if $(MAKE) --no-print-directory -C ../../$$depend kernel-required >/dev/null 2>&1 ; then \
	    exit 0 ; \
	  else \
	    exit 1 ; \
	  fi ; \
	done
