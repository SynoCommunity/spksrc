### generate text output of package dependencies
### dependency-tree:
### - print a tree of the package dependencies
### dependency-list:
### - print a list of the package dependencies
###   single line output starts with $(NAME): follwed by a list of all dependencies.
###   the dependencies include the folder (cross or native).
###   the list is sorted and does not include duplicate dependencies.
###   sample:
###   minio: cross/busybox cross/minio native/go native/go-1.4
### 
### NOTES:
### o Packages with conditional dependencies must define such dependencies 
###   additionally with OPTIONAL_DEPENDS, otherwise not all dependencies are found.
### 
### o dependency-tree and dependency-list call make for all dependencies without 
###   the definition of specific ARCH nor TCVERSION.
###   Therefore every Makefile (including mk/*.mk) must not abort nor put 
###   output with error, warning or info directive when the variable 
###   DEPENDENCY_WALK is set to 1.
### 

.PHONY: dependency-tree
dependency-tree:
	@echo $$(perl -e 'print "\\\t" x $(MAKELEVEL),"\n"')+ $(NAME) $(PKG_VERS)
	@for depend in $$(echo "$(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS)" | tr ' ' '\n' | sort -u | tr '\n' ' ') ; \
	do \
	  DEPENDENCY_WALK=1 $(MAKE) -s -C ../../$$depend dependency-tree ; \
	done


.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s dependency-flat | grep -P "^(cross|python|native)" | sort -u | tr '\n' ' \0'
	@echo ""


HEAD_DIR = $$(echo $(CURDIR) | grep -Po '/\K(spk|cross|python|native|diyspk|toolchain)/.*')
TMP_DONE ?= /tmp/spksrc-dependency-flat-done

.PHONY: dependency-flat
dependency-flat:
	@rm -rf $(TMP_DONE)
	@mkdir -p $(TMP_DONE)
	@echo $(HEAD_DIR)
	@$(MAKE) -s _dependency-flat-parallel DIR=$(CURDIR) DEPENDENCY_WALK=1 | sort -u | grep -v -F "$(HEAD_DIR)"
	@rm -rf $(TMP_DONE)

.PHONY: _dependency-flat-parallel
_dependency-flat-parallel:
	@mkdir -p $(TMP_DONE)
	@KEY=$$(echo $(CURDIR) | grep -Po '/\K(spk|cross|python|native|diyspk|toolchain)/.*' | tr '/' '_'); \
	if [ ! -f "$(TMP_DONE)/$$KEY" ]; then \
		DEPS="$$(echo "$(NATIVE_DEPENDS) $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS)" | tr ' ' '\n' | sort -u)"; \
		PIDS=""; \
		for dep in $$DEPS; do \
			DEP_KEY=$$(echo "$$dep" | tr '/' '_'); \
			if [ -d ../../$$dep ] && [ ! -f "$(TMP_DONE)/$$DEP_KEY" ]; then \
				$(MAKE) -s -C ../../$$dep _dependency-flat-parallel DEPENDENCY_WALK=1 & \
				PIDS="$$PIDS $$!"; \
			fi; \
		done; \
		for pid in $$PIDS; do wait $$pid; done; \
		touch "$(TMP_DONE)/$$KEY"; \
		echo "$$(echo $(CURDIR) | grep -Po '/\K(spk|cross|python|native|diyspk|toolchain)/.*')"; \
	fi

### 
