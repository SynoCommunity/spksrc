# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME = $(SPK_NAME)

ifneq ($(ARCH),)
ARCH_SUFFIX = -$(ARCH)
TC = syno$(ARCH_SUFFIX)
endif

SPK_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)$(ARCH_SUFFIX)-$(SPK_VERS)-$(SPK_REV).spk

#####

# Even though this makefile doesn't cross compile, we need this to setup the cross environment.
include ../../mk/spksrc.cross-env.mk

include ../../mk/spksrc.depend.mk

copy: depend
include ../../mk/spksrc.copy.mk

strip: copy
include ../../mk/spksrc.strip.mk


### Packaging rules
$(WORK_DIR)/package.tgz: strip
	$(create_target_dir)
	@[ -f $@ ] && rm $@ || true
	(cd $(STAGING_DIR) && tar cpzf $@ *)

$(WORK_DIR)/INFO: Makefile $(SPK_ICON)
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@echo package=\"$(SPK_NAME)\" > $@
	@echo version=\"$(SPK_VERS)-$(SPK_REV)\" >> $@
	@echo description=\"$(DESCRIPTION)\" >> $@
	@echo $(foreach LANGUAGE, $(LANGUAGES), \
		$(shell [ ! -z "$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))" ] && \
		echo description_$(LANGUAGE)=\\\"$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))\\\") \
	) >> $@
	@echo maintainer=\"$(MAINTAINER)\" >> $@
ifneq ($(strip $(ARCH)),)
	@echo arch=\"$(ARCH)\" >> $@
else
	@echo arch=\"noarch\" >> $@
endif
ifneq ($(strip $(FIRMWARE)),)
	@echo firmware=\"$(FIRMWARE)\" >> $@
else
	@echo firmware=\"3.0-1593\" >> $@
endif
ifneq ($(strip $(BETA)),)
	@echo report_url=\"https://github.com/SynoCommunity/spksrc/issues\" >> $@
endif
	@echo reloadui=\"$(RELOAD_UI)\" >> $@
	@echo displayname=\"$(DISPLAY_NAME)\" >> $@
ifneq ($(strip $(DSM_UI_DIR)),)
	@echo dsmuidir=\"$(DSM_UI_DIR)\" >> $@
endif
ifneq ($(strip $(DSM_APP_NAME)),)
	@echo dsmappname=\"$(DSM_APP_NAME)\" >> $@
endif
ifneq ($(strip $(ADMIN_PORT)),)
	@echo adminport=$(ADMIN_PORT) >> $@
endif
ifneq ($(strip $(SPK_DEPENDS)),)
	@echo install_dep_packages=\"$(SPK_DEPENDS)\" >> $@
endif
ifneq ($(strip $(SPK_ICON)),)
	@echo package_icon=\"`convert $(SPK_ICON) -thumbnail 72x72 - | base64 -w0 -`\" >> $@
endif

# Wizard
DSM_WIZARDS_DIR = $(WORK_DIR)/WIZARD_UIFILES

DSM_WIZARDS =
ifneq ($(WIZARDS_DIR),)
DSM_WIZARDS = $(addprefix $(DSM_WIZARDS_DIR)/, $(notdir $(wildcard $(WIZARDS_DIR)/*)))
endif

define dsm_wizard_copy
$(create_target_dir)
$(MSG) "Creating $@"
cp $< $@
chmod 644 $@
endef

$(DSM_WIZARDS_DIR)/%: $(WIZARDS_DIR)/%
	@echo $@
	@$(dsm_wizard_copy)

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
DSM_SCRIPTS_ += $(notdir $(basename $(ADDITIONAL_SCRIPTS)))

DSM_SCRIPTS = $(addprefix $(DSM_SCRIPTS_DIR)/,$(DSM_SCRIPTS_))

define dsm_script_redirect
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/sh' > $@
echo 'PATH=/bin:/usr/bin' >> $@
echo '. `dirname $$0`/installer' >> $@
echo '`basename $$0` > $$SYNOPKG_TEMP_LOGFILE' >> $@
chmod 755 $@
endef

define dsm_script
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/sh' > $@
echo 'PATH=/bin:/usr/bin' >> $@
echo '. `dirname $$0`/installer' >> $@
echo '`basename $$0`' >> $@
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
	@$(dsm_script)
$(DSM_SCRIPTS_DIR)/postuninst:
	@$(dsm_script)
$(DSM_SCRIPTS_DIR)/preupgrade:
	@$(dsm_script_redirect)
$(DSM_SCRIPTS_DIR)/postupgrade:
	@$(dsm_script_redirect)

$(DSM_SCRIPTS_DIR)/start-stop-status: $(SSS_SCRIPT) 
	@$(dsm_script_copy)
$(DSM_SCRIPTS_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(dsm_script_copy)
$(DSM_SCRIPTS_DIR)/%: $(filter %.sh,$(ADDITIONAL_SCRIPTS)) 
	@$(dsm_script_copy)


SPK_CONTENT  = package.tgz INFO scripts
ifneq ($(strip $(DSM_WIZARDS)),)
SPK_CONTENT += WIZARD_UIFILES
endif

$(SPK_FILE_NAME): $(WORK_DIR)/package.tgz $(WORK_DIR)/INFO $(DSM_SCRIPTS) $(DSM_WIZARDS)
	$(create_target_dir)
	(cd $(WORK_DIR) && tar cpf $@ --group=root --owner=root $(SPK_CONTENT))

package: $(SPK_FILE_NAME)

ifneq ($(PUBLISHING_URL),)
ifneq ($(PUBLISHING_KEY),)
publish: package
	curl -k -A "spksrc v1.0; $(PUBLISHING_KEY)" \
	     -F "package=@$(SPK_FILE_NAME);filename=$(notdir $(SPK_FILE_NAME))" \
	     $(PUBLISHING_URL)
else
publish:
	@echo 'Set PUBLISHING_KEY to the publishing key of your Package Server'
	@exit 1
endif
else
publish:
	@echo 'Set PUBLISHING_URL to the URL of your Package Server'
	@exit 1
endif


### Clean rules
clean:
	rm -fr work work-*

all: package


SUPPORTED_TCS = $(notdir $(wildcard ../../toolchains/syno-*))
SUPPORTED_ARCHS = $(notdir $(subst -,/,$(SUPPORTED_TCS)))

.PHONY: all-archs
all-archs: $(addprefix arch-,$(SUPPORTED_ARCHS))

.PHONY: publish-all-archs
publish-all-archs: $(addprefix publish-arch-,$(SUPPORTED_ARCHS))

arch-%:
	@$(MSG) Building package for arch $*
	-@env $(MAKE) ARCH=$*

publish-arch-%:
	@$(MSG) Building and publishing package for arch $*
	-@env $(MAKE) ARCH=$* publish

