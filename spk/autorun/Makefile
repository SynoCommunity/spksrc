SPK_NAME = autorun
SPK_VERS = 1.10.0
SPK_REV = 11
SPK_ICON = src/synology-autorun.png
DSM_UI_DIR = ui

### Remarks:
### This package takes over allmost everything from https://github.com/schmidhorst/synology-autorun
### - the original service scripts (use custom SCRIPTS_TARGET)
### - the original wizards files (use custom WIZARDS_TARGET)
### - the INFO file is not provided. To create a similar INFO file with spksrc framework, 
###   some adjustments are required:
###   - SPK_REV above should match the original revision
###   - use original DSM_APP_NAME
###   - mantainer is not a plain github user name
###   - language specific descriptions need transformation to be used in variables

DEPENDS = cross/synology-autorun

MAINTAINER = "Jan Reidemeister, Horst Schmid"
MAINTAINER_URL = https://github.com/schmidhorst/synology-autorun

DESCRIPTION = Runs a script on/for an external drive \(USB / eSATA\) after it is connected to the Disk Station.
DISPLAY_NAME = Autorun
CHANGELOG = "Initial package hosted by SynoCommunity<br/>For full changelog see https://github.com/schmidhorst/synology-autorun/blob/main/CHANGELOG"

HOMEPAGE = https://github.com/schmidhorst/synology-autorun
LICENSE  = 3-clause BSD

# Pure script package, make sure ARCH is noarch
override ARCH=noarch

# ui, config and help do not work with "com.synology.packages.autorun"
DSM_APP_NAME=SYNO.SDS._ThirdParty.App.autorun

CONF_DIR = $(STAGING_INSTALL_PREFIX)/conf

COPY_TARGET = autorun_install
WIZARDS_TARGET = autorun_wizards
SCRIPTS_TARGET = autorun_scripts
# SPK_COMMANDS is not required, but makes the dummy definition of SERVICE_COMMAND or STARTABLE obsolete
SPK_COMMANDS = bin/autorun-cli

include ../../mk/spksrc.spk.mk

.PHONY: autorun_wizards
autorun_wizards:
	@$(MSG) Install original wizard files
	$(eval SPK_CONTENT += WIZARD_UIFILES)
	@install -m 755 -d $(STAGING_DIR)/../WIZARD_UIFILES
	@cp -p $(STAGING_INSTALL_PREFIX)/WIZARD_UIFILES/* $(STAGING_DIR)/../WIZARD_UIFILES/

.PHONY autorun_scripts:
autorun_scripts:
	@$(MSG) Install original script files
	@install -m 755 -d $(STAGING_DIR)/../scripts
	@cp -p $(STAGING_INSTALL_PREFIX)/scripts/* $(STAGING_DIR)/../scripts/
	@rm -f $(STAGING_DIR)/../scripts/service-setup

# take available languages only (not implemented: cht, krn, nor)
AVAILABLE_LANG = $(subst $(STAGING_INSTALL_PREFIX)/package/ui/texts/,,$(subst /lang.txt,,$(wildcard $(STAGING_INSTALL_PREFIX)/package/ui/texts/*/lang.txt)))
# we must escape parentheses and single quote characters for variables holding the description
SUBSTITUTION = -e 's/(/\\\(/g' -e 's/)/\\\)/g' -e s/\'/\\\\\'/g

.PHONY: define_descriptions
define_descriptions:
	@$(MSG) "Define language specific descriptions"
	$(foreach LANG, $(AVAILABLE_LANG), $(eval DESCRIPTION_$(shell echo $(LANG) | tr [:lower:] [:upper:]) := "$(shell grep descriptionINFO $(STAGING_INSTALL_PREFIX)/package/ui/texts/$(LANG)/lang.txt | sed $(SUBSTITUTION) | cut -f2 -d=)"))

.PHONY: define_display_names
define_display_names:
	@$(MSG) Define language specific display names
	$(foreach LANG, $(AVAILABLE_LANG), $(eval DISPLAY_NAME_$(shell echo $(LANG) | tr [:lower:] [:upper:]) := "$(shell grep displaynameINFO $(STAGING_INSTALL_PREFIX)/package/ui/texts/$(LANG)/lang.txt | sed $(SUBSTITUTION) | cut -f2 -d=)"))

.PHONY: autorun_install
autorun_install: define_descriptions define_display_names
	@$(MSG) Install package resources
	@install -m 755 -d $(STAGING_DIR)
	@tar -cf - -C $(STAGING_INSTALL_PREFIX)/package . | tar -xf - -C $(STAGING_DIR)
	@chmod 755 -R $(STAGING_DIR)/ui
