# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

SHELL = /bin/bash

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

# TODO: clean up
# EX4
#WD_MODEL = Lightni
#WD_MODEL_CODE = 00
# MyCloudEX2Ultra, MirrorGen2
#WD_MODEL = GrandTe
#WD_MODEL_CODE = 01
# EX2, Mirror
#WD_MODEL = KingsCa
#WD_MODEL_CODE = 01
# MyCloud
#WD_MODEL = Glacier
#WD_MODEL_CODE = 02
# EX4100
#WD_MODEL = Yellow
#WD_MODEL_CODE = 03
# EX2100
#WD_MODEL = Yosemit
#WD_MODEL_CODE = 04

# Build for PR4100 by default
ifeq ($(WD_MODEL),)
	WD_MODEL = BlackCy
endif
ifeq ($(WD_MODEL_CODE),)
	WD_MODEL_CODE = 07
endif

SPK_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)_$(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV).spk
WD_FILE_NAME = $(PACKAGES_DIR)/$(SPK_NAME)_$(WD_MODEL)_$(SPK_NAME_ARCH)_$(SPK_VERS)-$(SPK_REV).bin
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


# Scripts
DSM_SCRIPTS_DIR = $(WORK_DIR)/scripts
WD_SCRIPTS_DIR = $(WORK_DIR)

# Generated scripts
DSM_SCRIPTS_  = preinst postinst
DSM_SCRIPTS_ += preuninst postuninst
DSM_SCRIPTS_ += preupgrade postupgrade

# WD specific scripts
WD_SCRIPTS_ = install.sh preinst.sh remove.sh
WD_SCRIPTS_ += init.sh clean.sh
WD_SCRIPTS_ += start.sh stop.sh
WD_SCRIPTS_ += apkg.rc

# SPK specific scripts
ifneq ($(strip $(SSS_SCRIPT)),)
DSM_SCRIPTS_ += start-stop-status

$(DSM_SCRIPTS_DIR)/start-stop-status: $(SSS_SCRIPT)
	@$(dsm_script_copy)
endif

#WD_SCRIPTS_ += wdinstaller
# enforce the presence of a WD installer script
#$(WD_SCRIPTS_DIR)/wdinstaller: $(WD_INSTALLER_SCRIPT)
#    @$(dsm_script_copy)

ifneq ($(strip $(INSTALLER_SCRIPT)),)
DSM_SCRIPTS_ += installer

$(DSM_SCRIPTS_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(dsm_script_copy)
endif

DSM_SCRIPTS_ += $(notdir $(basename $(ADDITIONAL_SCRIPTS)))

SPK_CONTENT = package.tgz INFO scripts
SPK_CONTENT += $(WD_SCRIPTS_)

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

WD_DEPENDS = $(foreach dep,$(subst :, ,$(patsubst "%",%,$(SPK_DEPENDS))),$(firstword $(subst >, ,$(dep))))

.PHONY: $(WORK_DIR)/apkg.rc
$(WORK_DIR)/apkg.rc:
	$(create_target_dir)
	@$(MSG) "Creating WD apkg config file for $(SPK_NAME)"
	@echo Package: $(SPK_NAME) > $@
	@echo Version: $(SPK_VERS)-$(SPK_REV) >> $@
	@echo Packager: $(MAINTAINER) >> $@
	@echo Homepage: $(HOMEPAGE) >> $@
	@echo Description: ${DESCRIPTION} >> $@
	@echo AddonShowName: $(DISPLAY_NAME) >> $@
	@echo Icon: PACKAGE_ICON.PNG >> $@
ifneq ($(strip $(INSTALL_DEP_SERVICES)),)
    @echo "InstDepend: $(WD_DEPENDS)" >> $@
endif
ifneq ($(strip $(START_DEP_SERVICES)),)
    @echo "StartDepend: $(WD_DEPENDS)" >> $@
endif
	@echo "IndividualFlag: 0" >> $@


.PHONY: $(WORK_DIR)/INFO
$(WORK_DIR)/INFO:
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@echo package=\"$(SPK_NAME)\" > $@
	@echo dsmappname=\"com.synocommunity.$(SPK_NAME)\" >> $@
	@echo thirdparty=\"yes\" >> $@
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

ifneq ($(strip $(FIRMWARE)),)
	@echo firmware=\"$(FIRMWARE)\" >> $@
else ifneq ($(strip $(OS_MIN_VER)),)
	@echo os_min_ver=\"$(OS_MIN_VER)\" >> $@
else ifneq ($(strip $(TC_FIRMWARE)),)
	@echo firmware=\"$(TC_FIRMWARE)\" >> $@
	@echo os_min_ver=\"$(TC_FIRMWARE)\" >> $@
else ifneq ($(strip $(TC_OS_MIN_VER)),)
	@echo os_min_ver=\"$(TC_OS_MIN_VER)\" >> $@
else
	@echo firmware=\"3.1-1594\" >> $@
	@echo os_min_ver=\"3.1-1594\" >> $@
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
	@echo startable=\"$(STARTABLE)\" >> $@
	@echo ctl_stop=\"$(STARTABLE)\" >> $@
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
WD_SCRIPTS = $(addprefix $(WD_SCRIPTS_DIR)/,$(WD_SCRIPTS_))

define wd_script_redirect
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/sh' > $@
echo 'SYNOPKG_PKGNAME=$(SPK_NAME)' >> $@
echo 'PKGNAME=$(SPK_NAME)' >> $@
echo 'SYNOPKG_PKGDEST=/shares/Volume_1/Nas_Prog/$(SPK_NAME)' >> $@
echo 'SYNOPKG_TEMP_LOGFILE=/tmp/debug_apkg' >> $@
echo '[[ ! -e /var/packages ]] && ln -s /shares/Volume_1/Nas_Prog /var/packages' >> $@
echo '. `dirname $$0`/scripts/installer' >> $@
echo '`basename $$0 .sh` $$@ $(INSTALLER_OUTPUT)' >> $@
exit 0
chmod 755 $@
endef

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

$(WORK_DIR)/preinst.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/install.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/init.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/start.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/stop.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/clean.sh:
	@$(wd_script_redirect)
$(WORK_DIR)/remove.sh:
	@$(wd_script_redirect)

# Package Icons
.PHONY: icons
icons:
ifneq ($(strip $(SPK_ICON)),)
	$(create_target_dir)
	mkdir -p $(WORK_DIR)/web
	@$(MSG) "Creating PACKAGE_ICON.PNG for $(SPK_NAME)"
	(convert $(SPK_ICON) -thumbnail 72x72 - > $(WORK_DIR)/web/PACKAGE_ICON.PNG)
	@$(MSG) "Creating PACKAGE_ICON_256.PNG for $(SPK_NAME)"
	(convert $(SPK_ICON) -thumbnail 256x256 - > $(WORK_DIR)/web/PACKAGE_ICON_256.PNG)
	$(eval SPK_CONTENT += web)
endif

.PHONY: webredirect
webredirect:
ifneq ($(strip $(ADMIN_PORT)),)
	$(create_target_dir)
	mkdir -p $(WORK_DIR)/web
	@$(MSG) "Creating web redirect for $(SPK_NAME)"
	# little hack as I don't know how to escape this
	echo "<?php header(\"Location: http://{$$ _SERVER['SERVER_ADDR']}:$(ADMIN_PORT)\"); ?>" | sed 's/$$ /$$/' >> $(WORK_DIR)/web/index.php
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
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -and \( -name "install_uifile" -or -name "install_uifile_???" -or -name "install_uifile.sh" -or -name "install_uifile_???.sh" -or -name "upgrade_uifile" -or -name "upgrade_uifile_???" -or -name "upgrade_uifile.sh" -or -name "upgrade_uifile_???.sh" -or -name "upgrade_uninstall" -or -name "uninstall_uifile_???" -or -name "upgrade_uninstall.sh" -or -name "upgrade_uninstall_???.sh" \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
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

$(SPK_FILE_NAME): $(WORK_DIR)/package.tgz $(WORK_DIR)/INFO info-checksum icons service $(DSM_SCRIPTS) wizards $(DSM_LICENSE) conf $(WD_SCRIPTS)
	$(create_target_dir)
	(cd $(WORK_DIR) && tar cpf $@ --group=root --owner=root $(SPK_CONTENT))

WD_ARCHIVE = $(WORK_DIR)/$(SPK_NAME)_$(ARCH).tar.gz
WD_HEADER = $(WORK_DIR)/$(SPK_NAME)_$(ARCH).blob
WD_SIGN = apkg.sign
WD_XML = $(WORK_DIR)/apkg.xml

.PHONY: $(WORK_DIR)/apkg.sign
$(WORK_DIR)/apkg.sign:
	@$(MSG) "Create WD signature"
	$(create_target_dir)
	@cd $(WORK_DIR) && echo $(SPK_NAME) | openssl bf-cbc -out apkg.sign -k Lidho.mdk3K3h -md md5 && chmod 644 apkg.sign
	$(eval SPK_CONTENT += apkg.sign)

.PHONY: $(WD_XML)
$(WD_XML):
	@$(MSG) "Create WD XML"
	$(create_target_dir)
	@echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	@echo '<config>' >> $@
	@echo ' <apkg>' >> $@
	@echo '  <item>' >> $@
	@echo '   <procudt_id>0</procudt_id>' >> $@
	@echo '   <custom_id>20</custom_id>' >> $@
	@echo '   <model_id>7</model_id>' >> $@
	@echo '   <user_control>0</user_control>' >> $@
	@echo '   <center_type>0</center_type>' >> $@
	@echo '   <individual_flag>0</individual_flag>' >> $@
	@echo '   <name>$(SPK_NAME)</name>' >> $@
	@echo '   <show>$(DISPLAY_NAME)</show>' >> $@
	@echo '   <enable>1</enable>' >> $@
	@echo '   <version>$(SPK_VERS)</version>' >> $@
	@echo '   <date>20190125</date>' >> $@
	@echo '   <inst_date/>' >> $@
	@echo '   <path/>' >> $@
	@echo '   <ps_name/>' >> $@
ifneq ($(strip $(ADMIN_PORT)),)
	@echo '   <url>index.php</url>' >> $@
else
	@echo '   <url/>' >> $@
endif
	@echo '   <url_port/>' >> $@
	@echo '   <apkg_version>2</apkg_version>' >> $@
	@echo '   <packager>TFL</packager>' >> $@
	@echo '   <email/>' >> $@
	@echo '   <homepage>$(HOME_PAGE)</homepage>' >> $@
	@echo '   <inst_depend>$(WD_DEPENDS)</inst_depend>' >> $@
	@echo '   <inst_conflict/>' >> $@
	@echo '   <start_depend>$(WD_DEPENDS)</start_depend>' >> $@
	@echo '   <start_conflict/>' >> $@
	@echo '   <description>${DESCRIPTION}</description>' >> $@
	@echo '   <icon>PACKAGE_ICON.PNG</icon>' >> $@
	@echo '   <MinFWVer/>' >> $@
	@echo '   <MaxFWVer/>' >> $@
	@echo '   </item>' >> $@
	@echo '  </apkg>' >> $@
	@echo '</config>' >> $@
	@chmod 644 $@
	$(eval SPK_CONTENT += apkg.xml)


.PHONY: $(WD_ARCHIVE)
$(WD_ARCHIVE): $(WORK_DIR)/package.tgz $(WORK_DIR)/INFO info-checksum icons service $(DSM_SCRIPTS) wizards $(DSM_LICENSE) conf $(WD_SCRIPTS) $(WD_XML)
	$(create_target_dir)
ifneq ("$(wildcard $(WORK_DIR)/$(SPK_NAME))","")
	rm -rf $(WORK_DIR)/$(SPK_NAME)
endif
	cd $(WORK_DIR) && mkdir $(SPK_NAME) && mv $(SPK_CONTENT) $(SPK_NAME) && \
    tar -zcf $@ $(SPK_NAME) --owner=root --group=root

$(WD_HEADER): $(WORK_DIR)/package.tgz $(WD_SCRIPTS) icons $(WORK_DIR)/apkg.sign $(WD_ARCHIVE) webredirect
	$(create_target_dir)
	@L=$$(stat -L -c %s $(WD_ARCHIVE)); \
	echo Got size $$L, trim to 4 bytes; \
	T=$$((4 * ($$L / 4 ))); \
	C=$$(($$(xor_checksum $(WD_ARCHIVE) 4 0 $$T ))); \
	echo Got checksum $$C; \
	dd if=/dev/zero of=$(WD_HEADER) bs=200 count=1 status=none; \
	printf $(WD_MODEL) | dd of=$(WD_HEADER) conv=notrunc status=none; \
	printf Z$(SPK_NAME) | dd of=$(WD_HEADER) conv=notrunc status=none bs=1 seek=7; \
	printf $(SPK_VERS)-$(SPK_REV) | dd of=$(WD_HEADER) conv=notrunc status=none bs=4 seek=19; \
	printf 02 | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc status=none bs=4 seek=28; \
	printf 14 | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc status=none bs=4 seek=30; \
	printf $(WD_MODEL_CODE) | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc status=none bs=4 seek=31; \
	printf 01 | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc status=none bs=4 seek=32; \
	printf '%08x' $$C | rev | dd conv=swab status=none | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc bs=4 seek=48 status=none; \
	printf '%08x' $$L | rev | dd conv=swab status=none | xxd -r -p | dd of=$(WD_HEADER) conv=notrunc bs=4 seek=49 status=none;
	cat $(WD_HEADER) | xxd

$(WD_FILE_NAME): $(WORK_DIR)/package.tgz $(WD_SCRIPTS) icons $(WORK_DIR)/apkg.sign $(WD_ARCHIVE) $(WD_HEADER)
	$(create_target_dir)
	@cat $(WD_HEADER) > $(WD_FILE_NAME)
	@cat $(WD_ARCHIVE) >> $(WD_FILE_NAME)

package: $(WD_FILE_NAME)

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
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; \
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

apkg-%:
	@$(MSG) Building WD binary package
	# DL4100
	-@MAKEFLAGS= $(MAKE) WD_MODEL=Sprite WD_MODEL_CODE=05 ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))
	# DL2100
	-@MAKEFLAGS= $(MAKE) WD_MODEL=Aurora WD_MODEL_CODE=06 ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))
	# MyCloudPR4100
	-@MAKEFLAGS= $(MAKE) WD_MODEL=BlackCy WD_MODEL_CODE=07 ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))
	# MyCloudPR2100
	-@MAKEFLAGS= $(MAKE) WD_MODEL=BryceCy WD_MODEL_CODE=08 ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*)))

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
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) ; do \
	  if $(MAKE) --no-print-directory -C ../../$$depend kernel-required >/dev/null 2>&1 ; then \
	    exit 0 ; \
	  else \
	    exit 1 ; \
	  fi ; \
	done
