###############################################################################
# spksrc.toolkit/tk-version.mk
#
# Maps Synology OS versions to toolkit metadata.
#
# Each entry in TK_VERSION_MAP defines:
#  <OS version> : <build> : <OS type> : <toolkit source>
#
# Used to derive:
#  - TK_BUILD
#  - TK_TYPE (DSM / SRM)
#  - toolkit download origin
#
###############################################################################

TK_VERSION_MAP = \
    1.3:9193:SRM:global.synologydownload.com \
    6.1:15284:DSM:global.synologydownload.com \
    6.2.4:25556:DSM:global.synologydownload.com \
    7.0:41890:DSM:global.synologydownload.com \
    7.1:42661:DSM:global.synologydownload.com \
    7.2:72806:DSM:global.synologydownload.com \
    7.3:86009:DSM:global.synologydownload.com
