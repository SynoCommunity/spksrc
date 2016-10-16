# This Makefile provides a prepare target
# to generate URLs and digests files
# for Gogs package and their Glide dependencies
# This file must be included by Makefile



GLIDE_URL = https://$(subst github.com,raw.githubusercontent.com,$(PKG_GO_NAME))/v$(PKG_VERS)/glide.lock
GLIDE_FILE = glide.lock
GLIDE_FILE_SHA256 ?= 

PREP_URLS_FILE = URLS
PREP_DISTFILES_FILE = DIST_FILES
WORKPREP_DIR= $(WORK_DIR)-prepare

# Defile variables with file contents
ifeq ($(findstring prepare,$(MAKECMDGOALS)),)
PREPARED_URLS = $(shell cat $(PREP_URLS_FILE))
PREPARED_DIST_FILES = $(shell cat $(PREP_DISTFILES_FILE) | awk ' {print $$1 }')
PREPARED_EXTRACT_PATH=$(shell cat $(PREP_DISTFILES_FILE) | grep $@ | awk '{print $$2}')
else
PREPARED_URLS =
PREPARED_DIST_FILES =
PREPARED_EXTRACT_PATH =
endif



.PHONY: prepare unprepare 
prepare: preprepare prepare-distflies prepare-urls

preprepare:
	@$(MSG) "Preparing $(PKG_NAME) makefiles"
	mkdir -p $(WORKPREP_DIR)

download-glide: preprepare
	@$(MSG) "  Downloading glide.lock"
	@if [ ! -f  $(WORKPREP_DIR)/$(GLIDE_FILE) ]; then \
          echo "wget $(GLIDE_URL) -O $(WORKPREP_DIR)/$(GLIDE_FILE).part" ; \
          wget $(GLIDE_URL) -nv -O $(WORKPREP_DIR)/$(GLIDE_FILE).part; \
          mv  $(WORKPREP_DIR)/$(GLIDE_FILE).part  $(WORKPREP_DIR)/$(GLIDE_FILE); \
        else \
          $(MSG) "    glide.lock already downloaded"; \
        fi;

verify-glide: download-glide
	@if [ "$(GLIDE_FILE_SHA256)" != "" ]; then \
	  $(MSG) "  Verifying glide.lock"; \
	  cd $(WORKPREP_DIR)/; \
	  if echo "$(GLIDE_FILE_SHA256)  $(GLIDE_FILE)" | sha256sum --status -c - ; then \
	    true ; \
	  else  \
	    $(MSG) "    Wrong sha256sum for file $(GLIDE_FILE)" ; \
	    [ -f $(GLIDE_FILE).wrong ] && rm $(GLIDE_FILE).wrong ; \
	    mv $(GLIDE_FILE) $(GLIDE_FILE).wrong ; \
	    $(MSG) "    Renamed as $(GLIDE_FILE).wrong" ; \
	    false; \
	  fi; \
	fi

check-prepare-distfiles:
	@if [ ! -f "$(PREP_DISTFILES_FILE)" ]; then \
	  $(MSG) "    $(PREP_DISTFILES_FILE) file not exists"; \
	  $(MSG) "    run make prepare to generate it."; \
	  false; \
	fi

check-prepare-urls:
	@if [ ! -f "$(PREP_URLS_FILE)" ]; then \
          $(MSG) "    $(PREP_URLS_FILE) file not exists"; \
	  $(MSG) "    run make prepare to generate it."; \
          false; \
        fi

prepare-distflies: verify-glide
	@$(MSG) "  Preparing $(PREP_DISTFILES_FILE) file"
	@if [ ! -f $(PREP_DISTFILES_FILE) ]; then\
	  echo "$(PKG_DIST_NAME)  $(PKG_GO_NAME)" > $(WORKPREP_DIR)/$(PREP_DISTFILES_FILE); \
	  cat $(WORKPREP_DIR)/$(GLIDE_FILE) | awk  -F ": " \
            '     /^- name:/ { name=$$2 } \
                  /^  version:/ { version=$$2; print version ".tar.gz  " name } \
            ' >>  $(WORKPREP_DIR)/$(PREP_DISTFILES_FILE) ; \
	  mv $(WORKPREP_DIR)/$(PREP_DISTFILES_FILE) $(PWD) ;\
	else \
	  $(MSG) "    $(PREP_DISTFILES_FILE) already exists"; \
	fi

prepare-urls: verify-glide
	@$(MSG) "  Preparing $(PREP_URLS_FILE) file"
	@if [ ! -f $(PREP_URLS_FILE) ]; then\
          echo "https://$(PKG_GO_NAME)/archive/v$(PKG_VERS).$(PKG_EXT)" > $(WORKPREP_DIR)/$(PREP_URLS_FILE) ; \
          cat $(WORKPREP_DIR)/$(GLIDE_FILE)  | awk  -F ": " \
          '     /^- name:/ {repo=$$2; name=$$2 } \
                /golang\.org/ {split($$2 ,repo_name, "/"); repo= "github.com/golang/" repo_name[3]  } \
                /gopkg\.in/ { \
                  split($$2 ,tmp_repo_name, "/"); \
                  if (tmp_repo_name[3] != "") { \
                    split(tmp_repo_name[3],repo_name, "."); \
                    repo="github.com/" tmp_repo_name[2] "/" repo_name[1]; \
                  } else { \
                    split(tmp_repo_name[2],repo_name, "."); \
                    repo="github.com/go-" repo_name[1] "/" repo_name[1]; \
                 } \
                } \
                /^  version:/ {version=$$2; print "https://" repo "/archive/" version ".tar.gz"} \
          ' >> $(WORKPREP_DIR)/$(PREP_URLS_FILE); \
          mv $(WORKPREP_DIR)/$(PREP_URLS_FILE) $(PWD); \
        else \
          $(MSG) "    $(PREP_URLS_FILE) already generated"; \
        fi
	
unprepare:
	rm -f $(PREP_URLS_FILE) $(PREP_DISTFILES_FILE)

clean-prepare:
	rm -rf $(WORKPREP_DIR)

