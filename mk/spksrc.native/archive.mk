###############################################################################
# spksrc.native/archive.mk
#
# Optional packaging step for native packages: tar a subset of the install tree
# into a hosted archive, so an expensive native tool (llvm, the gcc-8.5 overlays,
# ...) is built once and then re-consumed via DEPENDS instead of rebuilt from
# source. Included by spksrc.native-cc.mk and run automatically after 'install'
# (see _all there), idempotently, with an optional debug-symbol strip.
#
# A pure no-op unless the package declares NATIVE_ARCHIVE_NAME; when it does, the
# other variables default so a package usually needs that one line only:
#
#   NATIVE_ARCHIVE_NAME = native-$(PKG_NAME)-$(PKG_VERS)
#
# Targets (standard pre/post pattern, like every other build step):
#   archive_msg
#   pre_archive_target   (override with PRE_ARCHIVE_TARGET)
#   archive_target       (override with ARCHIVE_TARGET; nop disables the step)
#   post_archive_target  (override with POST_ARCHIVE_TARGET)
#   build-archive        create the archive on demand (same result as 'all')
#   print-archive-name   echo the archive filename without building (generators)
#
# Variables:
#   NATIVE_ARCHIVE_NAME      base name, WITHOUT extension -- enables the step
#   NATIVE_ARCHIVE_EXT       extension / compression           (default: txz)
#   NATIVE_ARCHIVE_DIR       tar working dir, tar -C           (default: $(WORK_DIR))
#   NATIVE_ARCHIVE_KEEP      paths to archive, relative to DIR (default: ./install)
#   NATIVE_ARCHIVE_EXCLUDES  tar --exclude args                (default: none)
#   NATIVE_ARCHIVE_SENTINEL  file/dir that must exist first
#                                             (default: $(STAGING_INSTALL_PREFIX)/bin)
#   NATIVE_ARCHIVE_STRIP            non-empty to strip debug symbols first
#   NATIVE_ARCHIVE_STRIP_HOST       host strip program              (default: strip)
#   NATIVE_ARCHIVE_STRIP_HOST_DIRS  host-binary dirs, rel to DIR    (default: bin libexec)
#   NATIVE_ARCHIVE_STRIP_TARGET       cross strip for target objects (optional)
#   NATIVE_ARCHIVE_STRIP_TARGET_DIRS  target-object dirs, rel to DIR (optional)
#
#   NATIVE_ARCHIVE (computed) = $(NATIVE_ARCHIVE_NAME).$(NATIVE_ARCHIVE_EXT)
###############################################################################

# Compression by extension, mirroring spksrc.build/extract.mk in reverse.
NATIVE_ARCHIVE_EXT ?= txz
TAR_CMD ?= tar
ARCHIVE_CMD.tgz     = $(TAR_CMD) -czpf
ARCHIVE_CMD.txz     = $(TAR_CMD) -cJpf
ARCHIVE_CMD.tar     = $(TAR_CMD) -cpf
ARCHIVE_CMD.tar.gz  = $(TAR_CMD) -czpf
ARCHIVE_CMD.tar.xz  = $(TAR_CMD) -cJpf
ARCHIVE_CMD.tar.bz2 = $(TAR_CMD) -cjpf
ARCHIVE_CMD.tbz     = $(TAR_CMD) -cjpf
ifeq ($(strip $(ARCHIVE_CMD)),)
ARCHIVE_CMD = $(ARCHIVE_CMD.$(NATIVE_ARCHIVE_EXT))
endif

ifeq ($(strip $(PRE_ARCHIVE_TARGET)),)
PRE_ARCHIVE_TARGET = pre_archive_target
else
$(PRE_ARCHIVE_TARGET): archive_msg
endif
ifeq ($(strip $(ARCHIVE_TARGET)),)
ARCHIVE_TARGET = archive_target
else
$(ARCHIVE_TARGET): $(PRE_ARCHIVE_TARGET)
endif
ifeq ($(strip $(POST_ARCHIVE_TARGET)),)
POST_ARCHIVE_TARGET = post_archive_target
else
$(POST_ARCHIVE_TARGET): $(ARCHIVE_TARGET)
endif

.PHONY: archive archive_msg build-archive print-archive-name
.PHONY: $(PRE_ARCHIVE_TARGET) $(ARCHIVE_TARGET) $(POST_ARCHIVE_TARGET)

archive_msg:
	@$(MSG) "Archiving $(NAME)"

pre_archive_target: archive_msg
post_archive_target: $(ARCHIVE_TARGET)

ifeq ($(strip $(NATIVE_ARCHIVE_NAME)),)

# No archive requested: the whole step, and the print helper, are no-ops.
archive: ;
archive_target: ;
build-archive: ;
print-archive-name: ;

else

NATIVE_ARCHIVE           = $(NATIVE_ARCHIVE_NAME).$(NATIVE_ARCHIVE_EXT)
NATIVE_ARCHIVE_DIR       ?= $(WORK_DIR)
NATIVE_ARCHIVE_KEEP      ?= ./install
NATIVE_ARCHIVE_SENTINEL  ?= $(STAGING_INSTALL_PREFIX)/bin
NATIVE_ARCHIVE_STRIP_HOST      ?= strip
NATIVE_ARCHIVE_STRIP_HOST_DIRS ?= bin libexec

archive: $(POST_ARCHIVE_TARGET)
build-archive: $(NATIVE_ARCHIVE)
archive_target: $(PRE_ARCHIVE_TARGET) $(NATIVE_ARCHIVE)

print-archive-name:
	@echo $(NATIVE_ARCHIVE)

# File target, prerequisite-free on purpose: it is (re)built only when absent, so
# re-running a batch never re-strips or re-tars an archive that already exists.
# --strip-debug keeps the symbol tables the tools need and only drops the (large)
# debug sections. Target objects need the arch's OWN strip (the host strip cannot
# touch them); host binaries use the host strip.
$(NATIVE_ARCHIVE):
ifeq ($(wildcard $(NATIVE_ARCHIVE_SENTINEL)),)
	$(error "$(PKG_NAME): nothing to archive at $(NATIVE_ARCHIVE_SENTINEL); build it first")
endif
	@if [ -n "$(strip $(NATIVE_ARCHIVE_STRIP))" ]; then \
	  $(MSG) "archive: stripping debug symbols -> $(NATIVE_ARCHIVE)" ; \
	  if [ -n "$(strip $(NATIVE_ARCHIVE_STRIP_TARGET))" ] && [ -n "$(strip $(NATIVE_ARCHIVE_STRIP_TARGET_DIRS))" ]; then \
	    find $(addprefix $(NATIVE_ARCHIVE_DIR)/,$(NATIVE_ARCHIVE_STRIP_TARGET_DIRS)) -type f \
	      \( -name '*.a' -o -name '*.o' -o -name '*.so*' \) 2>/dev/null | \
	      while read f; do "$(NATIVE_ARCHIVE_STRIP_TARGET)" --strip-debug "$$f" 2>/dev/null || true ; done ; \
	  fi ; \
	  find $(addprefix $(NATIVE_ARCHIVE_DIR)/,$(NATIVE_ARCHIVE_STRIP_HOST_DIRS)) -type f 2>/dev/null | \
	    while read f; do $(NATIVE_ARCHIVE_STRIP_HOST) --strip-debug "$$f" 2>/dev/null || true ; done ; \
	fi
	@$(MSG) "archive: $(PKG_NAME) -> $(NATIVE_ARCHIVE)"
	$(ARCHIVE_CMD) $(NATIVE_ARCHIVE) -C $(NATIVE_ARCHIVE_DIR) $(NATIVE_ARCHIVE_EXCLUDES) $(NATIVE_ARCHIVE_KEEP)

endif
