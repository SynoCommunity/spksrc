# general rule for "make digests"
# 
# include this file after the rule "all:"
#

$(DIGESTS_FILE): download
	@$(MSG) "Generating digests for $(NAME)"
	@rm -f $@ && touch -f $@
	@for type in SHA1 SHA256 MD5; do \
	  case $$type in \
	    SHA1)     tool=sha1sum ;; \
	    SHA256)   tool=sha256sum ;; \
	    MD5)      tool=md5sum ;; \
	  esac ; \
	  echo "$(LOCAL_FILE) $$type `$$tool $(DIST_FILE) | cut -d\" \" -f1`" >> $@ ; \
	done
