#!/bin/bash

#########################################################################
# Written by: th0ma7@gmail.com
# Part of SynoCommunity Developpers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#########################################################################

# Loads the kernel modules of a SynoCommunity synokernel-* package, by profile:
# one JSON file per device in etc/profiles/<package> of this package, listing
# the modules of that device in load order. The modules each of them depends on
# are read from the module itself and loaded first.

PACKAGES=/var/packages
# This package: its profiles and udev rules
TARGET=$(dirname $(dirname $(readlink -f $0)))
PROFILES_DIR=${TARGET}/etc/profiles
RULES_DIR=${TARGET}/etc/rules.d
FPATH_SYS=/sys/module/firmware_class/parameters/path
LOG=/var/log/packages/synocli-kernelmodule.log

usage() {
   cat <<EOF

Usage: $0 [options] <list|modules|start|stop|restart|status> [module ...]

   list                      the profiles of every synokernel-* package, and
                             whether the package is installed and this kernel
                             has all their modules
   modules                   the modules the profiles and modules given load, in
                             order, and where each comes from; nothing is loaded
   start|stop|restart|status the modules of the profiles, and of the modules given

Options:
   -s, --spk <package>       package holding the modules (default: the one
                             of the profiles)
   -p, --profile <p1,p2,...> profiles to use
   -r, --root <dir>          package target directory (default: $PACKAGES/<package>/target)
   -n, --dry-run             start, stop and restart only tell what they would do
   -v, --verbose             print the modules resolved, and the comments of profiles
   -h, --help                this help

Examples:
   $0 list
   $0 --profile hauppauge-wintv-dualhd-atsc start
   $0 --spk synokernel-usbserial --profile ch341,cp210x status
   $0 --profile hauppauge-wintv-dualhd-atsc modules
   $0 --profile hauppauge-wintv-dualhd-atsc --dry-run start
   $0 --spk synokernel-cdrom sr_mod start

EOF
   warning
}

# Kernel modules are outside of what Synology supports
warning() {
   cat <<EOF >&2
WARNING: the kernel modules of SynoCommunity packages are experimental, and
outside of what Synology supports: use them at your own risk. A module can
crash the NAS, and support is limited. Read the documentation before opening
an issue: https://docs.synocommunity.com/packages/synocli-kernel/
EOF
}

die() { echo "ERROR: $*" >&2; exit 1; }
say() { [ "${VERBOSE}" = "TRUE" ] && echo "$*"; return 0; }

# A module name, as /sys/module and lsmod show it
modname() { local m=${1##*/}; m=${m%.ko}; echo "${m//-/_}"; }

loaded() { [ -d /sys/module/$(modname $1) ]; }

# 0 when $1 <= $2, both dotted versions
ver_le() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" = "$1" ]; }

#------------------------------------------------
# Profiles
#------------------------------------------------

# The profile files of a package, or of every synokernel-* package
profile_files() {
   ls ${PROFILES_DIR}/${SPK:-synokernel-*}/*.json 2>/dev/null
}

# The file of profile $1: fails when it is in no package, or in several
profile_file() {
   local found
   found=$(profile_files | grep "/$1\.json$")
   [ -n "${found}" ] || die "profile [$1] not found, see: $0 list"
   [ $(echo "${found}" | wc -l) -eq 1 ] || die "profile [$1] is in several packages, choose one with --spk: $(echo ${found})"
   echo "${found}"
}

# The package of a profile file: its directory
profile_spk() { basename $(dirname $1); }

# The modules of a profile for the running kernel: those of the first entry of
# "kernels" whose min and max bracket it, else "modules"
profile_modules() {
   local file=$1 min max mods
   while IFS='|' read -r min max mods; do
      [ -n "${min}" ] && ! ver_le "${min}" "${KVER}" && continue
      [ -n "${max}" ] && ! ver_le "${KVER}" "${max}.999" && continue
      echo "${mods}"
      return
   done < <(jq -r '(.kernels // [])[] | "\(.min // "")|\(.max // "")|\(.modules | join(" "))"' "${file}")
   jq -r '(.modules // []) | join(" ")' "${file}"
}

# The modules directory of the running kernel in a package target
kernel_path() { echo "$1/lib/modules/${PLATFORM}/$(uname -r)"; }

# The profiles, available when this kernel has every module they load
list() {
   local file spk root missing state
   for file in $(profile_files); do
      spk=$(profile_spk ${file})
      root=${ROOT:-${PACKAGES}/${spk}/target}
      KPATH=$(kernel_path ${root})
      index_modules
      SEEN="" ; ORDER=""
      for m in $(profile_modules ${file}); do resolve ${m}; done
      missing=$(missing_modules)
      state="available"
      [ -d "${KPATH}" ] || state="n/a (no modules for this kernel)"
      [ -n "${ROOT}" -o -d "${PACKAGES}/${spk}/target" ] || state="n/a (install ${spk})"
      [ "${state}" = "available" ] && [ -n "${missing}" ] && state="n/a (missing: ${missing})"
      printf '%-24s %-32s %-10s %s\n' "${spk:-${ROOT}}" "$(basename ${file} .json)" "${state%% *}" "$(jq -r '.description // ""' ${file})"
      [ "${state}" = "available" ] || echo "      ${state#n/a }"
      if [ "${VERBOSE}" = "TRUE" ]; then
         jq -r '.comments // empty' ${file} | sed 's/^/      /'
         echo "      modules: $(profile_modules ${file})"
      fi
   done
}

#------------------------------------------------
# Modules
#------------------------------------------------

# "<name> <path>" of every .ko of the kernel directory, '-' and '_' being the
# same; built in the main shell, once per directory, as ko_file runs in $(...)
index_modules() {
   [ "${KO_INDEX_OF}" = "${KPATH}" ] && return
   KO_INDEX=$(find ${KPATH} -name '*.ko' 2>/dev/null | awk -F/ '{ n = $NF; sub(/\.ko$/, "", n); gsub(/-/, "_", n); print n, $0 }')
   KO_INDEX_OF=${KPATH}
}

# The .ko of a module in the package
ko_file() {
   echo "${KO_INDEX}" | awk -v n="$(modname $1)" '$1 == n { print $2; exit }'
}

# Where a module of ORDER comes from: the package, DSM's /lib/modules, the
# running kernel (loaded or built in), or nowhere
module_source() {
   local name=$(modname $1)
   if [ -f "$1" ]; then echo "package"
   elif [ -f /lib/modules/${name}.ko -o -f /lib/modules/${name//_/-}.ko ]; then echo "kernel"
   elif loaded ${name}; then echo "kernel (loaded)"
   else echo "missing"
   fi
}

# The modules of ORDER no one provides
missing_modules() {
   local m out=""
   for m in ${ORDER}; do
      [ "$(module_source ${m})" = "missing" ] && out="${out} $(modname ${m})"
   done
   echo ${out}
}

modules() {
   local m
   for m in ${ORDER}; do
      printf '%-40s %-16s %s\n' "$(modname ${m})" "$(module_source ${m})" "$([ -f "${m}" ] && echo "${m#${KPATH}/}")"
   done
   [ -z "$(missing_modules)" ]
}

# Appends to ORDER the modules $1 depends on, then $1: a module of the package
# by its path, one it does not have by its name (one of the kernel's own)
resolve() {
   local name=$(modname $1) ko dep
   case " ${SEEN} " in *" ${name} "*) return;; esac
   SEEN="${SEEN} ${name}"
   ko=$(ko_file $1)
   if [ -n "${ko}" ]; then
      for dep in $(grep -a -o 'depends=[^[:cntrl:]]*' ${ko} | head -1 | cut -d= -f2 | tr ',' ' '); do
         resolve ${dep}
      done
      ORDER="${ORDER} ${ko}"
   else
      ORDER="${ORDER} ${name}"
   fi
}

# One of the kernel's own modules: by modprobe, or from the flat /lib/modules
# of DSM, which modprobe does not index
load_kernel_module() {
   local ko
   modprobe -q $1 2>/dev/null && return 0
   for ko in /lib/modules/$1.ko /lib/modules/${1//_/-}.ko; do
      [ -f ${ko} ] && insmod ${ko} && return 0
   done
   return 1
}

load() {
   local error=0 m
   if [ "${DRYRUN}" = "TRUE" ]; then
      for m in ${ORDER}; do
         printf '%-40s' "$(modname ${m})"
         if loaded ${m}; then echo "already loaded"
         elif [ "$(module_source ${m})" = "missing" ]; then echo "missing"; error=1
         else echo "OK (simulated, $(module_source ${m}))"
         fi
      done
      return ${error}
   fi
   firmware_on
   udev_on
   for m in ${ORDER}; do
      printf '%-40s' "$(modname ${m})"
      if loaded ${m}; then
         echo "already loaded"
      elif [ -f "${m}" ]; then
         insmod ${m} && echo "OK" || { echo "ERROR"; error=1; }
      else
         load_kernel_module ${m} && echo "OK (kernel)" || { echo "ERROR: not in the package nor the kernel"; error=1; }
      fi
   done
   return ${error}
}

# Unloads the modules of the package in reverse order; those another module
# still uses stay loaded, and so do the kernel's own
unload() {
   local error=0 m
   for m in $(echo ${ORDER} | tr ' ' '\n' | tac); do
      [ -f "${m}" ] || continue
      printf '%-40s' "$(modname ${m})"
      if ! loaded ${m}; then
         echo "not loaded"
      elif [ "$(cat /sys/module/$(modname ${m})/refcnt 2>/dev/null)" != "0" ]; then
         echo "in use, left loaded"
      elif [ "${DRYRUN}" = "TRUE" ]; then
         echo "OK (simulated)"
      else
         rmmod $(modname ${m}) && echo "OK" || { echo "ERROR"; error=1; }
      fi
   done
   [ "${DRYRUN}" = "TRUE" ] && return ${error}
   udev_off
   firmware_off
   return ${error}
}

status() {
   local error=0 m
   for m in ${ORDER}; do
      printf '%-40s' "$(modname ${m})"
      loaded ${m} && echo "loaded" || { echo "not loaded"; error=1; }
   done
   return ${error}
}

#------------------------------------------------
# Firmware and udev rules
#------------------------------------------------

# The firmware of the package, through the search path of the kernel where it
# has one, else linked into /lib/firmware
firmware_on() {
   local f
   [ -d "${FPATH}" ] || return 0
   if [ -w ${FPATH_SYS} ]; then
      echo -n "${FPATH}" > ${FPATH_SYS}
   else
      mkdir -p /lib/firmware
      for f in ${FPATH}/*; do
         [ -e /lib/firmware/${f##*/} ] || ln -s ${f} /lib/firmware/${f##*/}
      done
   fi
}

firmware_off() {
   local f
   [ -d "${FPATH}" ] || return 0
   if [ -w ${FPATH_SYS} ]; then
      grep -q "^${FPATH}$" ${FPATH_SYS} && echo -n "" > ${FPATH_SYS}
   else
      for f in /lib/firmware/*; do
         [ -h ${f} ] && case $(readlink ${f}) in ${FPATH}/*) rm -f ${f};; esac
      done
      rmdir /lib/firmware 2>/dev/null
   fi
   return 0
}

udev_on() {
   local rule
   [ -n "${UDEV}" ] || return 0
   for rule in ${UDEV}; do
      ln -sf ${RULES_DIR}/${rule} /lib/udev/rules.d/${rule}
   done
   udevadm control --reload-rules
}

udev_off() {
   local rule
   [ -n "${UDEV}" ] || return 0
   for rule in ${UDEV}; do
      rm -f /lib/udev/rules.d/${rule}
   done
   udevadm control --reload-rules
}

#------------------------------------------------
# Main
#------------------------------------------------

SPK=""
ROOT=""
PROFILES=""
ACTION=""
MODULES=""
VERBOSE="FALSE"
DRYRUN="FALSE"

while [ $# -gt 0 ]; do
   case $1 in
      -s|--spk)     shift; SPK=$1;;
      -p|--profile) shift; PROFILES=$(echo $1 | tr ',' ' ');;
      -r|--root)    shift; ROOT=$1;;
      -n|--dry-run) DRYRUN="TRUE";;
      -v|--verbose) VERBOSE="TRUE";;
      -h|--help)    usage; exit 0;;
      list|modules|start|stop|restart|status) ACTION=$1;;
      insmod)       ACTION=start;;
      rmmod)        ACTION=stop;;
      reload)       ACTION=restart;;
      -*)           usage; die "unknown option [$1]";;
      *)            MODULES="${MODULES} $1";;
   esac
   shift
done

[ -n "${ACTION}" ] || { usage; exit 1; }
command -v jq >/dev/null || die "jq is needed to read the profiles"

# The platform the modules are built for (uname: synology_<platform>_<model>),
# and the kernel version, without the "+" of 4.4 and newer
PLATFORM=$(uname -a | awk '{print $NF}' | cut -d_ -f2)
KVER=$(uname -r | sed 's/+$//')

if [ "${ACTION}" = "list" ]; then
   list
   exit 0
fi

[ -n "${PROFILES}${MODULES}" ] || { usage; die "no profile nor module given"; }

# The package: given, or the one holding the profiles
if [ -z "${SPK}" -a -z "${ROOT}" ]; then
   for p in ${PROFILES}; do
      s=$(profile_spk $(profile_file ${p}))
      [ -z "${SPK}" -o "${SPK}" = "${s}" ] || die "profiles of several packages: ${SPK} and ${s}"
      SPK=${s}
   done
   [ -n "${SPK}" ] || die "modules given without --spk"
fi
ROOT=${ROOT:-${PACKAGES}/${SPK}/target}
FPATH=${ROOT}/lib/firmware
KPATH=${ROOT}/lib/modules/${PLATFORM}/$(uname -r)

[ -d "${ROOT}" ] || die "${SPK} is not installed"
[ -d "${KPATH}" ] || die "no modules for this kernel in [${KPATH}]"

# Modules and udev rules of the profiles, then the modules given
WANTED=""
UDEV=""
for p in ${PROFILES}; do
   file=$(profile_file ${p})
   WANTED="${WANTED} $(profile_modules ${file})"
   UDEV="${UDEV} $(jq -r '(.udev // []) | join(" ")' ${file})"
done
WANTED="${WANTED} ${MODULES}"
UDEV=$(echo ${UDEV})

index_modules
SEEN=""
ORDER=""
for m in ${WANTED}; do
   resolve ${m}
done

if [ "${ACTION}" = "modules" ]; then
   modules
   exit $?
fi
[ "${DRYRUN}" = "TRUE" -o "$(id -u)" = "0" ] || die "must be run as root"

# The log needs root: a dry run without it prints only
if [ "$(id -u)" = "0" ]; then
   mkdir -p $(dirname ${LOG})
   exec > >(tee -a ${LOG}) 2>&1
   TEE=$!
fi
[ "${ACTION}" = "status" ] || warning
echo "--- $(date '+%Y-%m-%d %H:%M:%S') ${ACTION}$([ "${DRYRUN}" = "TRUE" ] && echo " (dry run)") ${SPK:-${ROOT}} [${PROFILES}${MODULES:+ +${MODULES}}]"
say "kernel ${PLATFORM} $(uname -r): ${KPATH}"
say "modules: $(for m in ${ORDER}; do echo -n "$(modname ${m}) "; done)"

case ${ACTION} in
   start)   load;;
   stop)    unload;;
   restart) unload; load;;
   status)  status;;
esac
rc=$?

# Let tee write the last lines before returning
if [ -n "${TEE}" ]; then
   exec >&- 2>&-
   wait ${TEE}
fi
exit ${rc}
