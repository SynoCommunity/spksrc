SPK_NAME = mono
SPK_VERS = 3.10.0
SPK_REV = 4
SPK_ICON = src/mono.png

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Mono is a software platform designed to allow developers to easily create cross platform applications. It is an open source implementation of Microsoft's .NET Framework based on the ECMA standards for C# and the Common Language Runtime. We feel that by embracing a successful, standardized software platform, we can lower the barriers to producing great applications for Linux.
DESCRIPTION_FRE = Mono est une plateforme logicielle conçue pour permettre aux développeurs de créer facilement des applications multiplateformes. Il s agit d une mise en œuvre de Microsofts. Net Framework basé sur les normes ECMA pour C # et le Common Language Runtime open source. Nous pensons qu'en adoptant une plate-forme de logiciel de succès, standardisé, nous pouvons réduire les obstacles à la production de grandes applications pour Linux.
DESCRIPTION_SPN = Mono es una plataforma de software diseñada para permitir a los desarrolladores crear fácilmente aplicaciones de plataforma cruzada. Es una implementación de código abierto de Microsoft de. Net Framework basado en los estándares ECMA para C # y el Common Language Runtime. Creemos que al abrazar una exitosa plataforma de software estandarizada, podemos bajar las barreras a la producción de grandes aplicaciones para Linux.
RELOAD_UI = yes
DISPLAY_NAME = Mono
STARTABLE = no
CHANGELOG = "No longer in beta"

HOMEPAGE = http://mono-project.com/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mono_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

MONO_NATIVE_INSTALL = $(WORK_DIR)/../../../native/$(SPK_NAME)/work-native/install

include ../../mk/spksrc.spk.mk

.PHONY: mono_extra_install
mono_extra_install:
	install -m 755 -d $(STAGING_DIR)/lib
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/lib $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/etc/mono
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/etc/mono $(STAGING_DIR)/etc/
	install -m 755 -d $(STAGING_DIR)/bin
	cp -nR $(MONO_NATIVE_INSTALL)/usr/local/bin $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
