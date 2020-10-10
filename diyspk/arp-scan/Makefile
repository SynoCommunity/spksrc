SPK_NAME = arp-scan
SPK_VERS = 1.9.7
SPK_REV = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = hgy59
DESCRIPTION = Command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received. 
DISPLAY_NAME = arp-scan
STARTABLE = no

HOMEPAGE = http://www.royhills.co.uk/wiki/index.php/Arp-scan_User_Guide
LICENSE  = MIT

SPK_COMMANDS = bin/arp-scan 
# perl scripts (work only when perl package is installed)
SPK_COMMANDS += bin/arp-fingerprint bin/get-iab bin/get-oui

include ../../mk/spksrc.spk.mk
