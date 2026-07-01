###############################################################################
# spksrc.common/help.mk
#
# Package-level, context-aware `make help`. Included via spksrc.common.mk, it
# only defines the target inside a package directory (cross/, spk/, native/,
# toolchain/, kernel/) - detected from the parent directory name - so it never
# collides with the orchestration help defined in the spksrc root Makefile.
###############################################################################

# spksrc.common.mk may be included more than once by a package; guard so the
# help recipe is defined only once (avoids "overriding recipe" warnings).
ifndef SPKSRC_HELP_MK
SPKSRC_HELP_MK := 1

# Name of the directory that contains this package (cross / spk / native / ...).
SPKSRC_TREE := $(notdir $(patsubst %/,%,$(dir $(CURDIR))))

ifneq ($(filter $(SPKSRC_TREE),cross spk native toolchain kernel),)

# The plain build pipeline; spk/ and cross/ additionally generate a PLIST.
HELP_STEPS := download checksum extract patch configure compile install
ifneq ($(filter $(SPKSRC_TREE),cross spk),)
HELP_STEPS += plist
endif

.PHONY: help
help:
	@printf "\n\033[1m%s\033[0m  (%s package)\n" "$(or $(SPK_NAME),$(PKG_NAME),$(notdir $(CURDIR)))" "$(SPKSRC_TREE)"
	@printf "\n\033[1mBuild\033[0m\n"
	@printf "  \033[36m%-14s\033[0m %s\n" "all" "build this package (default)"
ifneq ($(filter $(SPKSRC_TREE),cross spk native),)
	@printf "  \033[36m%-14s\033[0m %s\n" "<step>" "run one build step, in order:"
	@printf "  %-14s   %s\n" "" "$(HELP_STEPS)"
endif
ifneq ($(filter $(SPKSRC_TREE),cross spk),)
	@printf "\n\033[1mMulti-arch\033[0m\n"
	@printf "  \033[36m%-14s\033[0m %s\n" "arch-<arch>" "build one arch (e.g. arch-x64-7.1)"
	@printf "  \033[36m%-14s\033[0m %s\n" "all-supported" "build every supported arch"
	@printf "  \033[36m%-14s\033[0m %s\n" "all-latest" "build the latest toolchains only"
	@printf "  \033[36m%-14s\033[0m %s\n" "supported" "list the supported arch-version pairs"
	@printf "  \033[36m%-14s\033[0m %s\n" "latest" "list the latest arch-version pairs"
	@printf "  \033[33m%s\033[0m\n" "  needs 'make setup' once at the spksrc root first"
else ifeq ($(SPKSRC_TREE),native)
	@printf "\n  \033[33m%s\033[0m\n" "host-native single build - no arch matrix"
endif
	@printf "\n\033[1mMaintenance\033[0m\n"
	@printf "  \033[36m%-14s\033[0m %s\n" "clean" "remove all work directories"
	@printf "  \033[36m%-14s\033[0m %s\n" "smart-clean" "remove only this package's source and cookies"
	@printf "  \033[36m%-14s\033[0m %s\n" "digests" "regenerate the digests file"
	@printf "\nRun \033[36mmake help\033[0m at the spksrc root for repo-wide targets (setup, ...)\n\n"

endif

endif
