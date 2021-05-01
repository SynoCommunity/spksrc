SPK_NAME = duplicity
SPK_VERS = 0.8.19
SPK_REV = 7
SPK_ICON = src/duplicity.png

BUILD_DEPENDS = cross/python38
DEPENDS = cross/cffi cross/lxml cross/duplicity cross/duply

WHEELS = src/requirements.txt

SPK_DEPENDS = "python38>=3.8.8:gnupg>=2.1.6"

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v0.8.19 and duply to v2.3.1</br>2. Update to Python 3.8</br>3. Add supported backend libraries: <ul><li>azure-storage-blob</li><li>b2sdk</li><li>boto</li><li>boto3</li><li>boxsdk[jwt]</li><li>dropbox</li><li>google_auth_oauthlib</li><li>jottalib</li><li>pydrive</li><li>pyrax</li><li>python-swiftclient</li><li>requests_oauthlib</li></ul><br/>4. Update includes a security update urllib3"

HOMEPAGE = http://duplicity.nongnu.org/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

include ../../mk/spksrc.spk.mk
