###############################################################################
# spksrc.build/download.mk
#
# Download $(URLS) from the wild internet, and place them in $(DISTRIB_DIR).
#
# Targets are executed in the following order:
#  download_msg_target
#  pre_download_target    (override with PRE_DOWNLOAD_TARGET)
#  download_target        (override with DOWNLOAD_TARGET)
#  post_download_target   (override with POST_DOWNLOAD_TARGET)
#
# Variables:
#  URLS                   : List of URLs to download
#  DISTRIB_DIR            : Destination directory for downloaded files
#  PKG_DIST_ARCH_LIST     : Optional list of distribution architectures
#                           (2 or more entries enable multi-arch orchestration)
#  PKG_DIST_ARCH          : Optional current distribution architecture
#                           (single element used during leaf execution)
#  PKG_DIST_MIRRORS       : Optional per-package fallback base URLs; the file
#                           name is appended to each and tried in turn.
#
# Files:
#  $(WORK_DIR)/.$(COOKIE_PREFIX)download_done
#                          Generic download completion cookie
#                          (used when PKG_DIST_ARCH is unset)
#  $(WORK_DIR)/.$(COOKIE_PREFIX)<arch>-download_done
#                          Architecture-specific download completion cookie
#                          (used when PKG_DIST_ARCH is set)
#
# Notes:
#  - The download target is idempotent and guarded by a completion cookie.
#  - Per download method, the actual work lives in a DOWNLOAD_<METHOD> macro
#    (git / svn / hg / http) selected by PKG_DOWNLOAD_METHOD; download_target
#    only loops over $(URLS) and dispatches to the right macro.
#  - For plain (http) downloads a failed mirror is retried on the next mirror
#    (see the mirror table below) before giving up.
#  - When PKG_DIST_ARCH is unset, a single generic cookie is used, preserving
#    the classic single-archive behavior.
#  - When PKG_DIST_ARCH is set, the cookie is architecture-specific, allowing
#    multiple downloads to coexist for multi-architecture packages.
#  - When PKG_DIST_ARCH_LIST contains 2 or more elements, download acts as an
#    orchestrator and invokes sub-make executions per architecture.
#  - Sub-make calls force PKG_DIST_ARCH_LIST to a single element to ensure
#    leaf execution and avoid recursive orchestration.
#
###############################################################################

# Configure file descriptor lock timeout
ifeq ($(strip $(FLOCK_TIMEOUT)),)
FLOCK_TIMEOUT = 300
endif

ifneq ($(strip $(PKG_DIST_ARCH)),)
DOWNLOAD_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)$(PKG_DIST_ARCH)-download_done
else
DOWNLOAD_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)download_done
endif

ifeq ($(strip $(PRE_DOWNLOAD_TARGET)),)
PRE_DOWNLOAD_TARGET = pre_download_target
else
$(PRE_DOWNLOAD_TARGET): download_msg
endif
ifneq (,$(findstring manual,$(strip $(DOWNLOAD_TARGET))))
DOWNLOAD_TARGET = manual_dl_target
else
  ifeq ($(strip $(DOWNLOAD_TARGET)),)
  DOWNLOAD_TARGET = download_target
  else
  $(DOWNLOAD_TARGET): $(PRE_DOWNLOAD_TARGET)
  endif
endif
ifeq ($(strip $(POST_DOWNLOAD_TARGET)),)
POST_DOWNLOAD_TARGET = post_download_target
else
$(POST_DOWNLOAD_TARGET): $(DOWNLOAD_TARGET)
endif

.PHONY: download download_msg
.PHONY: $(PRE_DOWNLOAD_TARGET) $(DOWNLOAD_TARGET) $(POST_DOWNLOAD_TARGET)

download_msg:
ifeq ($(strip $(PKG_DIST_ARCH)),)
	@$(MSG) "Downloading files for $(NAME)"
else
	@$(MSG) "Downloading files for $(NAME) [$(PKG_DIST_ARCH)]"
endif

manual_dl_target:
	@manual_dl=$(PKG_DIST_FILE) ; \
	if [ -z "$$manual_dl" ] ; then \
	  manual_dl=$(PKG_DIST_NAME) ; \
	fi ; \
	if [ -f "$(DISTRIB_DIR)/$$manual_dl" ] ; then \
	  $(MSG) "File $$manual_dl already downloaded" ; \
	else \
	  $(MSG) "*** Manually download $$manual_dl from $(PKG_DIST_SITE) and place in $(DISTRIB_DIR). Stop." ; \
	exit 1 ; \
	fi ; \

pre_download_target: download_msg

# ---------------------------------------------------------------------------
# Mirror table (plain http downloads)
#
# A download is first attempted from its original URL (only SourceForge project
# pages are canonicalised to a downloadable host); on failure the same path is
# retried from each mirror base below, in order. This table is the single source
# of truth for mirrors - there is no per-family URL rewrite - so for GNU the
# geo-redirector ftpmirror.gnu.org is just another entry. A mirror candidate is
# built by replacing everything up to and including the family's tree-root marker
# with the mirror base, so mirrors that host the tree under a different prefix
# are handled correctly. PKG_DIST_MIRRORS adds extra per-package base URLs (file
# name appended). Non-matching URLs (e.g. GitHub) just use the single original URL.
# ---------------------------------------------------------------------------
# Per-host wget attempts. The overall work is bounded: at most
# (number of mirror candidates) x DOWNLOAD_TRIES attempts, and the candidate
# list is finite (primary URL + the family mirrors + PKG_DIST_MIRRORS, then
# de-duplicated), so a failing download can never loop indefinitely.
DOWNLOAD_TRIES      ?= 2
GNU_MIRRORS         ?= https://ftpmirror.gnu.org/gnu https://ftp.gnu.org/gnu https://mirrors.kernel.org/gnu https://mirror.csclub.uwaterloo.ca/gnu
SOURCEFORGE_MIRRORS ?= https://downloads.sourceforge.net/project https://netcologne.dl.sourceforge.net/project https://phoenixnap.dl.sourceforge.net/project
GNOME_MIRRORS       ?= https://download.gnome.org/sources https://mirror.csclub.uwaterloo.ca/gnome/sources
XORG_MIRRORS        ?= https://www.x.org/releases https://mirror.csclub.uwaterloo.ca/x.org/releases
KERNEL_MIRRORS      ?= https://cdn.kernel.org/pub https://mirrors.kernel.org/pub https://www.kernel.org/pub
PKG_DIST_MIRRORS    ?=

# ---------------------------------------------------------------------------
# Per-method download macros, spliced into download_target's case below.
# Each ends with ';;' to close its case entry.
# ---------------------------------------------------------------------------
define DOWNLOAD_GIT
	      localFolder=$(NAME)-git$(PKG_GIT_HASH) ; \
	      localFile=$${localFolder}.tar.gz ; \
	      exec 6> /tmp/git.$${localFolder}.lock ; \
	      flock --timeout $(FLOCK_TIMEOUT) --exclusive 6 || exit 1 ; \
	      pid=$$$$ ; \
	      echo "$${pid}" 1>&6 ; \
	      if [ -f $${localFile} ]; then \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      else \
	        $(MSG) "  git clone --no-checkout --quiet $${url}" ; \
	        rm -fr $${localFolder} $${localFolder}.part ; \
	        git clone --no-checkout --quiet $${url} $${localFolder}.part ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        git --git-dir=$${localFolder}/.git --work-tree=$${localFolder} archive --prefix=$${localFolder}/ -o $${localFile} $(PKG_GIT_HASH) ; \
	        rm -fr $${localFolder} ; \
	      fi ; \
	      flock -u 6 ; \
	      ;;
endef

define DOWNLOAD_SVN
	      if [ "$(PKG_SVN_REV)" = "HEAD" ]; then \
	        rev=$$(svn info --xml $${url} | xmllint --xpath 'string(/info/entry/@revision)' -) ; \
	      else \
	        rev=$(PKG_SVN_REV) ; \
	      fi ; \
	      localFolder=$(NAME)-r$${rev} ; \
	      localFile=$${localFolder}.tar.gz ; \
	      localHead=$(NAME)-rHEAD.tar.gz ; \
	      exec 7> /tmp/svn.$${localFolder}.lock ; \
	      flock --timeout $(FLOCK_TIMEOUT) --exclusive 7 || exit 1 ; \
	      pid=$$$$ ; \
	      echo "$${pid}" 1>&7 ; \
	      if [ -f $${localFile} ]; then \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      else \
	        $(MSG) "  svn co -r $${rev} $${url}" ; \
	        rm -fr $${localFolder} $${localFolder}.part ; \
	        svn export -q -r $${rev} $${url} $${localFolder}.part ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        tar --exclude-vcs -c $${localFolder} | gzip -n > $${localFile} ; \
	        rm -fr $${localFolder} ; \
	      fi ; \
	      flock -u 7 ; \
	      if [ "$(PKG_SVN_REV)" = "HEAD" ]; then \
	        rm -f $${localHead} ; \
	        ln -s $${localFile} $${localHead} ; \
	      fi ; \
	      ;;
endef

define DOWNLOAD_HG
	      if [ "$(PKG_HG_REV)" = "tip" ]; then \
	        rev=$$(hg identify -r "tip" $${url}) ; \
	      else \
	        rev=$(PKG_HG_REV) ; \
	      fi ; \
	      localFolder=$(NAME)-r$${rev} ; \
	      localFile=$${localFolder}.tar.gz ; \
	      localTip=$(NAME)-rtip.tar.gz ; \
	      exec 8> /tmp/hg.$${localFolder}.lock ; \
	      flock --timeout $(FLOCK_TIMEOUT) --exclusive 8 || exit 1 ; \
	      pid=$$$$ ; \
	      echo "$${pid}" 1>&8 ; \
	      if [ -f $${localFile} ]; then \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      else \
	        $(MSG) "  hg clone -r $${rev} $${url}" ; \
	        rm -fr $${localFolder} $${localFolder}.part ; \
	        hg clone -r $${rev} $${url} $${localFolder}.part ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        tar --exclude-vcs -c $${localFolder} | gzip -n > $${localFile} ; \
	        rm -fr $${localFolder} ; \
	      fi ; \
	      flock -u 8 ; \
	      if [ "$(PKG_HG_REV)" = "tip" ]; then \
	        rm -f $${localTip} ; \
	        ln -s $${localFile} $${localTip} ; \
	      fi ; \
	      ;;
endef

define DOWNLOAD_HTTP
	      localFile=$(PKG_DIST_FILE) ; \
	      if [ -z "$${localFile}" ]; then \
	        localFile=$$(basename $${url}) ; \
	      fi ; \
	      url=$$(echo $${url} | sed -E -e 's#//sourceforge\.net/projects/([^/]+)/files/#//downloads.sourceforge.net/project/\1/#g' \
	                                   -e 's#//downloads\.sourceforge\.net/projects/([^/]+)/files/#//downloads.sourceforge.net/project/\1/#g') ; \
	      exec 9> /tmp/wget.$${localFile}.lock ; \
	      flock --timeout $(FLOCK_TIMEOUT) --exclusive 9 || exit 1 ; \
	      pid=$$$$ ; \
	      echo "$${pid}" 1>&9 ; \
	      if [ -f $${localFile} ]; then \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      else \
	        rm -f $${localFile}.part ; \
	        mirrorUrls="$${url}" ; \
	        marker="" ; mirrorBases="" ; \
	        case "$${url}" in \
	          *//ftpmirror.gnu.org/gnu/*|*//ftp.gnu.org/gnu/*)  marker="/gnu/" ;     mirrorBases="$(GNU_MIRRORS)" ;; \
	          *//downloads.sourceforge.net/project/*)           marker="/project/" ; mirrorBases="$(SOURCEFORGE_MIRRORS)" ;; \
	          *//download.gnome.org/sources/*)                  marker="/sources/" ; mirrorBases="$(GNOME_MIRRORS)" ;; \
	          *//www.x.org/releases/*|*//x.org/releases/*)      marker="/releases/" ; mirrorBases="$(XORG_MIRRORS)" ;; \
	          *//www.kernel.org/pub/*|*//cdn.kernel.org/pub/*)  marker="/pub/" ;     mirrorBases="$(KERNEL_MIRRORS)" ;; \
	        esac ; \
	        if [ -n "$${marker}" ]; then \
	          tail=$${url#*$${marker}} ; \
	          for b in $${mirrorBases} ; do mirrorUrls="$${mirrorUrls} $${b%/}/$${tail}" ; done ; \
	        fi ; \
	        for m in $(PKG_DIST_MIRRORS) ; do mirrorUrls="$${mirrorUrls} $${m%/}/$${localFile}" ; done ; \
	        uniqUrls="" ; \
	        for u in $${mirrorUrls} ; do case " $${uniqUrls} " in *" $${u} "*) ;; *) uniqUrls="$${uniqUrls} $${u}" ;; esac ; done ; \
	        mirrorUrls="$${uniqUrls}" ; \
	        downloaded=0 ; \
	        for tryUrl in $${mirrorUrls} ; do \
	          $(MSG) "  wget -O $${localFile} $${tryUrl}" ; \
	          if wget --secure-protocol=TLSv1_2 --timeout=30 --tries=$(DOWNLOAD_TRIES) --waitretry=10 \
	                  --retry-connrefused --max-redirect=20 --content-disposition \
	                  --retry-on-http-error=429,500,502,503,504 \
	                  -nv -O $${localFile}.part -nc $${tryUrl} ; then \
	            downloaded=1 ; break ; \
	          fi ; \
	          $(MSG) "  ==> download failed, trying next mirror" ; \
	          rm -f $${localFile}.part ; \
	        done ; \
	        if [ $${downloaded} -ne 1 ]; then \
	          $(MSG) "*** All mirrors failed for $${localFile}. Stop." ; \
	          flock -u 9 ; \
	          exit 1 ; \
	        fi ; \
	        mv $${localFile}.part $${localFile} ; \
	      fi ; \
	      flock -u 9 ; \
	      ;;
endef

download_target: $(PRE_DOWNLOAD_TARGET)
	@mkdir -p $(DISTRIB_DIR)
	@cd $(DISTRIB_DIR) && for url in $(URLS) ; \
	do \
	  case "$(PKG_DOWNLOAD_METHOD)" in \
	    git) $(DOWNLOAD_GIT) \
	    svn) $(DOWNLOAD_SVN) \
	    hg)  $(DOWNLOAD_HG) \
	    *)   $(DOWNLOAD_HTTP) \
	  esac ; \
	done

# Multi-arch orchestration:
# - words(PKG_DIST_ARCH_LIST) >= 2 → iterate over architectures
# - words(PKG_DIST_ARCH_LIST) <= 1 → single execution
ifeq ($(filter 0 1,$(words $(PKG_DIST_ARCH_LIST))),)
post_download_target:
	@for pkg_arch in $(PKG_DIST_ARCH_LIST); do \
	  rm -f $(DOWNLOAD_COOKIE) ; \
	  $(MAKE) -s \
	    PKG_DIST_ARCH_LIST=$${pkg_arch} \
	    PKG_DIST_ARCH=$${pkg_arch} \
	    download ; \
	done ;
else
post_download_target: $(DOWNLOAD_TARGET)
endif

ifeq ($(wildcard $(DOWNLOAD_COOKIE)),)
download: $(DOWNLOAD_COOKIE)

$(DOWNLOAD_COOKIE): $(POST_DOWNLOAD_TARGET)
	$(create_target_dir)
	@touch -f $@
else
download: ;
endif
