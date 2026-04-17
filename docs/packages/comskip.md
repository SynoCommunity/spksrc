# Comskip

[Comskip](https://www.kaashoek.com/comskip/) is a commercial detector. It is a console application that reads a mpeg or h.264 file and analyses the content based on a large amount of configurable parameters.

After analysis, it generates a file in various possible formats containing the location of the commercials inside the video file. The formats include input files for interactive video editors (VideoRedo, Cuttermaran, Mpeg2Schnitt...), command line video cutters (mpgtx, cuttermaran, mencoder) and video players (zoomplayer, mplayer, etc.).

Comskip can read MPEG PS, TS, DVR-MS and WTV files up to HD resolution (max 2000x1200) at various framerates (PAL and NTSC). **Comskip cannot read copy protected recordings**.

## Usage

After installation, launch comskip from the command line:

```bash
comskip /volume1/@appstore/comskip/bin/comskip.ini "path to your video file"
```

The default configuration is located at `/volume1/@appstore/comskip/bin/comskip.ini`.

After Comskip has finished, test if it detects the commercial breaks correctly and adjust the config (comskip.ini) as needed.

More information about configuring Comskip can be found in the [tuning guide](http://www.kaashoek.com/files/tuning.htm).

## TVHeadend Integration

Comskip is an excellent tool to use with TVHeadend for post-processing recordings.

Create a shell script like this:

```bash
#!/bin/sh

INPUTVIDEO="$1"  # Full path to recording

BASENAME=`/usr/bin/basename $INPUTVIDEO .mkv`
DIRNAME=`/usr/bin/dirname $INPUTVIDEO`
EDLFILE="$DIRNAME/$BASENAME.edl"
LOGFILE="$DIRNAME/$BASENAME.log"
TXTFILE="$DIRNAME/$BASENAME.txt"
COMSKIPPATH="/volume1/@appstore/comskip/bin/comskip"
COMSKIPINI="/volume1/@appstore/comskip/var/comskip.ini"
COMSKIPLOGS="/volumeUSB1/usbshare/logs/comskip"
TVHEADENDPP="/volumeUSB1/usbshare/logs/tvheadend"

CreateLog() {
    echo "***** CREATE LOG *****" >> ${TVHEADENDPP}/tvheadendpp$$.log
    echo "***** INPUT = $INPUTVIDEO *****" >> ${TVHEADENDPP}/tvheadendpp$$.log
}

FlagCommercials() {
    echo "Starting Commercial Flagging" >> ${TVHEADENDPP}/tvheadendpp$$.log
    echo "Started at `/bin/date`" >> ${TVHEADENDPP}/tvheadendpp$$.log
    $COMSKIPPATH --ini=$COMSKIPINI $INPUTVIDEO 2>&1 </dev/null >> ${TVHEADENDPP}/tvheadendpp$$.log
    echo "EDL for $INPUTVIDEO:" >> ${TVHEADENDPP}/tvheadendpp$$.log
}

CleanUp() {
    /bin/mv $LOGFILE $COMSKIPLOGS
    /bin/mv $TXTFILE $COMSKIPLOGS
}      

CreateLog
FlagCommercials
CleanUp

echo "Finished at `/bin/date`" >> ${TVHEADENDPP}/tvheadendpp$$.log
```

Use `/path/to/script.sh %f` in your post-processing recording settings in TVHeadend.

## Resources

- [Comskip homepage](http://www.kaashoek.com/files/manual.htm)
- [Comskip tuning guide](http://www.kaashoek.com/files/tuning.htm)
- [TVHeadend post-recording instructions](https://tvheadend.org/projects/tvheadend/wiki/Tvheadend_post_recording_scripts)
