# GStreamer

[GStreamer](https://gstreamer.freedesktop.org/) is a pipeline-based multimedia framework.

## Documentation

- [Plugins](https://gstreamer.freedesktop.org/documentation/plugins_doc.html?gi-language=c)
- [Tools](https://gstreamer.freedesktop.org/documentation/tutorials/basic/gstreamer-tools.html?gi-language=c)

## Basic Testing

### Plugin Listing

Show the list of codec plugins available:

```bash
/var/packages/gstreamer/target/bin/gst-inspect-1.0
```

Output:
```
accurip:  accurip: AccurateRip(TM) CRC element
adder:  adder: Adder
adpcmdec:  adpcmdec: ADPCM decoder
adpcmenc:  adpcmenc: ADPCM encoder
aiff:  aiffmux: AIFF audio muxer
aiff:  aiffparse: AIFF audio demuxer
...
```

### Plugin Details

Show details of a specific codec plugin (e.g., specific to x86_64):

```bash
/var/packages/gstreamer/target/bin/gst-inspect-1.0 svthevcenc
```

Output:
```
Factory Details:
  Rank                     primary (256)
  Long-name                svthevcenc
  Klass                    Codec/Encoder/Video
  Description              Scalable Video Technology for HEVC Encoder (SVT-HEVC Encoder)
  Author                   Yeongjin Jeong <yeongjin.jeong@navercorp.com>

Plugin Details:
  Name                     svthevcenc
  Description              svt-hevc encoder based H265 plugins
  Filename                 /var/packages/gstreamer/target/lib/gstreamer-1.0/libgstsvthevcenc.so
  Version                  1.20.5
...
```

### Media Information

Get media information:

```bash
/var/packages/gstreamer/target/bin/gst-discoverer-1.0 https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm -v
```

Output:
```
Analyzing https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm
Done discovering https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm

Properties:
  Duration: 0:00:52.250000000
  Seekable: yes
  Live: no
  Tags: 
      datetime: 2012-04-11T16:08:01Z
      container format: Matroska
      language code: en
      title: Audio
...
```
