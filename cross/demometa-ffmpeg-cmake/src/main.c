#include <stdio.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>

/* Links against libavcodec/libavformat, resolved via pkg-config from the ffmpeg
 * meta package, proving the ordered PKG_CONFIG_LIBDIR reached this cross build. */
int main(void)
{
    printf("demometa-ffmpeg-cmake: avcodec=%u avformat=%u\n",
           avcodec_version(), avformat_version());
    return 0;
}
