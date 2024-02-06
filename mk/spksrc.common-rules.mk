# Common rules, shared by all makefiles

###

clean:
	rm -fr work work-* build-*.log publish-*.log status-*.log

smart-clean:
	rm -rf $(WORK_DIR)/$(PKG_DIR)
	rm -f $(WORK_DIR)/.$(COOKIE_PREFIX)*

changelog:
	git log --pretty=format:"- %s" -- $(PWD)
