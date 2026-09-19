###############################################################################
# spksrc.spk/strip.mk
#
# Strip the binary files (exec and libs) in the staging directory.
#
# Targets are executed in the following order:
#  strip_msg_target
#  pre_strip_target   (override with PRE_STRIP_TARGET)
#  strip_target       (override with STRIP_TARGET)
#  post_strip_target  (override with POST_STRIP_TARGET)
#
# Variables:
#  TC                 If set, TC_ENV will be parsed to find the strip utility.
#  TC_ENV             List of variables defining the build environment.
#  STAGING_DIR        Directory where the strip files.
#
# Files
#  $(INSTALL_PLIST)  Pair of type:filepath, type can be bin, lib, lnk, or rsc. Only bin and lib
#                    files will be stripped.
#
###############################################################################

# Prefer target strip if present, otherwise fallback to host strip
STRIP := $(or $(wildcard $(TC_PATH)/$(TC_PREFIX)strip),strip)

STRIP_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)strip_done

ifeq ($(strip $(PRE_STRIP_TARGET)),)
PRE_STRIP_TARGET = pre_strip_target
else
$(PRE_STRIP_TARGET): strip_msg
endif
ifeq ($(strip $(STRIP_TARGET)),)
STRIP_TARGET = strip_target
else
$(STRIP_TARGET): $(PRE_STRIP_TARGET)
endif
ifeq ($(strip $(POST_STRIP_TARGET)),)
POST_STRIP_TARGET = post_strip_target
else
$(POST_STRIP_TARGET): $(STRIP_TARGET)
endif

TC_LIBRARY_PATH = $(realpath $(TC_PATH)..)/$(TC_LIBRARY)

# The toolchain's <target> root: a runtime library can sit in more than one place
# under it (the sysroot lib, the compiler's own lib/lib64), so the search for a copy
# to carry starts here rather than at the sysroot lib alone.
TC_TOOLCHAIN_ROOT = $(realpath $(TC_PATH)..)

# Runtime libraries DSM does not ship, so any binary that needs one has to carry it
# from the toolchain. libstdc++/libgcc_s are deliberately NOT here: DSM ships them,
# and carrying a newer copy only matters once a gcc overlay can outpace the DSM one
# -- that arrives with the overlay, as a separate TC_LIBS_OVERLAY list.
TC_LIBS_DEFAULT = libatomic.so libquadmath.so libgfortran.so

.PHONY: strip strip_msg
.PHONY: $(PRE_STRIP_TARGET) $(STRIP_TARGET) $(POST_STRIP_TARGET)

strip_msg:
	@$(MSG) "Stripping binaries and libraries of $(NAME)"

# Carry the copy every shipped binary can resolve against -- matched on the UNION of
# the symbol versions they ask for -- rather than the first one a plain find turns up.
# A find by name returns every copy under the toolchain at once (the sysroot's, the
# compiler's lib64, a multilib), different versions handed to a basename expecting one.
# Matching one binary and stopping ships whichever copy satisfied that one, which is the
# oldest copy whenever the first binary listed is the least demanding; the rest then have
# nothing to resolve against at runtime.
define _tclib_helpers
_provides_() { \
   _lib_="$$1" ; shift ; \
   for _v_ in $$@ ; do \
      strings -a "$$_lib_" 2>/dev/null | grep -qx "$$_v_" || return 1 ; \
   done ; \
   return 0 ; \
} ; \
_versions_needed_() { \
   readelf -V "$$1" 2>/dev/null | awk -v so="$$2" \
     'index($$0, "File: " so) > 0 { want = 1 ; next } \
      /File:/ { want = 0 } \
      want && /Name:/ { for (i = 1; i <= NF; i++) if ($$i == "Name:") print $$(i+1) }' ; \
} ; \
_install_tclib_() { \
   _tclib_="$$1" ; _src_="$$2" ; \
   echo "===>      Add library from toolchain ($$(basename $$_src_))" ; \
   install -d -m 755 $(STAGING_DIR)/lib ; \
   install -m 644 "$$_src_" $(STAGING_DIR)/lib/ ; \
   symlinks=$$(find $$(dirname "$$_src_")/. -maxdepth 1 -type l -name "$$_tclib_*" -printf '%f ' | xargs) ; \
   echo "===>      Add symlink from toolchain ($$symlinks)" ; \
   for _link_ in $$symlinks ; do \
      (cd $(STAGING_DIR)/lib/ && ln -sf $$(basename $$_src_) $$_link_) ; \
   done ; \
}
endef

include_toolchain_specific_libraries:
	@$(_tclib_helpers) ; \
	for tclib in $(TC_LIBS_DEFAULT); do \
	  echo  "===> SEARCHING for $${tclib}" ; \
	  _need_all_="" ; _seen_="" ; \
	  for _f_ in $$(sed 's/:/ /' $(INSTALL_PLIST) | awk '$$1=="lib"||$$1=="bin"{print $$2}') ; do \
	     _b_="$(STAGING_DIR)/$${_f_}" ; \
	     _sn_=$$(objdump -p "$$_b_" 2>/dev/null | awk '/NEEDED/ { print $$2 }' | grep -F "$${tclib}" | head -1) ; \
	     [ -n "$$_sn_" ] || continue ; \
	     _seen_=1 ; \
	     _need_all_="$$_need_all_ $$(_versions_needed_ "$$_b_" "$$_sn_")" ; \
	  done ; \
	  for wheel in $(WORK_DIR)/wheelhouse/*.whl ; do \
	     [ -e "$${wheel}" ] || continue ; \
	     for shlib in $$(zipinfo -1 $${wheel} *.so 2>/dev/null) ; do \
	        _tmp_=$$(mktemp -d -p $(WORK_DIR)/wheelhouse) ; \
	        unzip -qq -d $${_tmp_} $${wheel} $${shlib} ; \
	        _sn_=$$(objdump -p "$${_tmp_}/$${shlib}" 2>/dev/null | awk '/NEEDED/ { print $$2 }' | grep -F "$${tclib}" | head -1) ; \
	        if [ -n "$$_sn_" ]; then \
	           _seen_=1 ; \
	           _need_all_="$$_need_all_ $$(_versions_needed_ "$${_tmp_}/$${shlib}" "$$_sn_")" ; \
	        fi ; \
	        rm -fr $${_tmp_} ; \
	     done ; \
	  done ; \
	  [ -n "$$_seen_" ] || continue ; \
	  _need_all_=$$(echo $$_need_all_ | tr ' ' '\n' | grep -v '^$$' | sort -u) ; \
	  _src_="" ; \
	  for _cand_ in $$(find $(TC_TOOLCHAIN_ROOT) -name "$${tclib}" 2>/dev/null | xargs -r realpath 2>/dev/null | sort -u) ; do \
	     if _provides_ "$$_cand_" $$_need_all_ ; then _src_="$$_cand_" ; break ; fi ; \
	  done ; \
	  if [ -n "$$_src_" ]; then \
	     echo  "===>  Providing [$$(echo $$_need_all_ | tr '\n' ' ')] for $${tclib}" ; \
	     _install_tclib_ "$${tclib}" "$$_src_" ; \
	  else \
	     echo  "===>      WARNING: no $${tclib} in the toolchain provides [$$(echo $$_need_all_ | tr '\n' ' ')]" >&2 ; \
	  fi ; \
	done

pre_strip_target: strip_msg

strip_target: $(PRE_STRIP_TARGET) $(INSTALL_PLIST) include_toolchain_specific_libraries
ifneq ($(strip $(GCC_DEBUG_INFO)),1)
	@cat $(INSTALL_PLIST) | sed 's/:/ /' | while read type file ; \
	do \
	  case $${type} in \
	    lib|bin) \
	      echo -n "Stripping $${file}... " ; \
	      chmod u+w $(STAGING_DIR)/$${file} ; \
	      $(STRIP) $(STAGING_DIR)/$${file} > /dev/null 2>&1 && echo "ok" || echo "failed!" \
	      ;; \
	  esac ; \
	done
else
	@$(MSG) GCC_DEBUG_INFO enabled: Skipping strip_target
endif

post_strip_target: $(STRIP_TARGET)

ifeq ($(wildcard $(STRIP_COOKIE)),)
strip: $(STRIP_COOKIE)

$(STRIP_COOKIE): $(POST_STRIP_TARGET)
	$(create_target_dir)
	@touch -f $@
else
strip: ;
endif
	
