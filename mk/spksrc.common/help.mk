###############################################################################
# spksrc.common/help.mk
#
# Package-level, context-aware `make help`. Included via spksrc.common.mk (after
# 'default: all' so it never becomes the default goal), it only defines the
# target inside a package directory (cross/, spk/, native/, toolchain/,
# toolkit/, kernel/, diyspk/, python/) - detected from the parent directory
# name - so it never collides with the orchestration help in the root Makefile.
###############################################################################

# spksrc.common.mk may be included more than once by a package; guard so the
# help recipe is defined only once (avoids "overriding recipe" warnings).
ifndef SPKSRC_HELP_MK
SPKSRC_HELP_MK := 1

# Name of the directory that contains this package (cross / spk / native / ...).
SPKSRC_TREE := $(notdir $(patsubst %/,%,$(dir $(CURDIR))))

ifneq ($(filter $(SPKSRC_TREE),cross spk native toolchain toolkit kernel diyspk python),)

# Build lifecycle steps; spk/cross/diyspk additionally generate a PLIST.
HELP_STEPS := download checksum extract patch configure compile install
ifneq ($(filter $(SPKSRC_TREE),cross spk diyspk),)
HELP_STEPS += plist
endif

# Python wheel targets apply to spk/diyspk packages that set PYTHON_PACKAGE or
# are themselves a python3* package. Deferred (=) so it is evaluated when the
# recipe runs: PYTHON_PACKAGE is often set *after* spksrc.common.mk is included.
HELP_PYTHON = $(strip $(PYTHON_PACKAGE))$(filter python3%,$(SPK_NAME) $(PKG_NAME))

.PHONY: help
help:
	@printf "\n\033[1m%s\033[0m  (%s package)\n" "$(or $(SPK_NAME),$(PKG_NAME),$(notdir $(CURDIR)))" "$(SPKSRC_TREE)"
ifeq ($(SPKSRC_TREE),python)
	@printf "\n  \033[33m%s\033[0m\n" "built only as an spk dependency - it has no direct build here"
else
	@printf "\n\033[1mBuild\033[0m\n"
	@printf "  \033[36m%-24s\033[0m %s\n" "all" "build this package (default target)"
ifneq ($(filter $(SPKSRC_TREE),cross spk kernel diyspk),)
	@printf "  \033[36m%-24s\033[0m %s\n" "arch-<arch>-<tcvers>" "build for one arch/version (e.g. arch-x64-7.1)"
endif
ifneq ($(filter $(SPKSRC_TREE),cross spk native diyspk),)
	@printf "  \033[36m%-24s\033[0m %s\n" "<step>" "run one build step, in order:"
	@printf "  %-24s   %s\n" "" "$(HELP_STEPS)"
endif
ifneq ($(filter $(SPKSRC_TREE),cross spk kernel diyspk),)
	@printf "  \033[33m%s\033[0m\n" "  all and every <step> except download need ARCH=<arch> TCVERSION=<tcvers>"
endif
ifeq ($(SPKSRC_TREE),toolchain)
	@printf "  \033[36m%-24s\033[0m %s\n" "tc_vars" "show the toolchain variables (TC_GCC, ...)"
endif
ifeq ($(SPKSRC_TREE),toolkit)
	@printf "  \033[36m%-24s\033[0m %s\n" "tk_vars" "show the toolkit variables"
endif
	@printf "  \033[36m%-24s\033[0m %s\n" "rustup <args>" "run rustup for the rust toolchain (e.g. make rustup show)"
ifneq ($(filter $(SPKSRC_TREE),cross spk diyspk),)
	@printf "\n\033[1mMulti-arch\033[0m  (needs 'make setup' once at the spksrc root first)\n"
	@printf "  \033[36m%-24s\033[0m %s\n" "all-supported" "build for every supported arch"
	@printf "  \033[36m%-24s\033[0m %s\n" "all-latest" "build for the latest toolchains only"
ifneq ($(filter $(SPKSRC_TREE),spk diyspk),)
	@printf "  \033[36m%-24s\033[0m %s\n" "publish-all-supported" "build and publish every supported arch (after 'make setup-synocommunity' + PUBLISH_API_KEY)"
	@printf "  \033[36m%-24s\033[0m %s\n" "publish-all-latest" "build and publish the latest toolchains only"
endif
endif
ifneq ($(filter $(SPKSRC_TREE),spk diyspk),)
	@if [ -n "$(HELP_PYTHON)" ]; then \
	  printf "\n\033[1mPython wheels\033[0m  (WHEELS=\"pkg1==ver pkg2==ver ...\" restricts the (re)build to those wheels; unset rebuilds all of the package's wheels, or its default crossenv)\n" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "wheel-<arch>-<tcvers>" "build the package's wheels for one arch" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "crossenv-<arch>-<tcvers>" "build the cross-compilation Python venv" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "download-wheels" "download the wheel sources only" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "wheelclean" "remove wheel build state (run before rebuilding)" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "wheelcleancache" "also drop the shared wheel download cache" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "crossenvclean" "remove the crossenv and wheel state" ; \
	  printf "  \033[36m%-24s\033[0m %s\n" "crossenvcleanall" "remove the crossenv, wheels and cache" ; \
	fi
endif
endif
	@printf "\n\033[1mInspect\033[0m\n"
	@printf "  \033[36m%-24s\033[0m %s\n" "dependency-tree" "print the resolved dependency graph"
	@printf "  \033[36m%-24s\033[0m %s\n" "dependency-flat" "flat, de-duplicated dependency list"
	@printf "  \033[36m%-24s\033[0m %s\n" "dependency-list" "raw per-package dependency list"
ifneq ($(SPKSRC_TREE),python)
	@printf "\n\033[1mCleanup\033[0m\n"
	@printf "  \033[36m%-24s\033[0m %s\n" "clean" "remove all work directories"
	@printf "  \033[36m%-24s\033[0m %s\n" "smart-clean" "remove this package's source and cookies (needs ARCH+TCVERSION)"
	@printf "\n\033[1mMaintenance\033[0m\n"
	@printf "  \033[36m%-24s\033[0m %s\n" "download" "fetch the source archive(s)"
	@printf "  \033[36m%-24s\033[0m %s\n" "digests" "regenerate the digests file (auto-runs download)"
	@printf "  \033[33m%s\033[0m\n" "  to refresh digests: make clean, delete the file in distrib/, then make digests"
endif
	@printf "\nRun \033[36mmake help\033[0m at the spksrc root for repo-wide targets (setup, ...)\n\n"

endif

endif
