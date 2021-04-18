#!/bin/bash

# generate the digests file containing all supported archs
# As arch specific sources are used, we need a digests file that contains
# the checksums for different file names.

# PKG_ARCH is one of:       amd64 armhf arm64   armel  i386
# corresponding ARCHs are:  x64   armv7 aarch64 hi3535 evansport

# 'make digests' must have a valid TCVERSION to work for specific ARCH
export TCVERSION=6.1

# start with an empty temporary file
tmp_digests=digests.tmp
>${tmp_digests}

for arch in x64 armv7 aarch64 hi3535 evansport; do
  echo "generate digests for ${arch}"
  make digests ARCH=${arch} > /dev/null
  cat digests >> ${tmp_digests}
done

rm -f digests
mv ${tmp_digests} digests

echo ""
echo "Please verify the checksums with original sources."
echo ""
cat digests
