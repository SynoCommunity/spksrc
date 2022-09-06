### Rules to create the spk package
#   Most of the rules are imported from spksrc.*.mk files
#
# Variables:
#  ARCH                         A dedicated arch, a generic arch or empty for arch independent packages
#  SPK_NAME                     Package name
#  MAINTAINER                   Package maintainer (mandatory)
#  MAINTAINER_URL               URL of package maintainer (optional when MAINTAINER is a valid github user)
#  SPK_NAME_ARCH                (optional) arch specific spk file name (default: $(ARCH))
#  SPK_PACKAGE_ARCHS            (optional) list of archs in the spk file (default: $(ARCH) or list of archs when generic arch)
#  UNSUPPORTED_ARCHS            (optional) Unsupported archs are removed from gemeric arch list (ignored when SPK_PACKAGE_ARCHS is used)
#  REMOVE_FROM_GENERIC_ARCHS    (optional) A list of archs to be excluded from generic archs (ignored when SPK_PACKAGE_ARCHS is used)
#  SSS_SCRIPT                   (optional) Use service start stop script from given file
#  INSTALLER_SCRIPT             (optional) Use installer script from given file
#  CONF_DIR                     (optional) To provide a package specific conf folder with files (e.g. privilege file)
#  LICENSE_FILE                 (optional) Add licence from given file
# 
# Internal variables used in this file:
#  NAME                         The internal name of the package.
#                               Note that all synocoummunity packages use lowercase names.
#                               This enables to have concurrent packages with synology.com, that use
#                               package names starting with upper case letters.
#                               (e.g. Mono => synology.com, mono => synocommunity.com)
#  SPK_FILE_NAME                The full spk name with folder, package name, arch, tc- and package version.
#  SPK_CONTENT                  List of files and folders that are added to package.tgz within the spk file.
#  DSM_SCRIPT_FILES             List of script files that are in the scripts folder within the spk file.
#

# Common makefiles
include ../../mk/spksrc.common.mk
include ../../mk/spksrc.directories.mk

# Configure the included makefiles
NAME = $(SPK_NAME)

ifneq ($(ARCH),)
# arch specific packages
ifneq ($(SPK_PACKAGE_ARCHS),)
SPK_ARCH = $(SPK_PACKAGE_ARCHS)
else
ifeq ($(findstring $(ARCH),$(GENERIC_ARCHS)),$(ARCH))
SPK_ARCH = $(filter-out $(UNSUPPORTED_ARCHS) $(REMOVE_FROM_GENERIC_ARCHS),$(TC_ARCH))
else
SPK_ARCH = $(filter-out $(UNSUPPORTED_ARCHS),$(TC_ARCH))
endif
endif
ifeq ($(SPK_NAME_ARCH),)
SPK_NAME_ARCH = $(ARCH)
endif
SPK_TCVERS = $(TCVERSION)
ARCH_SUFFIX = -$(ARCH)-$(TCVERSION)
TC = syno$(ARCH_SUFFIX)
else
# different noarch packages
SPK_ARCH = noarch
SPK_NAME_ARCH = noarch
ifneq ($(strip $(TCVERSION)),)
ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
SPK_TCVERS = dsm7
TC_OS_MIN_VER = 7.0-40000
else ifeq ($(call version_ge, $(TCVERSION), 6.1),1)
SPK_TCVERS = dsm6
TC_OS_MIN_VER = 6.1-15047
else ifeq ($(call version_ge, $(TCVERSION), 3.0),1)
SPK_TCVERS = all
TC_OS_MIN_VER = 3.1-1594
else
SPK_TCVERS = srm
TC_OS_MIN_VER = 1.1-6931
endif
else
SPK_TCVERS = all
TC_OS_MIN_VER = 3.1-1594
endif
ARCH_SUFFIX = -$(SPK_TCVERS)
endif

ifeq ($(call version_lt, ${TC_OS_MIN_VER}, 6.1)$(call version_ge, ${TC_OS_MIN_VER}, 3.0),11)
OS_MIN_VER = $(TC_OS_MIN_VER)
else
ifneq ($(strip $(OS_MIN_VER)),)
$(warning WARNING: OS_MIN_VER is forced to $(OS_MIN_VER) (default by toolchain is $(TC_OS_MIN_VER)))
else
OS_MIN_VER = $(TC_OS_MIN_VER)
endif
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
DSM_SCRIPT_FILES  = preinst postinst
DSM_SCRIPT_FILES += preuninst postuninst
DSM_SCRIPT_FILES += preupgrade postupgrade

# SPK specific scripts
ifneq ($(strip $(SSS_SCRIPT)),)
DSM_SCRIPT_FILES += start-stop-status

$(DSM_SCRIPTS_DIR)/start-stop-status: $(SSS_SCRIPT)
	@$(dsm_script_copy)
endif

ifneq ($(strip $(INSTALLER_SCRIPT)),)
DSM_SCRIPT_FILES += installer

$(DSM_SCRIPTS_DIR)/installer: $(INSTALLER_SCRIPT)
	@$(dsm_script_copy)
endif

SPK_CONTENT = package.tgz INFO scripts

# conf
DSM_CONF_DIR = $(WORK_DIR)/conf

ifneq ($(CONF_DIR),)
SPK_CONF_DIR = $(CONF_DIR)
endif

# Generic service scripts
include ../../mk/spksrc.service.mk

icon: strip
ifneq ($(strip $(SPK_ICON)),)
include ../../mk/spksrc.icon.mk
endif

ifeq ($(strip $(MAINTAINER)),)
$(error Add MAINTAINER for '$(SPK_NAME)' in spk Makefile or set default MAINTAINER in local.mk.)
endif

get_github_maintainer_url = $(shell wget --quiet --spider https://github.com/$(1) && echo "https://github.com/$(1)" || echo "")
get_github_maintainer_name = $(shell curl -s -H application/vnd.github.v3+json https://api.github.com/users/$(1) | jq -r '.name' | sed -e 's|null||g' | sed -e 's|^$$|$(1)|g' )

$(WORK_DIR)/INFO:
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@if [ -z "$(SPK_ARCH)" ]; then \
	   echo "ERROR: Arch '$(ARCH)' is not a supported architecture" ; \
	   echo " - There is no remaining arch in '$(TC_ARCH)' for unsupported archs '$(UNSUPPORTED_ARCHS)'"; \
	   exit 1; \
	fi
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
	@echo maintainer=\"$(call get_github_maintainer_name,$(MAINTAINER))\" >> $@
ifeq ($(strip $(MAINTAINER_URL)),)
	@echo maintainer_url=\"$(call get_github_maintainer_url,$(MAINTAINER))\" >> $@
else
	@echo maintainer_url=\"$(MAINTAINER_URL)\" >> $@
endif
	@echo distributor=\"$(DISTRIBUTOR)\" >> $@
	@echo distributor_url=\"$(DISTRIBUTOR_URL)\" >> $@
ifeq ($(call version_lt, ${TC_OS_MIN_VER}, 6.1)$(call version_ge, ${TC_OS_MIN_VER}, 3.0),11)
	@echo firmware=\"$(OS_MIN_VER)\" >> $@
else
	@echo os_min_ver=\"$(OS_MIN_VER)\" >> $@
ifneq ($(strip $(OS_MAX_VER)),)
	@echo os_max_ver=\"$(OS_MAX_VER)\" >> $@
endif
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

# for non startable (i.e. non service, cli tools only)
# as default is 'yes' we only add this value for 'no'
ifeq ($(STARTABLE),no)
ifeq ($(call version_lt, ${TC_OS_MIN_VER}, 6.1)$(call version_ge, ${TC_OS_MIN_VER}, 3.0),11)
	@echo startable=\"$(STARTABLE)\" >> $@
else
	@echo ctl_stop=\"$(STARTABLE)\" >> $@
endif
endif

ifneq ($(strip $(DISPLAY_NAME)),)
	@echo displayname=\"$(DISPLAY_NAME)\" >> $@
endif
ifneq ($(strip $(DSM_UI_DIR)),)
	@[ -d $(STAGING_DIR)/$(DSM_UI_DIR) ] && echo dsmuidir=\"$(DSM_UI_DIR)\" >> $@ || true
endif
ifneq ($(strip $(DSM_APP_NAME)),)
	@echo dsmappname=\"$(DSM_APP_NAME)\" >> $@
else
	@echo dsmappname=\"com.synocommunity.packages.$(SPK_NAME)\" >> $@
endif
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ifneq ($(strip $(DSM_APP_PAGE)),)
	@echo dsmapppage=\"$(DSM_APP_PAGE)\" >> $@
endif
ifneq ($(strip $(DSM_APP_LAUNCH_NAME)),)
	@echo dsmapplaunchname=\"$(DSM_APP_LAUNCH_NAME)\" >> $@
endif
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
	@echo checksum=\"$$(md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1)\" >> $@

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

define dsm_resource_copy
$(create_target_dir)
$(MSG) "Creating $@"
cp $< $@
chmod 644 $@
endef

$(DSM_LICENSE_FILE): $(LICENSE_FILE)
	@echo $@
	@$(dsm_resource_copy)

### Packaging rules
$(WORK_DIR)/package.tgz: icon service
	$(create_target_dir)
	@[ -f $@ ] && rm $@ || true
	(cd $(STAGING_DIR) && find . -mindepth 1 -maxdepth 1 -not -empty | tar cpzf $@ --owner=root --group=root --files-from=/dev/stdin)

DSM_SCRIPTS = $(addprefix $(DSM_SCRIPTS_DIR)/,$(DSM_SCRIPT_FILES))

define dsm_script_redirect
$(create_target_dir)
$(MSG) "Creating $@"
echo '#!/bin/sh' > $@
echo '. $$(dirname $$0)/installer' >> $@
echo '$$(basename $$0) $(INSTALLER_OUTPUT)' >> $@
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

# Package Icons
.PHONY: icons
icons:
ifneq ($(strip $(SPK_ICON)),)
	$(create_target_dir)
	@$(MSG) "Creating PACKAGE_ICON.PNG for $(SPK_NAME)"
ifneq ($(call version_ge, ${TCVERSION}, 7.0),1)
	(convert $(SPK_ICON) -resize 72x72 -strip -sharpen 0x2 - > $(WORK_DIR)/PACKAGE_ICON.PNG)
else
	(convert $(SPK_ICON) -resize 64x64 -strip -sharpen 0x2 - > $(WORK_DIR)/PACKAGE_ICON.PNG)
endif
	@$(MSG) "Creating PACKAGE_ICON_256.PNG for $(SPK_NAME)"
	(convert $(SPK_ICON) -resize 256x256 -strip -sharpen 0x2 - > $(WORK_DIR)/PACKAGE_ICON_256.PNG)
	$(eval SPK_CONTENT += PACKAGE_ICON.PNG PACKAGE_ICON_256.PNG)
endif

.PHONY: info-checksum
info-checksum:
	@$(MSG) "Creating checksum for $(SPK_NAME)"
	@sed -i -e "s|checksum=\".*|checksum=\"$$(md5sum $(WORK_DIR)/package.tgz | cut -d" " -f1)\"|g" $(WORK_DIR)/INFO


# file names to be used with "find" command
WIZARD_FILE_NAMES  =     -name "install_uifile" 
WIZARD_FILE_NAMES += -or -name "install_uifile_???" 
WIZARD_FILE_NAMES += -or -name "install_uifile.sh"
WIZARD_FILE_NAMES += -or -name "install_uifile_???.sh"
WIZARD_FILE_NAMES += -or -name "upgrade_uifile"
WIZARD_FILE_NAMES += -or -name "upgrade_uifile_???"
WIZARD_FILE_NAMES += -or -name "upgrade_uifile.sh"
WIZARD_FILE_NAMES += -or -name "upgrade_uifile_???.sh"
WIZARD_FILE_NAMES += -or -name "uninstall_uifile"
WIZARD_FILE_NAMES += -or -name "uninstall_uifile_???"
WIZARD_FILE_NAMES += -or -name "uninstall_uifile.sh"
WIZARD_FILE_NAMES += -or -name "uninstall_uifile_???.sh"


.PHONY: wizards
wizards:
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@$(MSG) "Create default DSM7 uninstall wizard"
	@mkdir -p $(DSM_WIZARDS_DIR)
	@find $(SPKSRC_MK)wizard -maxdepth 1 -type f -and \( -name "uninstall_uifile" -or -name "uninstall_uifile_???" \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
ifeq ($(strip $(WIZARDS_DIR)),)
	$(eval SPK_CONTENT += WIZARD_UIFILES)
endif
endif
ifneq ($(strip $(WIZARDS_DIR)),)
	@$(MSG) "Create DSM Wizards"
	$(eval SPK_CONTENT += WIZARD_UIFILES)
	@mkdir -p $(DSM_WIZARDS_DIR)
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
	@if [ -d "$(WIZARDS_DIR)$(TCVERSION)" ]; then \
	    $(MSG) "Create DSM Version specific Wizards: $(WIZARDS_DIR)$(TCVERSION)"; \
		find $${SPKSRC_WIZARDS_DIR}$(TCVERSION) -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \; ;\
	fi
endif
ifneq ($(wildcard $(DSM_WIZARDS_DIR)/*),)
	@find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -not -name "*.sh" -print -exec chmod 0644 {} \;
	@find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -name "*.sh" -print -exec chmod 0755 {} \;
endif

.PHONY: conf
conf:
ifneq ($(strip $(CONF_DIR)),)
	@$(MSG) "Preparing conf"
	@mkdir -p $(DSM_CONF_DIR)
	@find $(SPK_CONF_DIR) -maxdepth 1 -type f -print -exec cp -f {} $(DSM_CONF_DIR) \;
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
	http --verify=no --ignore-stdin --auth $(PUBLISH_API_KEY): POST $(PUBLISH_URL)/packages @$(SPK_FILE_NAME)


### Clean rules
clean:
	rm -fr work work-* build-*.log

spkclean:
	rm -fr work-*/.copy_done \
	       work-*/.depend_done \
	       work-*/.icon_done \
	       work-*/.strip_done \
	       work-*/.wheel_done \
	       work-*/conf \
	       work-*/scripts \
	       work-*/staging \
	       work-*/tc_vars.mk \
	       work-*/tc_vars.cmake \
	       work-*/wheelhouse \
	       work-*/package.tgz \
	       work-*/INFO \
	       work-*/PLIST \
	       work-*/PACKAGE_ICON* \
	       work-*/WIZARD_UIFILES

all: package
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(ARCH)-$(TCVERSION) >> $(PSTAT_LOG)
endif

### For make dependency-tree
include ../../mk/spksrc.dependency-tree.mk

.PHONY: all-archs
all-archs: $(addprefix arch-,$(AVAILABLE_TOOLCHAINS))

.PHONY: publish-all-archs
publish-all-archs: $(addprefix publish-arch-,$(AVAILABLE_TOOLCHAINS))

####
# make all-supported
ifeq (supported,$(subst all-,,$(subst publish-,,$(firstword $(MAKECMDGOALS)))))
ACTION = supported
# make setup not invoked
ifeq ($(strip $(SUPPORTED_ARCHS)),)
ALL_ACTION = error
else
ALL_ACTION = $(SUPPORTED_ARCHS)
endif

# make all-latest
else ifeq (latest,$(subst all-,,$(subst publish-,,$(firstword $(MAKECMDGOALS)))))
ACTION = latest
ALL_ACTION = $(LATEST_ARCHS)
endif

# make publish-all-supported | make publish-all-latest
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

pre-build-native: SHELL:=/bin/bash
pre-build-native:
	@$(MSG) Pre-build native dependencies for parallel build
	@for depend in $$($(MAKE) dependency-list) ; \
	do \
	  if [ "$${depend%/*}" = "native" ]; then \
	    $(MSG) "Pre-processing $${depend}" ; \
	    $(MSG) "  env $(ENV) $(MAKE) -C ../../$$depend" ; \
	    env $(ENV) $(MAKE) -C ../../$$depend 2>&1 | tee --append build-$${depend%/*}-$${depend#*/}.log ; \
	    [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  fi ; \
	done
ifneq ($(filter all,$(subst -, ,$(MAKECMDGOALS))),)
	$(MAKE) $(addprefix $(PUBLISH)$(ACTION)-arch-,$(ALL_ACTION))
endif

$(PUBLISH)all-$(ACTION): | pre-build-native

spk_msg:
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $(MAKECMDGOALS), SPK: $(SPK_NAME) >> $(PSTAT_LOG)
endif

supported-arch-error:
	@$(MSG) ########################################################
	@$(MSG) ERROR - Please run make setup from spksrc root directory
	@$(MSG) ########################################################

supported-arch-%: spk_msg
	@$(MSG) "BUILDING package for arch $* (all-supported)" | tee --append build-$*.log
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) $(addprefix arch-, $*)

publish-supported-arch-%: spk_msg
	@$(MSG) "BUILDING and PUBLISHING package for arch $* (publish-all-supported)" | tee --append build-$*.log
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) $(addprefix publish-arch-, $*)

latest-arch-%: spk_msg
	@$(MSG) "BUILDING package for arch $* (all-latest)" | tee --append build-$*.log
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) $(addprefix arch-, $*)

publish-latest-arch-%: spk_msg
	@$(MSG) "BUILDING and PUBLISHING package for arch $* (publish-all-latest)" | tee --append build-$*.log
	-@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) $(addprefix publish-arch-, $*)

####

all-legacy: spk_msg
	@$(MSG) BUILDING package for legacy DSM and SRM archs
	$(MAKE) legacy-toolchain-5.2 legacy-toolchain-1.2

publish-all-legacy: spk_msg
	@$(MSG) BUILDING and PUBLISHING package for legacy DSM archs
	$(MAKE) publish-legacy-toolchain-5.2

####

legacy-toolchain-%: spk_msg
	@$(MSG) BUILDING packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(LEGACY_ARCHS))))))) ; \
	do \
	  $(MAKE) arch-$$arch-$* ; \
	done \

publish-legacy-toolchain-%: spk_msg
	@$(MSG) BUILDING and PUBLISHING packages for toolchain $*
	@for arch in $(sort $(basename $(subst -,.,$(basename $(subst .,,$(filter %$*, $(LEGACY_ARCHS))))))) ; \
	do \
	  $(MAKE) publish-arch-$$arch-$* ; \
	done \

####

kernel-modules-%: SHELL:=/bin/bash
kernel-modules-%:
	@if [ "$(filter $(DEFAULT_TC),lastword $(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(SUPPORTED_KERNEL_VERSIONS)),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile)), $(LEGACY_ARCHS)))" ; \
	elif [ "$(filter $(GENERIC_ARCHS),$(subst -, ,$(MAKECMDGOALS)))" ]; then \
	   archs2process="$(filter $(addprefix %-,$(lastword $(subst -, ,$(MAKECMDGOALS)))),$(filter $(addsuffix -$(word 1,$(subst ., ,$(word 2,$(subst -, ,$*))))%,$(shell sed -n -e '/TC_ARCH/ s/.*= *//p' ../../toolchain/syno-$*/Makefile)), $(LEGACY_ARCHS)))" ; \
	else \
	   archs2process=$* ; \
	fi ; \
	$(MSG) ARCH to be processed: $${archs2process} ; \
	for arch in $${archs2process} ; do \
	  $(MSG) "Processing $${arch} ARCH" ; \
	  MAKEFLAGS= $(PSTAT_TIME) $(MAKE) WORK_DIR=$(PWD)/work-$* ARCH=$$(echo $${arch} | cut -f1 -d-) TCVERSION=$$(echo $${arch} | cut -f2 -d-) strip 2>&1 | tee --append build-$*.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false ; \
	  $(MAKE) spkclean ; \
	  rm -fr $(PWD)/work-$*/$(addprefix linux-, $${arch}) ; \
	  $(MAKE) -C ../../toolchain/syno-$${arch} clean ; \
	done

arch-%: | pre-build-native
ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))
	$(MAKE) REQUIRE_KERNEL_MODULE= REQUIRE_KERNEL= WORK_DIR=$(PWD)/work-$* $(addprefix build-arch-, $*)
else
	# handle and allow parallel build for:  arch-<arch> | make arch-<arch>-X.Y
	@$(MSG) BUILDING package for arch $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))), $*)
	$(MAKE) $(addprefix build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))
endif

build-arch-%: SHELL:=/bin/bash
build-arch-%: spk_msg
	@$(MSG) BUILDING package for arch $*
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, SPK: $(SPK_NAME) [BEGIN] >> $(PSTAT_LOG)
endif
	@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) 2>&1 | tee --append build-$*.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false
ifneq ($(filter 1 on ON,$(PSTAT)),)
	@$(MSG) MAKELEVEL: $(MAKELEVEL), PARALLEL_MAKE: $(PARALLEL_MAKE), ARCH: $*, SPK: $(SPK_NAME) [END] >> $(PSTAT_LOG)
endif


publish-arch-%: SHELL:=/bin/bash
publish-arch-%: spk_msg
ifneq ($(strip $(REQUIRE_KERNEL_MODULE)),)
	$(MAKE) $(addprefix kernel-modules-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))
	$(MAKE) REQUIRE_KERNEL_MODULE= REQUIRE_KERNEL= WORK_DIR=$(PWD)/work-$* $(addprefix publish-arch-, $*)
else
	# handle and allow parallel build for:  arch-<arch> | make arch-<arch>-X.Y
	@$(MSG) BUILDING and PUBLISHING package for arch $*
	@MAKEFLAGS= $(PSTAT_TIME) $(MAKE) ARCH=$(basename $(subst -,.,$(basename $(subst .,,$*)))) TCVERSION=$(if $(findstring $*,$(basename $(subst -,.,$(basename $(subst .,,$*))))),$(DEFAULT_TC),$(notdir $(subst -,/,$*))) publish 2>&1 | tee --append build-$*.log ; \
	  [ $${PIPESTATUS[0]} -eq 0 ] || false
endif

####

changelog:
	@echo $(shell git log --pretty=format:"- %s" -- $(PWD))

####

### For make kernel-required
include ../../mk/spksrc.kernel-required.mk

####
