### Wheel rules
# Download wheels for modules listed in WHEELS. 
#
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
	@$(MSG) Downloading wheel [$(WHEEL_NAME)], version [$(WHEEL_VERSION)] ; \
	if [ "$$(grep -Eo 'http://|https://' <<< $(REQUIREMENT))" ] ; then \
	   echo "WARNING: Skipping download URL - Downloaded at build time" ; \
	elif [ "$(WHEEL_TYPE)" = "pure" ] && [ ! "$(WHEELS_PURE_PYTHON_PACKAGING_ENABLE)" = "1" ]; then \
	   echo "WARNING: Skipping download - pure python packaging disabled" ; \
	else \
	   query="curl -s https://pypi.org/pypi/$(WHEEL_NAME)/json" ; \
	   query+=" | jq -r '.releases[][]" ; \
	   query+=" | select(.packagetype==\"sdist\")" ; \
	   query+=" | select((.filename|test(\"-$(WHEEL_VERSION).tar.gz\")) or (.filename|test(\"-$(WHEEL_VERSION).zip\"))) | .url'" ; \
	   outFile=$$(basename $$(eval $${query} 2>/dev/null) 2</dev/null) ; \
	   if [ "$${outFile}" = "" ]; then \
	      echo "ERROR: Unable to find version on pypi.org for [$(WHEEL_NAME)]" ; \
	   elif [ -s $(PIP_DISTRIB_DIR)/$${outFile} ]; then \
	      echo "INFO: File already exists [$${outFile}]" ; \
	   else \
	      echo "wget --secure-protocol=TLSv1_2 -nv -O $(PIP_DISTRIB_DIR)/$${outFile}.part -nc $$(eval $${query})" ; \
	      wget --secure-protocol=TLSv1_2 -nv -O $(PIP_DISTRIB_DIR)/$${outFile}.part -nc $$(eval $${query}) ; \
	      mv $(PIP_DISTRIB_DIR)/$${outFile}.part $(PIP_DISTRIB_DIR)/$${outFile} ; \
	   fi ; \
	fi

post_wheel_download_target: $(WHEEL_DOWNLOAD_TARGET)

ifeq ($(wildcard $(WHEEL_DOWNLOAD_COOKIE)),)
wheel_download: $(WHEEL_DOWNLOAD_COOKIE)

$(WHEEL_DOWNLOAD_COOKIE): $(POST_WHEEL_DOWNLOAD_TARGET)
	$(create_target_dir)
	@touch -f $@
else
wheel_download: ;
endif
