
TC_NAME = syno-cedarview

TC_DIST_NAME = gcc421_glibc236_x86_cedarview-GPL.tgz

TC_EXT = tgz
TC_DIST_SITE = http://sourceforge.net/projects/dsgpl/files/DSM%204.0%20Tool%20Chains/Intel%20x86%20Linux%202.6.32%20%28Cedarview%29

TC_BASE_DIR = i686-linux-gnu
TC_PREFIX = i686-linux-gnu
TC_TARGET = i686-linux-gnu

# gcc 4.7 lists 'atom' as "64-bit extensions, MMX, SSE, SSE2, SSE3 and SSSE3"
# gcc 4.2 lists 'nocona' as "64-bit extensions, MMX, SSE, SSE2, SSE3 and SSSE3"
TC_CFLAGS = -O3 -march=nocona -mtune=nocona
TC_LDFLAGS =

include ../../mk/spksrc.tc.mk
