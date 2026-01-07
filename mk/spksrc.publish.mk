###

# make publish-all-<supported|latest>
ifeq (publish,$(findstring publish,$(subst -, ,$(firstword $(MAKECMDGOALS)))))
ACTION=publish-
endif
ifeq ($(PUBLISH_URL),)
TARGET_ARCH=error-publish_url
endif
ifeq ($(PUBLISH_API_KEY),)
TARGET_ARCH=error-api_key
endif

####

.PHONY: $(ACTION)$(TARGET_TYPE)-arch-error-publish_url $(ACTION)$(TARGET_TYPE)-arch-error-api_key

$(ACTION)$(TARGET_TYPE)-arch-error-publish_url:
	@$(MSG) ########################################################
	@$(MSG) ERROR - Set PUBLISH_URL in local.mk
	@$(MSG) ########################################################
	$(error)

$(ACTION)$(TARGET_TYPE)-arch-error-api_key:
	@$(MSG) ########################################################
	@$(MSG) ERROR - Set PUBLISH_API_KEY in local.mk
	@$(MSG) ########################################################
	$(error)

###

.PHONY: publish-all-$(TARGET_TYPE)

publish-all-$(TARGET_TYPE): $(addprefix publish-$(TARGET_TYPE)-arch-,$(TARGET_ARCH))

$(ACTION)$(TARGET_TYPE)-arch-%: $(TARGET_TYPE)-arch-%
	-@MAKEFLAGS= $(MAKE) publish-arch-$*

publish-arch-%:
	$(MAKE) $(addprefix publish-build-arch-, $(or $(filter $(addprefix %, $(DEFAULT_TC)), $(filter %$(word 2,$(subst -, ,$*)), $(filter $(firstword $(subst -, ,$*))%, $(AVAILABLE_TOOLCHAINS)))),$*))

###

publish-build-arch-%: SHELL:=/bin/bash
publish-build-arch-%: build-arch-%
	@$(MSG) PUBLISHING package for arch $* to $(PUBLISH_URL)| tee --append build-$*.log
	@MAKEFLAGS= $(MAKE) ARCH=$(firstword $(subst -, ,$*)) TCVERSION=$(lastword $(subst -, ,$*)) publish 2>&1 | tee --append publish-$*.log >(grep -e '^http' -e '^{"package":' -e '^{"message":' >> status-publish.log) ; \
	status=$${PIPESTATUS[0]} ; \
	[ $${status[0]} -eq 0 ] || false
	
###

publish:
ifeq ($(PUBLISH_URL),)
	$(error Set PUBLISH_URL in local.mk)
endif
ifeq ($(PUBLISH_API_KEY),)
	$(error Set PUBLISH_API_KEY in local.mk)
endif
	@response=$$(PYTHONPATH= http --verify=no --ignore-stdin --auth $(PUBLISH_API_KEY): POST $(PUBLISH_URL)/packages @$(SPK_FILE_NAME) --print=hb) ; \
	response_code=$$(echo "$$response" | grep -Fi "HTTP/1.1" | awk '{print $$2}') ; \
	if [ "$$response_code" = "201" ] ; then \
		output=$$(echo "$$response" | awk '/^[[:space:]]*$$/ {p=1;next} p') ; \
		echo "Package published successfully\n$$output" | tee --append publish-$*.log ; \
	else \
		echo "ERROR: Failed to publish package - HTTP response code $$response_code\n$$response" | tee --append publish-$*.log ; \
		exit 1 ; \
	fi
