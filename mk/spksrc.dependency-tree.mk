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


.PHONY: dependency-tree
dependency-tree:
	@echo `perl -e 'print "\\\t" x $(MAKELEVEL),"\n"'`+ $(NAME) $(PKG_VERS)
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS) ; \
	do \
	  $(MAKE) -s -C ../../$$depend dependency-tree ; \
	done


.PHONY: dependency-list
dependency-list:
	@echo -n "$(NAME): "
	@$(MAKE) -s dependency-flat | grep -P "^(cross|native)" | sort -u | tr '\n' ' \0'
	@echo ""


dependency-flat:
	@echo "$(CURDIR)" | grep -Po "/\K(spk|cross|native|diyspk)/.*"
	@for depend in $(BUILD_DEPENDS) $(DEPENDS) $(OPTIONAL_DEPENDS) ; \
	do \
	  $(MAKE) -s -C ../../$$depend dependency-flat ; \
	done
