###############################################################################
# spksrc.toolchain/tc-version.mk
#
# Maps Synology OS versions to toolchain metadata.
#
# Each entry in TC_VERSION_MAP defines:
#  <OS version> : <build> : <OS type> : <toolchain source>
#
# Used to derive:
#  - TC_BUILD
#  - TC_TYPE (DSM / SRM)
#  - toolchain download origin
#
###############################################################################

TC_VERSION_MAP = \
    1.1:6931:SRM:na \
    1.2:7742:SRM:github.com/SynoCommunity/spksrc \
    1.3:9193:SRM:github.com/SynoCommunity/spksrc \
    4.0:2198:DSM:na \
    4.1:2636:DSM:na \
    4.2:3202:DSM:na \
    4.3:3776:DSM:na \
    5.0:4458:DSM:na \
    5.1:5004:DSM:na \
    5.2:5644:DSM:github.com/SynoCommunity/spksrc \
    6.0:7321:DSM:na \
    6.0.2:8451:DSM:na \
    6.1:15284:DSM:global.synologydownload.com \
    6.2:22259:DSM:na \
    6.2.2:24922:DSM:na \
    6.2.3:25423:DSM:na \
    6.2.4:25556:DSM:github.com/SynoCommunity/spksrc \
    7.0:41890:DSM:global.synologydownload.com \
    7.1:42661:DSM:global.synologydownload.com \
    7.2:72806:DSM:global.synologydownload.com
