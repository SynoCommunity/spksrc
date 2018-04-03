TC_SUBDIRS = $(shell find ./ -name syno-\* -type d)
TC_DIGESTS=$(addsuffix /digests,$(TC_SUBDIRS))
TC_CLEAN=$(addsuffix /clean,$(TC_SUBDIRS))

.PHONY: digests clean $(TC_CLEAN)
digests: $(TC_DIGESTS)
%/digests: %
	$(MAKE) -C $< digests

clean: $(TC_CLEAN)
%/clean: %
	$(MAKE) -C $< clean
