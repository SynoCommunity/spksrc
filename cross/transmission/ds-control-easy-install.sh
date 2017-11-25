#! /bin/sh
rootFolder="$1/share/transmission"
webFolder=""
sharefolder=""
orgindex="index.original.html"
index="index.html"
tmpFolder="/tmp/tr-web-control/"
packname="transmission-control-full.tar.gz"
oldpackname="transmission-web-control.tar.gz"
host="https://github.com/hitechbeijing/transmission-web-control/raw/master/release/"
downloadurl="$host$oldpackname"
downloadurlfull="$host$packname"

if [ ! -d "$tmpFolder" ]; then
	cd /tmp
	mkdir tr-web-control
fi
cd "$tmpFolder"


if [ -d "$rootFolder" ]; then
	webFolder="$rootFolder""web/"
	folderIsExist=1
fi

if [ $folderIsExist = 1 ]; then
	echo "Downloading and Installing Transmission Web Control..."
	wget "$downloadurl"
	tar -xzf "$oldpackname"
	mv "$tmpFolder/web/$index" "$tmpFolder/web/$orgindex"
	rm "$oldpackname"
	wget "$downloadurlfull"
	tar -xzf "$packname"
	rm "$packname"
	cp -r "$tmpFolder/web" "$rootFolder"
	#cd "$rootFolder"
	#chown DownloadStation:DownloadStation web
	#cd "$rootFolder/web"
	#chown -R DownloadStation:DownloadStation *
	#chown DownloadStation:DownloadStation *
else
	echo "#######################################################"
	echo "#"
	echo "# ERROR : Transmission  install target is missing."
	echo "#"
	echo "#######################################################"
fi

rm -rf "$tmpFolder"

