###############################################################################
# spksrc.overlay/dist-arch.mk
#
# $(call overlay_dist_arch,<arch>,<dsm>): the arch an overlay archive for <arch>-<dsm> is
# named after. <arch> itself, unless its base toolchain is a generic one declaring several
# TC_ARCH (x64, armv7, aarch64): then the real arch of the same DSM version whose base
# toolchain is the same archive (TC_DIST). Same toolchain in, same overlay out -- one build
# serves both, and both sides of the archive name agree on it:
#
#   producer  native/<component>   names the archive it publishes
#   consumer  overlay/<dir>        names the archive it downloads
#
# Reads the toolchain Makefiles, in sorted order, so the answer is stable; a single
# shell, and only producers and consumers ever expand it -- never a package build.
###############################################################################

overlay_dist_arch = $(shell cd $(CURDIR)/../../toolchain && \
  if [ $$(sed -n 's/^TC_ARCH *= *//p' syno-$(1)-$(2)/Makefile | wc -w) -le 1 ] ; then echo $(1) ; else \
    dist=$$(sed -n 's/^TC_DIST *= *//p' syno-$(1)-$(2)/Makefile) ; \
    for tc in syno-*-$(2) ; do \
      [ "$$tc" = "syno-$(1)-$(2)" ] && continue ; \
      [ $$(sed -n 's/^TC_ARCH *= *//p' $$tc/Makefile | wc -w) -eq 1 ] || continue ; \
      [ "$$(sed -n 's/^TC_DIST *= *//p' $$tc/Makefile)" = "$$dist" ] || continue ; \
      tc=$${tc#syno-} ; echo $${tc%-$(2)} ; break ; \
    done ; \
  fi)
