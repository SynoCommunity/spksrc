#!/bin/bash

# Build dependency list
#
# list dependencies for all spk packages
# - used by github prepare action to evaluate packages to build, regarding the modified files
# - broken packages are excluded
# This script must be called in the top folder (spksrc) of the repository
# It is called by the dependency-list target of the toplevel Makefile 
# 
# This script has benefits over iterating all spk folders and call "make dependency-list"
# - it is much faster (typ. 15 s instead of 180 s)
# - it does not require "OPTIONAL_DEPENDS" defitions anymore
# caveats
# - makefile variables like $(SPK_NAME) are not allowed in dependency definitions anymore
# - definition of dependencies in included make files are not evaluated.
#   Those are 
#   - native/cmake, native/cmake-legacy, native/nasm for cmake/rust packages (^1)
#   - cross/$(PYTHON_PACKAGE) for packages reusing prebuilt python (^2)
#   - cross/$(FFMPEG_PACKAGE) for packages reusing prebuilt ffmpeg (^2)
#   ^1: We could introduce a new OPTIONAL_DEPENDS (ADDITIONAL_DEPENDS) variable to fix this
#       But it will hardly happen, that nasm or cmake changes (and are deprecated since those are installed to dev environment)
#   ^2: The missing dependencies with packages using prebuilt ffmpeg/python where not
#       evaluated in the former solution too.
#       So far we did not want to trigger the build of all related packages when only the prebuilt package had changes
#       Otherwise we could introduce a new OPTIONAL_DEPENDS (ADDITIONAL_DEPENDS) variable for this

# get SPK_NAME of a package
# since the spk name might be different to the (spk/){package} folder
# we need to parse the variable in the Makefile
# param1: package folder
function get_spk_name ()
{
   if [ -f ${1}/Makefile ]; then
      grep "^SPK_NAME" ${1}/Makefile | cut -d= -f2 | xargs
   fi
}

# evaluate python dependency in an spk Makefile
# param1: spk package folder (like spk/{name})
function get_python_dependency ()
{
   if [ -f ${1}/Makefile -a "$(grep ^include.*\/spksrc\.python\.mk ${1}/Makefile)" ]; then
      local dep=$(grep "PYTHON_PACKAGE\s*=" ${1}/Makefile | cut -d= -f2 | xargs)
      echo "cross/${dep} "
   fi
}

# evaluate ffmpeg dependency in an spk Makefile
# param1: spk package folder (like spk/{name})
function get_ffmpeg_dependency ()
{
   if [ -f ${1}/Makefile -a "$(grep ^include.*\/spksrc\.ffmpeg\.mk ${1}/Makefile)" ]; then
      local dep=$(grep "FFMPEG_PACKAGE\s*=" ${1}/Makefile | cut -d= -f2 | xargs)
      echo "cross/${dep} "
   fi
}


# evaluates all dependencies in a single Makefile
# param1: folder (like spk/{name}, cross/{name}, native/{name})
function get_file_dependencies ()
{
   if [ -f ${1}/Makefile ]; then
      grep "^DEPENDS\|^NATIVE_DEPENDS\|^BUILD_DEPENDS" ${1}/Makefile | cut -d= -f2 | sort -u | tr '\n' ' '
   fi
}

# search for substring in a list of strings
# param1 list of space separated strings
# param2 substring
function contains ()
{
   if [ -z "${1}" -o -z "${2}" ]; then
      echo "false";
   else
      if [ "$(echo ${1} | tr ' ' '\n' | grep -w ${2})" = "${2}" ]; then
         echo "true"
      else
         echo "false"
      fi
   fi
}

# get direct package dependencies
# param1: list of folders containing Makefile to parse
function get_dependencies ()
{
   local dependencies=
   for dep in ${1}; do
      dependencies+="${dep} "
      dependencies+="$(get_file_dependencies ${dep}) "
   done
   echo ${dependencies} | tr ' ' '\n' | sort -u | tr '\n' ' '
}

# get all dependencies of a package
# param1: list of toplevel dependencies
function get_spk_dependencies ()
{
   local dependencies=$(get_dependencies "${1}")
   local cumulated_dependencies=$(get_dependencies "${dependencies}")
   while [ "${cumulated_dependencies}" != "${dependencies}" ]; do
      dependencies=${cumulated_dependencies}
      cumulated_dependencies=$(get_dependencies "${dependencies}")
   done
   echo ${cumulated_dependencies}
}

# get the dependency list for a package
# param1: spk package folder (like spk/{name})
function get_dependency_list ()
{
   local spk_name=$(get_spk_name ${1})
   local toplevel_dependencies="$(get_file_dependencies ${1}) $(get_python_dependency ${1}) $(get_ffmpeg_dependency ${1})"
   local spk_dependencies=$(get_spk_dependencies "${toplevel_dependencies}")
   echo "${spk_name}: ${spk_dependencies}"
}

# iterate all packages
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort); do
   if [ ! -f spk/${package}/BROKEN ]; then
      get_dependency_list spk/${package}
   fi
done
