# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME = $(SPK_NAME)

ifneq ($(ARCH),)
SPK_ARCH = $(ARCH)
SPK_BASE_ARCH = $(shell echo $(ARCH) | cut -d'-' -f 1 )
NAME_EXT = $(shell echo $(ARCH) | grep "-" | sed "s/.*-/-/" )
ifneq ($(strip $(NAME_EXT)),)
ifneq ($(findstring $(NAME_EXT),-gcc47),)
SPK_DEPENDS += "toolchain-gcc47>4.7.0-1"
else ifneq ($(findstring $(NAME_EXT),-gcc48),)
SPK_DEPENDS += "toolchain-gcc48>4.8.0-1"
endif
endif
ARCH_SUFFIX = -$(ARCH)
TC = syno$(ARCH_SUFFIX)
else
SPK_ARCH = noarch
endif

SPK_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)_$(SPK_ARCH)_$(SPK_VERS)-$(SPK_REV).spk

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
	            echo -n description_$(LANGUAGE)=\\\"$(DESCRIPTION_$(shell echo $(LANGUAGE) | tr [:lower:] [:upper:]))\\\" \
	   ) \
	) | sed 's|"\s|"\n|' >> $@
	@echo maintainer=\"$(MAINTAINER)\" >> $@
	@echo arch=\"$(SPK_BASE_ARCH)\" >> $@
ifneq ($(strip $(FIRMWARE)),)
	@echo firmware=\"$(FIRMWARE)\" >> $@
else
	@echo firmware=\"3.0-1593\" >> $@
endif
ifneq ($(strip $(BETA)),)
	@echo report_url=\"https://github.com/SynoCommunity/spksrc/issues\" >> $@
	@echo beta=1 >> $@
endif
ifneq ($(strip $(HELPURL)),)
	@echo helpurl=\"$(HELPURL)\" >> $@
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
ifneq ($(strip $(SPK_ICON)),)
	@echo package_icon=\"`convert $(SPK_ICON) -thumbnail 72x72 - | base64 -w0 -`\" >> $@
endif
ifneq ($(strip $(DEBUG)),)
INSTALLER_OUTPUT = >> /root/$${PACKAGE}-$${SYNOPKG_PKG_STATUS}.log 2>&1
else
INSTALLER_OUTPUT = > $$SYNOPKG_TEMP_LOGFILE
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

### Publish rules
PUBLISH_METHOD ?= REPO
ifeq ($(strip $(PUBLISH_METHOD)),REPO)
publish: package
ifeq ($(PUBLISH_REPO_URL),)
	$(error Set PUBLISH_REPO_URL in local.mk)
endif
ifeq ($(PUBLISH_REPO_KEY),)
	$(error Set PUBLISH_REPO_KEY in local.mk)
endif
	curl -k -A "spksrc v1.0; $(PUBLISH_REPO_KEY)" \
	     -F "package=@$(SPK_FILE_NAME);filename=$(notdir $(SPK_FILE_NAME))" \
	     $(PUBLISH_REPO_URL)
endif
ifeq ($(strip $(PUBLISH_METHOD)),FTP)
publish: package
ifeq ($(PUBLISH_FTP_URL),)
	$(error Set PUBLISH_FTP_URL in local.mk)
endif
ifeq ($(PUBLISH_FTP_USER),)
	$(error Set PUBLISH_FTP_USER in local.mk)
endif
ifeq ($(PUBLISH_FTP_PASSWORD),)
	$(error Set PUBLISH_FTP_PASSWORD in local.mk)
endif
	curl -T "$(SPK_FILE_NAME)" -u $(PUBLISH_FTP_USER):$(PUBLISH_FTP_PASSWORD) $(PUBLISH_FTP_URL)/$(notdir $(SPK_FILE_NAME))
endif


### Clean rules
clean:
	rm -fr work work-*

all: package


SUPPORTED_TCS = $(notdir $(wildcard ../../toolchains/syno-*))
SUPPORTED_ARCHS = $(notdir $(subst -,/,$(SUPPORTED_TCS)))

dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME)
	@for depend in $(DEPENDS) ; \
	do \
	  $(MAKE) --no-print-directory -C ../../$$depend dependency-tree ; \
	done

.PHONY: all-archs
all-archs: $(addprefix arch-,$(SUPPORTED_ARCHS))

.PHONY: publish-all-archs
publish-all-archs: $(addprefix publish-arch-,$(SUPPORTED_ARCHS))

arch-%:
	@$(MSG) Building package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$*

publish-arch-%:
	@$(MSG) Building and publishing package for arch $*
	-@MAKEFLAGS= $(MAKE) ARCH=$* publish

changelog:
	@echo $(shell git log --pretty=format:"- %s" -- $(PWD))
