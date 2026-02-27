###############################################################################
# spksrc.kernel/version.mk
#
# Maps Synology OS versions to kernel metadata.
#
# Each entry in KERNEL_VERSION_MAP defines:
#  <OS version> : <build> : <OS type> : <kernel source>
#
# Used to derive:
#  - KERNEL_BUILD
#  - KERNEL_TYPE (DSM / SRM)
#  - kernel download origin
#
###############################################################################

KERNEL_VERSION_MAP = \
    1.2:7742:SRM:github.com/SynoCommunity/spksrc \
    1.3:9193:SRM:github.com/SynoCommunity/spksrc \
    5.2:5644:DSM:github.com/SynoCommunity/spksrc \
    6.1:15284:DSM:global.synologydownload.com \
    6.2.4:25556:DSM:github.com/SynoCommunity/spksrc \
    7.0:41890:DSM:global.synologydownload.com \
    7.1:42661:DSM:global.synologydownload.com \
    7.2:72806:DSM:global.synologydownload.com \
    7.3:86009:DSM:global.synologydownload.com
