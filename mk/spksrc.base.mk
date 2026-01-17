# Base definitions, shared by all makefiles
# This file contains only plain macros and defines with NO directory dependencies

# Stop on first error
SHELL := $(SHELL) -e

# Define $(empty) and $(space)
empty :=
space := $(empty) $(empty)

# Display message in a consistent way
MSG = echo "===> "

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

# Terminal colors
RED=$$(tput setaf 1)
GREEN=$$(tput setaf 2)
NC=$$(tput sgr0)

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
#        preserving the order of unique elements.
dedup = $(shell /bin/bash -c '\
    input="$$(echo "$1" | xargs)"; \
    delimiter="$$(echo "$2" | xargs)"; \
    echo "$$input" | \
    tr "$$delimiter" "\n" | \
    awk '\''!seen[$$0]++ {print $$0}'\'' | \
    tr "\n" "$$delimiter" | \
    sed "s/$$delimiter$$//" \
')

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
