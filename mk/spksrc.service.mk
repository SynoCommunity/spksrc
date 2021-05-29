### Service rules
# Generate background service support files in SPK:
#   scripts/installer
#   scripts/start-stop-status
#   scripts/service-setup
#   conf/privilege        if SERVICE_USER or DSM7
#   conf/SPK_NAME.sc      if SERVICE_PORT and DSM<7
#   conf/resource         if DSM7
#   app/SPK_NAME.sc       if SERVICE_PORT and DSM7
#   app/config            if DSM_UI_DIR
#
# Target are executed in the following order:
#  service_msg_target
#  pre_service_target   (override with PRE_SERVICE_TARGET)
#  service_target       (override with SERVICE_TARGET)
#  post_service_target  (override with POST_SERVICE_TARGET)

ifeq ($(strip $(PRE_SERVICE_TARGET)),)
PRE_SERVICE_TARGET = pre_service_target
else
$(PRE_SERVICE_TARGET): service_msg_target
endif
ifeq ($(strip $(SERVICE_TARGET)),)
SERVICE_TARGET = service_target
else
$(SERVICE_TARGET): $(PRE_SERVICE_TARGET)
endif
ifeq ($(strip $(POST_SERVICE_TARGET)),)
POST_SERVICE_TARGET = post_service_target
else
$(POST_SERVICE_TARGET): $(SERVICE_TARGET)
endif

ifeq ($(strip $(SERVICE_USER)),)
PRE_SERVICE_TARGET = pre_service_target
else
$(PRE_SERVICE_TARGET): service_msg_target
endif

ifeq ($(strip $(DSM_UI_DIR)),)
DSM_UI_DIR=app
endif

.PHONY: service_target service_msg_target
.PHONY: $(PRE_SERVICE_TARGET) $(SERVICE_TARGET) $(POST_SERVICE_TARGET)
.PHONY: $(DSM_SCRIPTS_DIR)/service-setup $(DSM_SCRIPTS_DIR)/start-stop-status
.PHONY: $(DSM_CONF_DIR)/privilege $(DSM_CONF_DIR)/resource
.PHONY: $(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc $(STAGING_DIR)/$(DSM_UI_DIR)/config

service_msg_target:
	@$(MSG) "Generating service scripts for $(NAME)"

pre_service_target: service_msg_target

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# always use SPK_USER on DSM >= 7, not only when SERVICE_USER is defined
SPK_USER = $(SPK_NAME)
else
# SERVICE_USER=auto uses SPK_NAME
ifeq ($(SERVICE_USER),auto)
SPK_USER = $(SPK_NAME)
else ifneq ($(strip $(SERVICE_USER)),)
$(warning Only 'SERVICE_USER=auto' is compatible with DSM7)
SPK_USER = $(SERVICE_USER)
endif
endif

# Recommend explicit STARTABLE=no
ifeq ($(strip $(SSS_SCRIPT) $(SERVICE_COMMAND) $(SERVICE_EXE) $(STARTABLE)),)
ifeq ($(strip $(SPK_COMMANDS) $(SPK_USR_LOCAL_LINKS)),)
$(error Set STARTABLE=no or provide either SERVICE_COMMAND, SERVICE_EXE, SSS_SCRIPT, SPK_COMMANDS or SPK_USR_LOCAL_LINKS)
endif
endif

SPKSRC_MK = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

SERVICE_FILES =

# Generate service-setup from SERVICE variables
$(DSM_SCRIPTS_DIR)/service-setup:
	$(create_target_dir)
	@echo "### Package specific variables and functions" > $@
	@echo 'if [ -z "$${SYNOPKG_PKGNAME}" ] || [ -z "$${SYNOPKG_DSM_VERSION_MAJOR}" ]; then' >> $@
	@echo '  echo "Error: Environment variables are not set." 1>&2;' >> $@
	@echo '  echo "Please run me using synopkg instead. Example: \"synopkg start [packagename]\"" 1>&2;' >> $@
	@echo '  exit 1' >> $@
	@echo 'fi' >> $@
	@echo '' >> $@
ifneq ($(strip $(SERVICE_USER)),)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@echo USER=\"sc-$(SPK_USER)\" >> $@
	@echo EFF_USER=\"sc-$(SPK_USER)\" >> $@
else
	@echo "# Base service USER to run background process prefixed according to DSM" >> $@
	@echo USER=\"$(SPK_USER)\" >> $@
	@echo "PRIV_PREFIX=sc-" >> $@
	@echo "SYNOUSER_PREFIX=svc-" >> $@
	@echo 'if [ -n "$${SYNOPKG_DSM_VERSION_MAJOR}" ] && [ "$${SYNOPKG_DSM_VERSION_MAJOR}" -lt 6 ]; then EFF_USER="$${SYNOUSER_PREFIX}$${USER}"; else EFF_USER="$${PRIV_PREFIX}$${USER}"; fi' >> $@
endif
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_WIZARD_GROUP)),)
	@echo "# Group name from UI if provided" >> $@
	@echo 'if [ -n "$${$(SERVICE_WIZARD_GROUP)}" ]; then GROUP="$${$(SERVICE_WIZARD_GROUP)}"; fi' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_WIZARD_SHARE)),)
	@echo "# Share download location from UI if provided" >> $@
	@echo 'if [ -n "$${$(SERVICE_WIZARD_SHARE)}" ]; then SHARE_PATH="$${$(SERVICE_WIZARD_SHARE)}"; fi' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_PORT)),)
	@echo "# Service port" >> $@
	@echo 'SERVICE_PORT="$(SERVICE_PORT)"' >> $@
	@echo '' >> $@
endif
ifneq ($(STARTABLE),no)
ifneq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@echo "# define SYNOPKG_PKGVAR for compatibility with DSM7" >> $@
	@echo 'SYNOPKG_PKGVAR="$${SYNOPKG_PKGDEST}/var"' >> $@
	@echo '' >> $@
endif
	@echo "# start-stop-status script redirect stdout/stderr to LOG_FILE" >> $@
	@echo 'LOG_FILE="$${SYNOPKG_PKGVAR}/$${SYNOPKG_PKGNAME}.log"' >> $@
	@echo '' >> $@
	@echo "# Service command has to deliver its pid into PID_FILE" >> $@
	@echo 'PID_FILE="$${SYNOPKG_PKGVAR}/$${SYNOPKG_PKGNAME}.pid"' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_COMMAND)),)
ifneq ($(strip $(SERVICE_SHELL)),)
	@echo "# Service shell to run command" >> $@
	@echo 'SERVICE_SHELL="$(SERVICE_SHELL)"' >> $@
	@echo '' >> $@
endif
	@echo "# Service command to execute (either with shell or as is)" >> $@
	@echo 'SERVICE_COMMAND="$(SERVICE_COMMAND)"' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_EXE)),)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@echo "${RED}ERROR: SERVICE_EXE (start-stop-daemon) is unsupported in DSM7${NC}"
	@echo "${GREEN}Please migrate to SERVICE_COMMAND=${NC}"
	@exit 1
endif
	@echo "# Service command to execute with start-stop-daemon" >> $@
	@echo 'SERVICE_EXE="$(SERVICE_EXE)"' >> $@
ifneq ($(strip $(SERVICE_OPTIONS)),)
	@echo 'SERVICE_OPTIONS="$(SERVICE_OPTIONS)"' >> $@
endif
	@echo '' >> $@
endif
ifeq ($(strip $(USE_ALTERNATE_TMPDIR)),1)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@cat $(SPKSRC_MK)spksrc.service.use_alternate_tmpdir.dsm7 >> $@
else
	@cat $(SPKSRC_MK)spksrc.service.use_alternate_tmpdir >> $@
endif
endif
ifneq ($(strip $(SERVICE_SETUP)),)
	@cat $(CURDIR)/$(SERVICE_SETUP) >> $@
endif

# Define resources for
# - firewall rules/port definitions (DSM >= 6.0-5936)
# - usr local links (DSM >= 6.0-5941)
# for DSM<6.0 link creation is provided by spksrc.service.create_links
# and other facilities are defined in the generic installer (spksrc.service.installer.dsm5)
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
$(DSM_CONF_DIR)/resource:
	$(create_target_dir)
	@echo '{}' > $@
ifneq ($(strip $(SERVICE_PORT)),)
	@jq '."port-config"."protocol-file" = "$(DSM_UI_DIR)/$(SPK_NAME).sc"' $@ 1<>$@
endif
ifneq ($(strip $(FWPORTS)),)
# e.g. FWPORTS=src/foo.sc
	@jq --arg file $(FWPORTS) \
		'."port-config"."protocol-file" = "$(DSM_UI_DIR)/"+($$file | split("/")[-1])' $@ 1<>$@
endif
ifneq ($(strip $(SPK_COMMANDS)),)
# e.g. SPK_COMMANDS=bin/foo bin/bar
	@jq --arg binaries '$(SPK_COMMANDS)' \
		'."usr-local-linker" = {"bin": $$binaries | split(" ")}' $@ 1<>$@
endif
ifneq ($(strip $(SPK_USR_LOCAL_LINKS)),)
# e.g. SPK_USR_LOCAL_LINKS=etc:var/foo lib:libs/bar
	@jq --arg links_str '${SPK_USR_LOCAL_LINKS}' \
		'."usr-local-linker" += ($$links_str | split (" ") | map(split(":")) | group_by(.[0]) | map({(.[0][0]) : map(.[1])}) | add )' $@ 1<>$@
endif
ifneq ($(strip $(SERVICE_WIZARD_SHARE)),)
# e.g. SERVICE_WIZARD_SHARE=wizard_download_dir
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@jq --arg share "{{${SERVICE_WIZARD_SHARE}}}" --arg user sc-${SPK_USER} \
		'."data-share" = {"shares": [{"name": $$share, "permission":{"rw":[$$user]}} ] }' $@ 1<>$@
endif
endif
SERVICE_FILES += $(DSM_CONF_DIR)/resource
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif

# Less than DSM 6.0
else
ifneq ($(strip $(SPK_COMMANDS) $(SPK_USR_LOCAL_LINKS)),)
	@echo "# List of commands to create links for" >> $@
	@echo "SPK_COMMANDS=\"${SPK_COMMANDS}\"" >> $@
	@echo "SPK_USR_LOCAL_LINKS=\"${SPK_USR_LOCAL_LINKS}\"" >> $@
	@cat $(SPKSRC_MK)spksrc.service.create_links >> $@
endif
endif


DSM_SCRIPT_FILES += service-setup
SERVICE_FILES += $(DSM_SCRIPTS_DIR)/service-setup


# Control use of generic installer
ifeq ($(strip $(INSTALLER_SCRIPT)),)
DSM_SCRIPT_FILES += installer
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
$(DSM_SCRIPTS_DIR)/installer: $(SPKSRC_MK)spksrc.service.installer.dsm7
	@$(dsm_script_copy)
else ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
$(DSM_SCRIPTS_DIR)/installer: $(SPKSRC_MK)spksrc.service.installer.dsm6
	@$(dsm_script_copy)
else
$(DSM_SCRIPTS_DIR)/installer: $(SPKSRC_MK)spksrc.service.installer.dsm5
	@$(dsm_script_copy)
endif
endif


# Control use of generic start-stop-status scripts
ifeq ($(strip $(SSS_SCRIPT)),)
DSM_SCRIPT_FILES += start-stop-status
ifeq ($(STARTABLE),no)
$(DSM_SCRIPTS_DIR)/start-stop-status: $(SPKSRC_MK)spksrc.service.non-startable
	@$(dsm_script_copy)
else ifneq ($(strip $(SERVICE_EXE)),)
$(DSM_SCRIPTS_DIR)/start-stop-status: $(SPKSRC_MK)spksrc.service.start-stop-daemon
	@$(dsm_script_copy)
else
$(DSM_SCRIPTS_DIR)/start-stop-status: $(SPKSRC_MK)spksrc.service.start-stop-status
	@$(dsm_script_copy)
endif
endif


# Generate privilege file for service user (prefixed to avoid collision with busybox account)
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
$(DSM_CONF_DIR)/privilege:
	$(create_target_dir)
	@jq -n '."defaults" = {"run-as": "package"}' > $@
	@$(MSG) "Creating $@"
	@$(MSG) '(privilege) run-as: package'
	@$(MSG) "(privilege) DSM >= 7 $(DSM_CONF_DIR)/privilege"
# Apply variables to privilege file
ifneq ($(strip $(GROUP)),)
# Creates group but is different from the groups the user can create, they are invisible in the UI an are only usefull to access another packages permissions (ffmpeg comes to mind)
# For DSM7 I recommend setting permissions for individual packages (System Internal User)
# or use the shared folder resource worker to add permissions, ask user from wizard see transmission package for an example
	@jq --arg packagename $(GROUP) '."join-pkg-groupnames" += [{$$packagename}]' $@ 1<>$@
endif
ifneq ($(strip $(SYSTEM_GROUP)),)
# options: http, system
	@jq '."join-groupname" = "$(SYSTEM_GROUP)"' $@ 1<>$@
endif
ifneq ($(strip $(SPK_USER)),)
	@jq '."username" = "sc-$(SPK_USER)"' $@ 1<>$@
	@jq '."groupname" = "sc-$(SPK_USER)"' $@ 1<>$@
endif
ifneq ($(strip $(SPK_GROUP)),)
	@jq '."groupname" = "$(SPK_GROUP)"' $@ 1<>$@
endif
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif

# DSM <= 6 and SERVICE_USER defined
else ifneq ($(strip $(SERVICE_USER)),)
ifeq ($(strip $(SERVICE_EXE)),)
$(DSM_CONF_DIR)/privilege: $(SPKSRC_MK)spksrc.service.privilege-installasroot
	@$(dsm_script_copy)
	@$(MSG) "(privilege) spksrc.service.privilege-installasroot"
else
$(DSM_CONF_DIR)/privilege: $(SPKSRC_MK)spksrc.service.privilege-startasroot
	@$(dsm_script_copy)
	@$(MSG) "(privilege) spksrc.service.privilege-startasroot"
endif
ifneq ($(strip $(SYSTEM_GROUP)),)
# options: http, system
	@jq '."join-groupname" = "$(SYSTEM_GROUP)"' $@ 1<>$@
endif
ifneq ($(strip $(SPK_USER)),)
	@jq '."username" = "sc-$(SPK_USER)"' $@ 1<>$@
endif
ifneq ($(strip $(SPK_GROUP)),)
	@jq '."groupname" = "$(SPK_GROUP)"' $@ 1<>$@
endif
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif

# DSM <= 6 and SERVICE_USER is NOT defined
else
$(DSM_CONF_DIR)/privilege:
	@$(MSG) "NOT creating $@"
	@$(MSG) "(privilege) DSM <= 6 and SERVICE_USER undefined"
endif

# Call $(DSM_CONF_DIR)/privilege:
SERVICE_FILES += $(DSM_CONF_DIR)/privilege


# Generate service configuration for admin port
ifeq ($(strip $(FWPORTS)),)
ifneq ($(strip $(SERVICE_PORT)),)
$(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc:
	$(create_target_dir)
	@echo "[$(SPK_NAME)]" > $@
ifneq ($(strip $(SERVICE_PORT_TITLE)),)
	@echo "title=\"$(SERVICE_PORT_TITLE)\"" >> $@
else
	@echo "title=\"$(SPK_NAME)\"" >> $@
endif
ifneq ($(strip $(DISPLAY_NAME)),)
	@echo "desc=\"$(DISPLAY_NAME)\"" >> $@
else
	@echo "desc=\"$(SPK_NAME)\"" >> $@
endif
	@echo "port_forward=\"yes\"" >> $@
	@echo "dst.ports=\"${SERVICE_PORT}/tcp\"" >> $@
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif
SERVICE_FILES += $(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc
endif
else
$(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc: $(filter %.sc,$(FWPORTS))
	@$(dsm_script_copy)
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif
SERVICE_FILES += $(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc
endif

# Generate DSM UI configuration
ifneq ($(strip $(SPK_ICON)),)
ifneq ($(strip $(SERVICE_PORT)),)
ifeq ($(strip $(NO_SERVICE_SHORTCUT)),)
# Set some defaults
ifeq ($(strip $(SERVICE_URL)),)
SERVICE_URL=/
endif
ifeq ($(strip $(SERVICE_PORT_PROTOCOL)),)
SERVICE_PORT_PROTOCOL=http
endif
ifeq ($(strip $(SERVICE_PORT_ALL_USERS)),)
SERVICE_PORT_ALL_USERS=true
endif

$(STAGING_DIR)/$(DSM_UI_DIR)/config:
	$(create_target_dir)
	@echo '{ ".url": { ' > $@
	@echo "  \"com.synocommunity.packages.${SPK_NAME}\": {" >> $@
	@echo "    \"title\": \"${DISPLAY_NAME}\"," >> $@
	@/bin/echo -n "    \"desc\": \"" >> $@
	@/bin/echo -n "${DESCRIPTION}" | sed -e 's/\\//g' -e 's/"/\\"/g' >> $@
	@echo "\",\n    \"icon\": \"images/${SPK_NAME}-{0}.png\"," >> $@
	@echo "    \"type\": \"url\"," >> $@
	@echo "    \"protocol\": \"${SERVICE_PORT_PROTOCOL}\"," >> $@
	@echo "    \"port\": \"${SERVICE_PORT}\"," >> $@
	@echo "    \"url\": \"${SERVICE_URL}\"," >> $@
	@echo "    \"allUsers\": ${SERVICE_PORT_ALL_USERS}," >> $@
	@echo "    \"grantPrivilege\": \"all\"," >> $@
	@echo "    \"advanceGrantPrivilege\": true" >> $@
	@echo '} } }' >> $@
	cat $@ | python -m json.tool > /dev/null

SERVICE_FILES += $(STAGING_DIR)/$(DSM_UI_DIR)/config
endif
endif
endif

service_target: $(PRE_SERVICE_TARGET) $(SERVICE_FILES)

post_service_target: $(SERVICE_TARGET)

service: $(POST_SERVICE_TARGET)
