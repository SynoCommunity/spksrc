# Common definitions, shared by all makefiles

# all will be the default target, regardless of what is defined in the other
# makefiles.
default: all

# Stop on first error
SHELL := $(SHELL) -e

# Display message in a consistent way
MSG = echo "===> "

# Launch command in the working dir of a software with the right environment
RUN = cd $(WORK_DIR)/$(PKG_DIR) && env $(ENV)

# Pip command
PIP = PIP_DOWNLOAD_CACHE=$(PIP_DIR) pip
PIP_WHEEL = $(PIP) wheel --no-use-wheel --no-deps --wheel-dir $(STAGING_DIR)/wheelhouse

# Available languages
LANGUAGES = chs cht csy dan enu fre ger hun ita jpn krn nld nor plk ptb ptg rus spn sve trk

# Load local configuration
LOCAL_CONFIG_MK = ../../local.mk
ifneq ($(wildcard $(LOCAL_CONFIG_MK)),)
include $(LOCAL_CONFIG_MK)
endif

