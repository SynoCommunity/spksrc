### Wheel rules
#   Create wheels for modules listed in WHEELS. 
#   If CROSS_COMPILE_WHEELS is set via python-cc.mk,
#   wheels are cross-compiled. If not, pure-python 
#   wheels are created.

# Targets are executed in the following order:
#  wheel_download_msg_target
#  pre_wheel_download_target   (override with PRE_WHEEL_DOWNLOAD_TARGET)
#  wheel_download_target       (override with WHEEL_DOWNLOAD_TARGET)
#  post_wheel_download_target  (override with POST_WHEEL_DOWNLOAD_TARGET)
# Variables:
#  REQUIREMENT             Requirement formatted wheel information
#  WHEEL_NAME              Name of wheel to process
#  WHEEL_VERSION           Version of wheel to process (can be empty)
#  WHEEL_TYPE              Type of wheel to process (abi3, crossenv, pure)

ifeq ($(WHEEL_VERSION),)
WHEEL_DOWNLOAD_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_download-$(WHEEL_NAME)_done
else
WHEEL_DOWNLOAD_COOKIE = $(WORK_DIR)/.$(COOKIE_PREFIX)wheel_download-$(WHEEL_NAME)-$(WHEEL_VERSION)_done
endif

##

ifeq ($(strip $(PRE_WHEEL_DOWNLOAD_TARGET)),)
PRE_WHEEL_DOWNLOAD_TARGET = pre_wheel_download_target
else
$(PRE_WHEEL_DOWNLOAD_TARGET): wheel_download_msg_target
endif
ifeq ($(strip $(WHEEL_DOWNLOAD_TARGET)),)
WHEEL_DOWNLOAD_TARGET = wheel_download_target
else
$(WHEEL_DOWNLOAD_TARGET): $(BUILD_WHEEL_DOWNLOAD_TARGET)
endif
ifeq ($(strip $(POST_WHEEL_DOWNLOAD_TARGET)),)
POST_WHEEL_DOWNLOAD_TARGET = post_wheel_download_target
else
$(POST_WHEEL_DOWNLOAD_TARGET): $(WHEEL_DOWNLOAD_TARGET)
endif

wheel_download_msg_target:
	@$(MSG) "Processing wheels of $(NAME)"

pre_wheel_download_target: wheel_download_msg_target

wheel_download_target: SHELL:=/bin/bash
wheel_download_target:
ifeq ($(wildcard $(PIP_DISTRIB_DIR)),)
	@$(MSG) Creating pip download directory: $(PIP_DISTRIB_DIR)
	@mkdir -p $(PIP_DISTRIB_DIR)
endif
ifeq ($(wildcard $(PIP_CACHE_DIR)),)
	@$(MSG) Creating pip caching directory: $(PIP_CACHE_DIR)
	@mkdir -p $(PIP_CACHE_DIR)
endif
ifeq ($(wildcard $(WHEELHOUSE)),)
	@$(MSG) Creating wheelhouse directory: $(WHEELHOUSE)
	@mkdir -p $(WHEELHOUSE)
endif
	@$(MSG) Downloading wheel [$(WHEEL_NAME)], version [$(WHEEL_VERSION)] ; \
#	$(MSG) requirement: [$(REQUIREMENT)] ; \
#	$(MSG) requirement-grep-egg: [$$(grep -s egg <<< $(REQUIREMENT))] ; \
#	$(MSG) name: [$(WHEEL_NAME)] ; \
#	$(MSG) type: [$(WHEEL_TYPE)] ; \
#	$(MSG) version: [$(WHEEL_VERSION)] ; \
#	$(MSG) type: [$(WHEEL_TYPE)] ; \
	if [ "$$(grep -s egg <<< $(REQUIREMENT))" ] ; then \
	   echo "WARNING: Skipping download URL - Downloaded at build time" ; \
	else \
	   query="curl -s https://pypi.org/pypi/$(WHEEL_NAME)/json" ; \
	   query+=" | jq -r '.releases[][]" ; \
	   query+=" | select(.packagetype==\"sdist\")" ; \
	   query+=" | select((.filename|test(\"-$(WHEEL_VERSION).tar.gz\")) or (.filename|test(\"-$(WHEEL_VERSION).zip\"))) | .url'" ; \
	   outFile=$$(basename $$(eval $${query} 2>/dev/null) 2</dev/null) ; \
	   if [ "$${outFile}" = "" ]; then \
	      echo "ERROR: Invalid package name [$(WHEEL_NAME)]" ; \
	   elif [ -s $(PIP_DISTRIB_DIR)/$${outFile} ]; then \
	      echo "INFO: File already exists [$${outFile}]" ; \
	   else \
	      echo "wget --secure-protocol=TLSv1_2 -nv -O $(PIP_DISTRIB_DIR)/$${outFile}.part -nc $$(eval $${query})" ; \
	      wget --secure-protocol=TLSv1_2 -nv -O $(PIP_DISTRIB_DIR)/$${outFile}.part -nc $$(eval $${query}) ; \
	      mv $(PIP_DISTRIB_DIR)/$${outFile}.part $(PIP_DISTRIB_DIR)/$${outFile} ; \
	   fi ; \
	fi ; \
	case $(WHEEL_TYPE) in \
	       abi3) $(MSG) Adding $(WHEEL_NAME)==$$(WHEEL_VERSION) to wheelhouse/$(WHEELS_LIMITED_API) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_LIMITED_API) ; \
	             ;; \
	   crossenv) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_CROSSENV_COMPILE) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_CROSSENV_COMPILE) ; \
	             ;; \
	       pure) $(MSG) Adding $(WHEEL_NAME)==$(WHEEL_VERSION) to wheelhouse/$(WHEELS_PURE_PYTHON) ; \
	             echo $(WHEEL_NAME)==$(WHEEL_VERSION) | sed -e '/^[[:blank:]]*$$\|^#/d' >> $(WHEELHOUSE)/$(WHEELS_PURE_PYTHON) ; \
	             ;; \
	          *) $(MSG) No type found for wheel [$(REQUIREMENT)] ; \
	             ;; \
	esac
	@for file in $$(ls -1 $(WHEELHOUSE)/requirements-*.txt) ; do \
	   sort -u -o $${file}{,} ; \
	done

post_wheel_download_target: $(WHEEL_DOWNLOAD_TARGET)


ifeq ($(wildcard $(WHEEL_DOWNLOAD_COOKIE)),)
wheel_download: $(WHEEL_DOWNLOAD_COOKIE)

$(WHEEL_DOWNLOAD_COOKIE): $(POST_WHEEL_DOWNLOAD_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel_download: ;
endif
