#include <stdio.h>
#include <zstd.h>
#include <dbus/dbus.h>

/* Resolves libzstd (python meta) AND dbus-1 (videodriver meta) in a single
 * build, proving the ordered PKG_CONFIG_LIBDIR accumulates multiple metas. */
int main(void)
{
    int maj = 0, min = 0, mic = 0;
    dbus_get_version(&maj, &min, &mic);
    printf("demometa-all: zstd=%u (python) dbus=%d.%d.%d (videodriver)\n",
           (unsigned)ZSTD_versionNumber(), maj, min, mic);
    return 0;
}
