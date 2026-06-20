#include <stdio.h>
#include <zstd.h>
#include <sqlite3.h>

/* Links against libzstd and sqlite3, resolved via pkg-config from the python
 * meta package, proving the ordered PKG_CONFIG_LIBDIR reached this cross build. */
int main(void)
{
    printf("demometa-python-autotools: zstd=%u sqlite3=%s\n",
           (unsigned)ZSTD_versionNumber(), sqlite3_libversion());
    return 0;
}
