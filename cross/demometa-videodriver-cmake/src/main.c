#include <stdio.h>
#include <dbus/dbus.h>

/* Links against dbus-1, resolved via pkg-config from the videodriver meta
 * package, proving the ordered PKG_CONFIG_LIBDIR reached this cross build. */
int main(void)
{
    int maj = 0, min = 0, mic = 0;
    dbus_get_version(&maj, &min, &mic);
    printf("demometa-videodriver-cmake: dbus=%d.%d.%d\n", maj, min, mic);
    return 0;
}
