###############################################################################
# mk/spksrc.common/macros.mk
#
# Defines generic GNU Make helper macros used across spksrc.
#
# This file:
#  - provides version string comparison helpers
#  - implements list and string de-duplication utilities
#  - offers helpers to merge environment variable values
#
# Macros:
#  version_le  : true if version A <= version B
#  version_ge  : true if version A >= version B
#  version_lt  : true if version A <  version B
#  version_gt  : true if version A >  version B
#
#  uniq        : removes duplicate words while preserving order
#  dedup       : de-duplicates delimiter-separated strings
#  dedup-files : removes duplicate files while preserving order (via md5sum)
#  merge       : merges environment variable values from input
#
# LOG_WRAPPED  : generic macro to call recipe execution using logging
#
# Notes:
#  - Version comparisons rely on GNU sort (-V)
#  - Some macros invoke /bin/bash for string processing
#
###############################################################################

# Macro: Version Comparison
version_le = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_ge = $(shell if printf '%s\n' "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)
version_lt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VC ; then echo 1; fi)
version_gt = $(shell if [ "$(1)" != "$(2)" ] && printf "%s\n" "$(1)" "$(2)" | sort -VCr ; then echo 1; fi)

# Remove duplicate words within string while preserving order
define uniq
$(strip \
  $(eval __seen :=) \
  $(foreach f,$1, \
    $(if $(filter $f,$(__seen)),, \
      $(eval __seen += $f)$(f) \
    ) \
  ) \
)
endef

# Macro: dedup
#        removes duplicate entries from a specified delimiter,
#        preserving the order of unique elements,
#        and dropping empty elements (e.g. "::")
dedup = $(shell /bin/bash -c '\
    input="$$(echo "$1" | xargs)"; \
    delimiter="$$(echo "$2" | xargs)"; \
    printf "%s\n" "$$input" | \
    tr "$$delimiter" "\n" | \
    awk '\''NF && !seen[$$0]++ {print $$0}'\'' | \
    tr "\n" "$$delimiter" | \
    sed "s/$$delimiter$$//" \
')

# Macro: dedup-files
#        Removes duplicate files from a list by comparing their content (md5sum),
#        preserving the order of first occurrences and silently discarding
#        subsequent files whose content has already been seen.
#        Useful when the same patch may exist under multiple directories.
#
# Usage: $(call dedup-files,$(PATCHES))
#
# Note:  _seen_md5s and _deduped are reset at each call to avoid
#        accumulation across multiple invocations.
define dedup-files
$(strip \
  $(eval _seen_md5s :=) \
  $(eval _deduped :=) \
  $(foreach file,$(1), \
    $(eval _md5 := $(shell md5sum $(file) | cut -d' ' -f1)) \
    $(if $(filter $(_md5),$(_seen_md5s)), \
      $(info ===> [DEDUP] Skipping duplicate content: $(file)), \
      $(eval _seen_md5s += $(_md5)) \
      $(eval _deduped += $(file)) \
    ) \
  ) \
  $(_deduped) \
)
endef

# Macro: merge
#        merges multiple environment variable values from a given input string,
#        inverting their order and separating them with a specified delimiter
merge = $(shell /bin/bash -c '\
    input="$$(echo "$1" | xargs)"; \
    var_name="$$(echo "$2" | xargs)"; \
    delimiter="$$(echo "$3" | xargs)"; \
    echo "$$input" | \
    grep -o "$$var_name=[^ ]*" | \
    tac | \
    sed "s/^$$var_name=//" | \
    tr "\n" "$$delimiter" | \
    sed "s/$$delimiter$$//" \
')

# Generic macro to call recipe execution using logging
define LOG_WRAPPED
@bash -o pipefail -c '\
    if [ -z "$$LOGGING_ENABLED" ]; then \
        export LOGGING_ENABLED=1 ; \
        script -q -e -c "$(MAKE) -f $(firstword $(MAKEFILE_LIST)) $(1)" /dev/null \
            | tee >(sed -r "s/\x1B\[[0-9;]*[mK]//g; s/\\r//g" >> "$(DEFAULT_LOG)") ; \
    else \
        $(MAKE) -f $(firstword $(MAKEFILE_LIST)) $(1) ; \
    fi \
' || { \
    $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s, NAME: %s - FAILED\n" \
        "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(ARCH)-$(TCVERSION)" "$(1)") \
        | tee --append $(STATUS_LOG) ; \
    exit 1 ; \
}
endef
