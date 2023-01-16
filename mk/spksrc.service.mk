### Service rules
# Generate service support files in SPK:
#   scripts/installer
#   scripts/start-stop-status
#   scripts/service-setup
#   conf/privilege         if SERVICE_USER or DSM7
#   conf/SPK_NAME.sc       if SERVICE_PORT and DSM<7
#   conf/resource          if SERVICE_CERT or DSM7
#   app/SPK_NAME.sc        if SERVICE_PORT and DSM7
#   app/config             if DSM_UI_DIR (may be overwritten by DSM_UI_CONFIG)
#
# Targets are executed in the following order:
#  service_msg_target
#  pre_service_target            (override with PRE_SERVICE_TARGET)
#  service_target                (override with SERVICE_TARGET)
#  post_service_target           (override with POST_SERVICE_TARGET)
#
# Variables:
#  SERVICE_SETUP                 service-setup script file for generic installer
#  FWPORTS                       (optional) custom firewall port/rules file
#  SERVICE_PORT                  service port firewall config file (*.sc) and dsm-ui config file
#  SERVICE_PORT_PROTOCOL         service port protocol for dsm-ui config file, default = "http"
#  SERVICE_PORT_ALL_USERS        service port access for all users for dsm-ui config file, default = "true"
#  SERVICE_CERT                  (optional) configure DSM certificate management for this service name from the firewall config file (*.sc)
#  SERVICE_CERT_RELOAD           (optional) package-relative path to a script for reloading the service after certificate changes
#  SERVICE_TYPE                  service type for dsm-ui config file, default = "url"
#  SERVICE_WIZARD_GROUP          (optional) use name of wizard-variable to define the GROUP
#  SERVICE_WIZARD_SHARE          (optional) use name of wizard-varible to define SHARE_PATH (uses DSM data share worker for DSM 7)
#  USE_DATA_SHARE_WORKER         (optional) use DSM data share worker for SERVICE_WIZARD_SHARE and DSM 6 too
#  SERVICE_USER                  (optional) runtime user account for generic service support.
#                                "auto" is the only value supported with DSM 7 and defines sc-${SPK_NAME} as service user.
#  SPK_GROUP                     (optional) defines the group to use in privilege resource file
#  SYSTEM_GROUP                  (optional) defines an additional group to join in privilege resource file
#  STARTABLE                     default = yes, must be "no" for packages that do not create a service (command line tools)
#  SERVICE_COMMAND               service command, to be used with generic service support
#  SERVICE_EXE                   (deprecated) service command, implemented with busybox start-stop-daemon
#  SPK_COMMANDS                  (optional) list of "folder/command" to create links for in folder /usr/local
#  SPK_USR_LOCAL_LINKS           (optional) list of "folder:command" to create links for in folder /usr/local
#                                           with 'command' in relative folder
#  USE_ALTERNATE_TMPDIR          (optional) with USE_ALTERNATE_TMPDIR=1 TMD_DIR is defined to use a package specific temp
#                                           folder at intallation and runtime.
#  SSS_SCRIPT                    (optional) custom script file for service start/stop/status when the generic
#                                           installer generated script (SERVICE_SETUP) is not usable.
#  NO_SERVICE_SHORTCUT           (optional) do not create an app icon in the DSM desktop
#  INSTALLER_SCRIPT              (deprecated) installer script file before introduction of generic installer
#

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
ifneq ($(strip $(SERVICE_WIZARD_SHARE)),)
# always use data share worker on DSM >= 7
USE_DATA_SHARE_WORKER = yes
endif
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
	@echo "### Generic variables and functions" > $@
	@echo '### -------------------------------' >> $@
	@echo '' >> $@
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
	@echo "# DSM shared folder location from UI if provided" >> $@
	@echo 'if [ -n "$${$(SERVICE_WIZARD_SHARE)}" ]; then SHARE_PATH="$${$(SERVICE_WIZARD_SHARE)}"; fi' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_PORT)),)
	@echo "# Service port" >> $@
	@echo 'SERVICE_PORT="$(SERVICE_PORT)"' >> $@
	@echo '' >> $@
endif
ifneq ($(strip $(SERVICE_CERT)),)
	@echo "# Certificate for service" >> $@
	@echo 'SERVICE_CERT="$(SERVICE_CERT)"' >> $@
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
	@echo "# Service command to execute" >> $@
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
	@echo '' >> $@
	@echo '### Package specific variables and functions' >> $@
	@echo '### ----------------------------------------' >> $@
	@echo '' >> $@
	@cat $(CURDIR)/$(SERVICE_SETUP) >> $@
endif

# Define resources for
# - firewall rules/port definitions (DSM >= 6.0-5936)
# - data share worker (DSM 7, optional for DSM 6)
# - usr local links (DSM >= 6.0-5941)
# - certificate config (DSM < 7, restricted to only Synology's packages since DSM 7)
# for DSM<6.0 link creation is provided by spksrc.service.create_links
# and other facilities are defined in the generic installer (spksrc.service.installer.dsm5)
ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
$(DSM_CONF_DIR)/resource:
	$(create_target_dir)
	@$(MSG) "Creating $@"
	@echo '{}' > $@
ifneq ($(strip $(SERVICE_PORT)),)
	@jq '."port-config"."protocol-file" = "$(DSM_UI_DIR)/$(SPK_NAME).sc"' $@ | sponge $@
endif
ifneq ($(strip $(FWPORTS)),)
# e.g. FWPORTS=src/foo.sc
	@jq --arg file $(FWPORTS) \
		'."port-config"."protocol-file" = "$(DSM_UI_DIR)/"+($$file | split("/")[-1])' $@ | sponge $@
endif
ifneq ($(strip $(SPK_COMMANDS)),)
# e.g. SPK_COMMANDS=bin/foo bin/bar
	@jq --arg binaries '$(SPK_COMMANDS)' \
		'."usr-local-linker" = {"bin": $$binaries | split(" ")}' $@ | sponge $@
endif
ifneq ($(strip $(SPK_USR_LOCAL_LINKS)),)
# e.g. SPK_USR_LOCAL_LINKS=etc:var/foo lib:libs/bar
	@jq --arg links_str '${SPK_USR_LOCAL_LINKS}' \
		'."usr-local-linker" += ($$links_str | split (" ") | map(split(":")) | group_by(.[0]) | map({(.[0][0]) : map(.[1])}) | add )' $@ | sponge $@
endif
ifneq ($(strip $(SERVICE_WIZARD_SHARE)),)
# e.g. SERVICE_WIZARD_SHARE=wizard_download_dir, for DSM 6 with USE_DATA_SHARE_WORKER = yes
ifeq ($(strip $(USE_DATA_SHARE_WORKER)),yes)
	@jq --arg share "{{${SERVICE_WIZARD_SHARE}}}" --arg user sc-${SPK_USER} \
		'."data-share" = {"shares": [{"name": $$share, "permission":{"rw":[$$user]}} ] }' $@ | sponge $@
endif
endif
ifneq ($(strip $(SERVICE_CERT)),)
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
	@jq --arg service "${SERVICE_CERT}" \
	    --arg reload "${SERVICE_CERT_RELOAD}" \
	    --arg display_name "${DISPLAY_NAME}" \
		'."certificate-config" = {"services": [{"display_name": $$display_name, "display_name_i18n": $$display_name, "service":$$service} ], "reloader-relpath": $$reload } | ."service-cfg" = {}' $@ | sponge $@
else
	$(warning Certificate configuration is blocked for community packages in DSM $(TCVERSION))
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
DSM_SCRIPT_FILES += functions
$(DSM_SCRIPTS_DIR)/functions: $(SPKSRC_MK)spksrc.service.installer.functions
	@$(dsm_script_copy)

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
ifneq ($(strip $(SYSTEM_GROUP)),)
# options: http, system
	@jq '."join-groupname" = "$(SYSTEM_GROUP)"' $@ | sponge $@
endif
ifneq ($(strip $(SPK_USER)),)
	@jq '."username" = "sc-$(SPK_USER)"' $@ | sponge $@
endif
ifneq ($(strip $(GROUP)),)
	@jq '."groupname" = "$(GROUP)"' $@ | sponge $@
else
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	@jq '."groupname" = "synocommunity"' $@ | sponge $@
else
	@jq '."groupname" = "sc-$(SPK_USER)"' $@ | sponge $@
endif
endif
ifneq ($(findstring conf,$(SPK_CONTENT)),conf)
SPK_CONTENT += conf
endif

# DSM <= 6 and SERVICE_USER defined
else ifneq ($(strip $(SERVICE_USER)),)
ifeq ($(strip $(SERVICE_EXE)),)
$(DSM_CONF_DIR)/privilege: $(SPKSRC_MK)spksrc.service.privilege-installasroot
	@$(dsm_resource_copy)
	@$(MSG) "(privilege) spksrc.service.privilege-installasroot"
else
$(DSM_CONF_DIR)/privilege: $(SPKSRC_MK)spksrc.service.privilege-startasroot
	@$(dsm_resource_copy)
	@$(MSG) "(privilege) spksrc.service.privilege-startasroot"
endif
ifneq ($(strip $(SYSTEM_GROUP)),)
# options: http, system
	@jq '."join-groupname" = "$(SYSTEM_GROUP)"' $@ | sponge $@
endif
ifneq ($(strip $(SPK_USER)),)
	@jq '."username" = "sc-$(SPK_USER)"' $@ | sponge $@
endif
ifneq ($(strip $(SPK_GROUP)),)
	@jq '."groupname" = "$(SPK_GROUP)"' $@ | sponge $@
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
SERVICE_FILES += $(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc
endif
else
$(STAGING_DIR)/$(DSM_UI_DIR)/$(SPK_NAME).sc: $(filter %.sc,$(FWPORTS))
	@$(dsm_resource_copy)

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
ifeq ($(strip $(SERVICE_TYPE)),)
SERVICE_TYPE=url
endif

DESC=$(shell echo ${DESCRIPTION} | sed -e 's/\\//g' -e 's/"/\\"/g')
$(STAGING_DIR)/$(DSM_UI_DIR)/config:
	$(create_target_dir)
ifneq ($(wildcard $(DSM_UI_CONFIG)),)
	cat $(DSM_UI_CONFIG) > $@
else
	@echo '{}' | jq --arg name "${DISPLAY_NAME}" \
		--arg desc "${DESC}" \
		--arg id "com.synocommunity.packages.${SPK_NAME}" \
		--arg icon "images/${SPK_NAME}-{0}.png" \
		--arg prot "${SERVICE_PORT_PROTOCOL}" \
		--arg port "${SERVICE_PORT}" \
		--arg url "${SERVICE_URL}" \
		--arg type "${SERVICE_TYPE}" \
		--argjson allUsers ${SERVICE_PORT_ALL_USERS} \
		'{".url":{($$id):{"title":$$name, "desc":$$desc, "icon":$$icon, "type":$$type, "protocol":$$prot, "port":$$port, "url":$$url, "allUsers":$$allUsers, "grantPrivilege":"all", "advanceGrantPrivilege":true}}}' > $@
endif
SERVICE_FILES += $(STAGING_DIR)/$(DSM_UI_DIR)/config
endif
endif
endif

service_target: $(PRE_SERVICE_TARGET) $(SERVICE_FILES)

post_service_target: $(SERVICE_TARGET)

service: $(POST_SERVICE_TARGET)
