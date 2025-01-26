### Rules to create the spk package
#   Most of the rules are imported from spksrc.*.mk files
#
# Variables:
#  ARCH                         A dedicated arch, a generic arch or 'noarch' for arch independent packages
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
ifneq ($(ARCH),noarch)
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
endif
endif

ifeq ($(ARCH),noarch)
ifneq ($(strip $(TCVERSION)),)
# different noarch packages
SPK_ARCH = noarch
SPK_NAME_ARCH = noarch
ifeq ($(call version_ge, $(TCVERSION), 7.0),1)
ifeq ($(call version_ge, $(TCVERSION), 7.2),1)
SPK_TCVERS = dsm72
TC_OS_MIN_VER = 7.2-63134
else
SPK_TCVERS = dsm7
TC_OS_MIN_VER = 7.0-40000
endif
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
ARCH_SUFFIX = -$(SPK_TCVERS)
endif
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

ifeq ($(strip $(DISABLE_GITHUB_MAINTAINER)),)
get_github_maintainer_url = $(shell wget --quiet --spider https://github.com/$(1) && echo "https://github.com/$(1)" || echo "")
get_github_maintainer_name = $(shell curl -s -H application/vnd.github.v3+json https://api.github.com/users/$(1) | jq -r '.name' | sed -e 's|null||g' | sed -e 's|^$$|$(1)|g' )
else
get_github_maintainer_url = "https://github.com/SynoCommunity"
get_github_maintainer_name = $(MAINTAINER)
endif

$(WORK_DIR)/INFO: SHELL:=/bin/sh
$(WORK_DIR)/INFO:
	$(create_target_dir)
	@$(MSG) "Creating INFO file for $(SPK_NAME)"
	@if [ -z "$(SPK_ARCH)" ]; then \
	   if [ "$(ARCH)" = "noarch" ]; then \
	      echo "ERROR: 'noarch' package without TCVERSION is not supported" ; \
	      exit 1; \
	   else \
	      echo "ERROR: Arch '$(ARCH)' is not a supported architecture" ; \
	      echo " - There is no remaining arch in '$(TC_ARCH)' for unsupported archs '$(UNSUPPORTED_ARCHS)'"; \
	      exit 1; \
	   fi; \
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
ifneq ($(strip $(INSTALL_REPLACE_PACKAGES)),)
	@echo install_replace_packages=\"$(INSTALL_REPLACE_PACKAGES)\" >> $@
endif
ifneq ($(strip $(USE_DEPRECATED_REPLACE_MECHANISM)),)
	@echo use_deprecated_replace_mechanism=\"$(USE_DEPRECATED_REPLACE_MECHANISM)\" >> $@
endif
ifneq ($(strip $(CHECKPORT)),)
	@echo checkport=\"$(CHECKPORT)\" >> $@
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

ifneq ($(strip $(WIZARDS_TEMPLATES_DIR)),)
WIZARDS_DIR = $(WORK_DIR)/generated-wizards
endif
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
ifneq ($(strip $(WIZARDS_TEMPLATES_DIR)),)
	@$(MSG) "Generate DSM Wizards from templates"
	@mkdir -p $(WIZARDS_DIR)
	$(eval IS_DSM_6_OR_GREATER = $(if $(filter 1,$(call version_ge, $(TCVERSION), 6.0)),true,false))
	$(eval IS_DSM_7_OR_GREATER = $(if $(filter 1,$(call version_ge, $(TCVERSION), 7.0)),true,false))
	$(eval IS_DSM_7 = $(IS_DSM_7_OR_GREATER))
	$(eval IS_DSM_6 = $(if $(filter true,$(IS_DSM_6_OR_GREATER)),$(if $(filter true,$(IS_DSM_7)),false,true),false))
	@for template in $(shell find $(WIZARDS_TEMPLATES_DIR) -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print); do \
		template_filename="$$(basename $${template})"; \
		template_name="$${template_filename%.*}"; \
		if [ "$${template_name}" = "$${template_filename}" ]; then \
			template_suffix=; \
		else \
			template_suffix=".$${template_filename##*.}"; \
		fi; \
		template_file_path="$(WIZARDS_TEMPLATES_DIR)/$${template_filename}"; \
		for suffix in '' $(patsubst %,_%,$(LANGUAGES)) ; do \
			template_file_localization_data_path="$(WIZARDS_TEMPLATES_DIR)/$${template_name}$${suffix}.yml"; \
			output_file="$(WIZARDS_DIR)/$${template_name}$${suffix}$${template_suffix}"; \
			if [ -f "$${template_file_localization_data_path}" ]; then \
				{ \
					echo "IS_DSM_6_OR_GREATER: $(IS_DSM_6_OR_GREATER)"; \
					echo "IS_DSM_6: $(IS_DSM_6)"; \
					echo "IS_DSM_7_OR_GREATER: $(IS_DSM_7_OR_GREATER)"; \
					echo "IS_DSM_7: $(IS_DSM_7)"; \
					cat "$${template_file_localization_data_path}"; \
				} | mustache - "$${template_file_path}" >"$${output_file}"; \
				if [ "$${template_suffix}" = "" ]; then \
					jq_failed=0; \
					errors=$$(jq . "$${output_file}" 2>&1) || jq_failed=1; \
					if [ "$${jq_failed}" != "0" ]; then \
						echo "Invalid wizard file generated $${output_file}:"; \
						echo "$${errors}"; \
						exit 1; \
					fi; \
				fi; \
			fi; \
		done; \
	done
endif
ifneq ($(strip $(WIZARDS_DIR)),)
	@$(MSG) "Create DSM Wizards"
	$(eval SPK_CONTENT += WIZARD_UIFILES)
	@mkdir -p $(DSM_WIZARDS_DIR)
	@find $${SPKSRC_WIZARDS_DIR} -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \;
	@if [ -f "$(DSM_WIZARDS_DIR)/uninstall_uifile.sh" ] && [ -f "$(DSM_WIZARDS_DIR)/uninstall_uifile" ]; then \
		rm "$(DSM_WIZARDS_DIR)/uninstall_uifile"; \
	fi
	@if [ -d "$(WIZARDS_DIR)$(TCVERSION)" ]; then \
	   $(MSG) "Create DSM Version specific Wizards: $(WIZARDS_DIR)$(TCVERSION)"; \
	   find $${SPKSRC_WIZARDS_DIR}$(TCVERSION) -maxdepth 1 -type f -and \( $(WIZARD_FILE_NAMES) \) -print -exec cp -f {} $(DSM_WIZARDS_DIR) \; ;\
	fi
	@if [ -d "$(DSM_WIZARDS_DIR)" ]; then \
	   find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -not -name "*.sh" -print -exec chmod 0644 {} \; ;\
	   find $(DSM_WIZARDS_DIR) -maxdepth 1 -type f -name "*.sh" -print -exec chmod 0755 {} \; ;\
	fi
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

all: package


### spk-specific clean rules

# Remove work-*/<pkgname>* directories while keeping
# work-*/.<pkgname>*|<pkgname>.plist status files
# This is in order to resolve: 
#    System.IO.IOException: No space left on device
# when building online thru github-action, in particular
# for "packages-to-keep" such as python* and ffmpeg*
clean-source: SHELL:=/bin/bash
clean-source: spkclean
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   pkgdirstr=$$(grep ^PKG_DIR $${makefile} || true) ; \
	   pkgdir=$$(echo $${pkgdirstr#*=} | cut -f1 -d- | sed -s 's/[\)]/ /g' | sed -s 's/[\$$\(\)]//g' | cut -f1 -d' ' | xargs) ; \
	   if [ ! "$${pkgdirstr}" ]; then \
	      continue ; \
	   elif echo "$${pkgdir}" | grep -Eq '^(PKG_|DIST)'; then \
	      pkgdirstr=$$(grep ^$${pkgdir} $${makefile}) ; \
	      pkgdir=$$(echo $${pkgdirstr#*=} | xargs) ; \
	   fi ; \
	   #echo "depend: [$${depend}] - pkgdir: [$${pkgdir}]" ; \
	   find work-*/$${pkgdir}[-_]* -maxdepth 0 -type d 2>/dev/null | while read sourcedir ; do \
	      echo "rm -fr $$sourcedir" ; \
	      find $${sourcedir}/. -mindepth 1 -maxdepth 2 -exec rm -fr {} \; 2>/dev/null || true ; \
	   done ; \
	done

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
	       work-*/tc_vars.meson \
	       work-*/package.tgz \
	       work-*/INFO \
	       work-*/PLIST \
	       work-*/PACKAGE_ICON* \
	       work-*/WIZARD_UIFILES

wheelclean: spkclean
	rm -fr work*/.wheel_done \
	       work*/.wheel_*_done \
	       work-*/wheelhouse \
	       work-*/install/var/packages/**/target/share/wheelhouse
	@make --no-print-directory dependency-flat | sort -u | grep cross/ | while read depend ; do \
	   makefile="../../$${depend}/Makefile" ; \
	   if grep -q spksrc.python-wheel.mk $${makefile} ; then \
	      pkgstr=$$(grep ^PKG_NAME $${makefile}) ; \
	      pkgname=$$(echo $${pkgstr#*=} | xargs) ; \
	      echo "rm -fr work-*/$${pkgname}*\\n       work-*/.$${pkgname}-*" ; \
	      rm -fr work-*/$${pkgname}* \
                     work-*/.$${pkgname}-* ; \
	   fi ; \
	done

wheelclean-%: spkclean
	rm -f work-*/.wheel_done \
	      work-*/wheelhouse/$*-*.whl
	find work-* -type f -regex '.*\.wheel_\(download\|compile\|install\)-$*_done' -exec rm -f {} \;

wheelcleancache:
	rm -fr work-*/pip

wheelcleanall: wheelcleancache wheelclean
	rm -fr ../../distrib/pip

crossenvclean: wheelclean
	rm -fr work-*/crossenv*
	rm -fr work-*/.crossenv-*_done

crossenvcleanall: wheelcleanall crossenvclean

pythonclean: wheelcleanall
	rm -fr work-*/.[Pp]ython*-install_done \
	rm -fr work-*/crossenv

pythoncleanall: pythonclean
	rm -fr work-*/[Pp]ython* work-*/.python*

### For managing make all-<supported|latest>
include ../../mk/spksrc.supported.mk

### For managing make publish-all-<supported|latest>
include ../../mk/spksrc.publish.mk

###
