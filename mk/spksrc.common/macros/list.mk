###############################################################################
# spksrc.common/macros/list.mk
#
# Lists: de-duplication, appending, merging.
###############################################################################

# Macro: append to a comma-separated list
#
#   REASONS := $(call comma_append,$(REASONS),gcc < 5)
#
# $(1) with $(2) appended after a comma, or $(1) unchanged when $(2) is empty. Reasons
# accumulate rather than overwrite: an arch can miss several capabilities at once.
comma_append = $(if $(strip $(2)),$(1)$(if $(strip $(1)),$(,) )$(2),$(1))

# Macro: remove duplicate words
#
#   $(call uniq,$(CFLAGS) $(ADDITIONAL_CFLAGS))
#
# The words of $(1), each once, in the order of their first occurrence: a flag listed by
# two sources is passed once, where it first appeared.
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

# Macro: remove duplicate entries of a delimited string
#
#   $(call dedup,$(PKG_CONFIG_LIBDIR),:)
#
# The entries of $(1) split on $(2), each once, in the order of their first occurrence,
# and empty ones dropped ("::"), joined again with $(2).
define dedup
$(shell /bin/bash -c '\
    input="$$(echo "$1" | xargs)"; \
    delimiter="$$(echo "$2" | xargs)"; \
    printf "%s\n" "$$input" | \
    tr "$$delimiter" "\n" | \
    awk '\''NF && !seen[$$0]++ {print $$0}'\'' | \
    tr "\n" "$$delimiter" | \
    sed "s/$$delimiter$$//" \
')
endef

# Macro: remove files of identical content
#
#   $(call dedup_files,$(PATCHES))
#
# The files of $(1) whose content (md5sum) was not seen in an earlier one, in order: the
# same patch may exist under several directories. Each file skipped is reported. The
# state is reset at each call, so invocations do not accumulate.
define dedup_files
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

# Macro: merge the values of a variable set several times
#
#   $(call merge,$(ENV),PKG_CONFIG_LIBDIR,:)
#
# Every value $(2)=<value> in $(1), last one first, joined with $(3): an environment that
# sets a variable more than once, the later assignments taking precedence.
define merge
$(shell /bin/bash -c '\
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
endef
