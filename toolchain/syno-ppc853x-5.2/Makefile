TC_ARCH = ppc853x
TC_VERS = 5.2
TC_KERNEL = 2.6.32
TC_GLIBC = 2.8
TC_GCC = 4.3.7

TC_DIST = 853x-gcc4374_eglibc2874_qoriq-GPL
TC_DIST_SITE_URL = https://github.com/SynoCommunity/spksrc/releases/download/
TC_DIST_SITE_PATH = toolchains%2Fdsm5.2

TC_TARGET = powerpc-none-linux-gnuspe
# Same layout as 88f6281-5.2: the sysroot is <target>/libc, holding usr/include and
# usr/lib (crt1.o, crti.o, libc.so). TC_SYSROOT pointed one level up at the tooldir,
# whose only entries are bin/ and libc/, so the derived TC_INCLUDE and TC_LIBRARY
# named directories that do not exist. The stock gcc never noticed -- it resolves
# headers and startfiles through its own baked-in sysroot and simply ignored the
# bogus -I/-L -- but the gcc-8.5 overlay is handed the sysroot explicitly, and
# pointing it at the tooldir leaves the linker unable to find crt1.o.
TC_SYSROOT = $(TC_TARGET)/libc
TC_LIBRARY = $(TC_SYSROOT)/usr/lib
TC_EXTRA_BUILD_FLAGS = -mcpu=8548 -mhard-float -mfloat-gprs=double

# glibc 2.8 predates clock_gettime in libc (2.17); the target has no native 64-bit atomics.
# -latomic is dropped automatically when the gcc does not ship it.
TC_EXTRA_LDFLAGS = -lrt -latomic

include ../../mk/spksrc.toolchain.mk
