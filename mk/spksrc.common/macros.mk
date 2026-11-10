###############################################################################
# spksrc.common/macros.mk
#
# Defines generic GNU Make helper macros used across spksrc, one file per theme under
# spksrc.common/macros/. A macro is assigned with = when it fits on one line, with define
# when its body spans several. A name starting with _ is the framework's own: helpers and
# state a package never sets or calls.
#
# Macros:
#  string.mk
#   upper             : upper-cases ASCII letters, no fork
#   lower             : lower-cases ASCII letters, no fork
#
#  version.mk
#   version_le        : true if version A <= version B
#   version_ge        : true if version A >= version B
#   version_lt        : true if version A <  version B
#   version_gt        : true if version A >  version B
#
#  bool.mk
#   TRUE, FALSE       : every spelling of a switch on / off, lower and upper case
#   is_true           : non-empty when a switch is on (1, y, yes, true, on -- any case)
#   is_false          : non-empty when a switch is off (0, n, no, false, off, or empty)
#   assert_bool       : stops the build when a switch is neither
#   bool              : TRUE or FALSE; stops the build on any other value
#
#  list.mk
#   comma_append      : appends to a comma-separated list
#   uniq              : removes duplicate words while preserving order
#   dedup             : de-duplicates delimiter-separated strings
#   dedup_files       : removes duplicate files while preserving order (via md5sum)
#   merge             : merges environment variable values from input
#
#  depend.mk
#   depend            : declares a dependency, optional or with alternatives
#   dep_seen          : shell test, true when a dependency was already visited in a walk
#
#  tools.mk
#   read_makefile_var : the value a Makefile assigns to a variable, unexpanded
#   tc                : absolute path of a cross tool, overlay-aware
#   native            : absolute path of a host tool
#
#  archs.mk
#   overlay_dist_arch : the arch an overlay archive is named after
#   toolchain_real    : the toolchain a producer builds an <arch>-<dsm> as
#   toolchain_archs   : the archs a producer builds for a DSM version
#   toolchain_published_rev : the PKG_REV of the overlay that installs an archive
#
#  runlog.mk
#   _runlog           : shell fragment running a command teed into a log
#   RUNLOG            : runs a make goal of this Makefile, logged
#
# Notes:
#  - Version comparisons rely on GNU sort (-V)
#  - Some macros invoke /bin/bash for string processing
#
###############################################################################

_MACROS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))macros

include $(_MACROS_DIR)/string.mk
include $(_MACROS_DIR)/version.mk
include $(_MACROS_DIR)/bool.mk
include $(_MACROS_DIR)/list.mk
include $(_MACROS_DIR)/depend.mk
include $(_MACROS_DIR)/tools.mk
include $(_MACROS_DIR)/archs.mk
include $(_MACROS_DIR)/runlog.mk
