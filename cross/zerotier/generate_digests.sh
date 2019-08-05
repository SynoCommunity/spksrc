wget https://github.com/zerotier/ZeroTierOne/archive/$1.tar.gz

rm -rf digests

echo -e "$1.tar.gz SHA1 $(sha1sum $1.tar.gz | awk '{ print $1 }')" >> digests
echo -e "$1.tar.gz SHA256 $(sha256sum $1.tar.gz | awk '{ print $1 }')" >> digests
echo -e "$1.tar.gz MD5 $(md5sum $1.tar.gz | awk '{ print $1 }')" >> digests

rm -rf $1.tar.gz
