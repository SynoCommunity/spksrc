### Download rules
#   Download $(URLS) from the wild internet, and place them in $(DISTRIB_DIR). 
# Target are executed in the following order:
#  download_msg_target
#  pre_download_target   (override with PRE_DOWNLOAD_TARGET)
#  download_target       (override with DOWNLOAD_TARGET)
#  post_download_target  (override with POST_DOWNLOAD_TARGET)
# Variables:
#  URLS:                 List of URL to download
#  DISTRIB_DIR:          Downloaded files will be placed there.  


DOWNLOAD_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)download_done

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
	@$(MSG) "Downloading files for $(NAME)"

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

download_target: $(PRE_DOWNLOAD_TARGET)
	@mkdir -p $(DISTRIB_DIR)
	@cd $(DISTRIB_DIR) &&  for url in $(URLS) ; \
	do \
	  case "$(PKG_DOWNLOAD_METHOD)" in \
	    git) \
	      localFolder=$(NAME)-git$(PKG_GIT_HASH) ; \
	      localFile=$${localFolder}.tar.gz ; \
	      if [ ! -f $${localFile} ]; then \
	        rm -fr $${localFolder}.part ; \
	        echo "git clone $${url}" ; \
	        git clone --no-checkout --quiet $${url} $${localFolder}.part ; \
	        git --git-dir=$${localFolder}.part/.git --work-tree=$${localFolder}.part checkout --quiet $(PKG_GIT_HASH) ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        tar --exclude-vcs -czf $${localFile} $${localFolder} ; \
	        rm -fr $${localFolder} ; \
	      else \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      fi ; \
	      ;; \
	    svn) \
	      if [ "$(PKG_SVN_REV)" = "HEAD" ]; then \
	        rev=`svn info --xml $${url} | xmllint --xpath 'string(/info/entry/@revision)' -` ; \
	      else \
	        rev=$(PKG_SVN_REV) ; \
	      fi ; \
	      localFolder=$(NAME)-r$${rev} ; \
	      localFile=$${localFolder}.tar.gz ; \
	      localHead=$(NAME)-rHEAD.tar.gz ; \
	      if [ ! -f $${localFile} ]; then \
	        rm -fr $${localFolder}.part ; \
	        echo "svn co -r $${rev} $${url}" ; \
	        svn export -q -r $${rev} $${url} $${localFolder}.part ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        tar --exclude-vcs -czf $${localFile} $${localFolder} ; \
	        rm -fr $${localFolder} ; \
	      else \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      fi ; \
	      if [ "$(PKG_SVN_REV)" = "HEAD" ]; then \
	        rm -f $${localHead} ; \
	        ln -s $${localFile} $${localHead} ; \
	      fi ; \
	      ;; \
	    hg) \
	      if [ "$(PKG_HG_REV)" = "tip" ]; then \
	        rev=`hg identify -r "tip" $${url}` ; \
	      else \
	        rev=$(PKG_HG_REV) ; \
	      fi ; \
	      localFolder=$(NAME)-r$${rev} ; \
	      localFile=$${localFolder}.tar.gz ; \
	      localTip=$(NAME)-rtip.tar.gz ; \
	      if [ ! -f $${localFile} ]; then \
	        rm -fr $${localFolder}.part ; \
	        echo "hg clone -r $${rev} $${url}" ; \
	        hg clone -r $${rev} $${url} $${localFolder}.part ; \
	        mv $${localFolder}.part $${localFolder} ; \
	        tar --exclude-vcs -czf $${localFile} $${localFolder} ; \
	        rm -fr $${localFolder} ; \
	      else \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      fi ; \
	      if [ "$(PKG_HG_REV)" = "tip" ]; then \
	        rm -f $${localTip} ; \
	        ln -s $${localFile} $${localTip} ; \
	      fi ; \
	      ;; \
	    *) \
	      localFile=$(PKG_DIST_FILE) ; \
	      if [ -z "$${localFile}" ]; then \
	        localFile=`basename $${url}` ; \
	      fi ; \
	      if [ ! -f $${localFile} ]; then \
	        rm -f $${localFile}.part ; \
	        url=`echo $${url} | sed -e '#^\(http://sourceforge\.net/.*\)$#\1?use_mirror=autoselect#'` ; \
	        echo "wget $${url}" ; \
	        wget $(DOWNLOAD_ARGS) -nv -O $${localFile}.part $${url} ; \
	        mv $${localFile}.part $${localFile} ; \
	      else \
	        $(MSG) "  File $${localFile} already downloaded" ; \
	      fi ; \
	      ;; \
	  esac ; \
	done

post_download_target: $(DOWNLOAD_TARGET) 

ifeq ($(wildcard $(DOWNLOAD_COOKIE)),)
download: $(DOWNLOAD_COOKIE)

$(DOWNLOAD_COOKIE): $(POST_DOWNLOAD_TARGET)
	$(create_target_dir)
	@touch -f $@
else
download: ;
endif
