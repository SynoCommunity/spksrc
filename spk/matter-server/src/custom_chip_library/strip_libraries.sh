#/bin/bash

# run this script once after update of the custom library files

TOOLCHAIN_ROOT=$(realpath ../../../../toolchain)

if [ ! -d ${TOOLCHAIN_ROOT} ]; then
  echo "This script must be run in spksrc."
  echo "ERROR: Toolchain root folder not found: ${TOOLCHAIN_ROOT}"
  exit 1
fi

STRIP_X64=${TOOLCHAIN_ROOT}/syno-x64-7.1/work/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/bin/strip
STRIP_AARCH64=${TOOLCHAIN_ROOT}/syno-aarch64-7.1/work/aarch64-unknown-linux-gnu/aarch64-unknown-linux-gnu/bin/strip
if [ ! -e "${STRIP_X64}" ]; then
   echo "stip for x64 not available"
   echo "missing ${STRIP_X64}"
   exit 1
else
   ${STRIP_X64} ./x64/_ChipDeviceCtrl.so
   echo "file stripped:"
   file ./x64/_ChipDeviceCtrl.so
fi

if [ ! -e "${STRIP_AARCH64}" ]; then
   echo "stip for aarch64 not available"
   echo "missing ${STRIP_AARCH64}"
   exit 1
else
   ${STRIP_AARCH64} ./aarch64/_ChipDeviceCtrl.so
   echo "file stripped:"
   file ./aarch64/_ChipDeviceCtrl.so
fi
