###############################################################################
# spksrc.common/macros/version.mk
#
# Version comparisons, through GNU sort -V.
###############################################################################

# Macro: compare two versions
#
#   $(call version_ge,$(TC_GCC),5)   $(call version_lt,$(TC_KERNEL),3.2)
#
# 1 when the relation holds, empty otherwise, for $(if) and ifeq. version_le and version_ge
# hold for equal versions, version_lt and version_gt do not.
version_le = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_ge = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)
version_lt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_gt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)
