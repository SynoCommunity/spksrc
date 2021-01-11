SPK_NAME = duplicity
SPK_VERS = 0.8.18
SPK_REV = 7
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python3
DEPENDS = cross/cffi cross/duplicity cross/duply cross/libxml2 cross/libxslt cross/PyNaCl

WHEELS = src/requirements.txt

SPK_DEPENDS = "python3>=3.7.7-15:gnupg>=2.1.6"

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v0.8.18 and duply to v2.3</br>2. Update to Python 3</br>3. Include supported backend libraries: b2sdk, boto, boto3, dropbox, gdata, jottalib, paramiko, paramiko, pydrive, pyrax, python-swiftclient, requests_oauthlib"

HOMEPAGE = http://duplicity.nongnu.org/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply
SPK_LINKS = /usr/local/bin/duplicity:env/bin/duplicity

include ../../mk/spksrc.spk.mk
