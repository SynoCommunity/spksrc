ifeq ($(strip $(TC_OS_MIN_VER)),)
TC_OS_MIN_VER = $(TC_FIRMWARE)
endif

ifeq ($(strip $(TC_FIRMWARE)),)
ifeq ($(TC_VERS),1.1)
TC_FIRMWARE = $(TC_VERS)-6931
endif

ifeq ($(TC_VERS),1.2)
TC_FIRMWARE = $(TC_VERS)-7742
endif

ifeq ($(TC_VERS),4.0)
TC_FIRMWARE = $(TC_VERS)-2198
endif

ifeq ($(TC_VERS),4.1)
TC_FIRMWARE = $(TC_VERS)-2636
endif

ifeq ($(TC_VERS),4.2)
TC_FIRMWARE = $(TC_VERS)-3202
endif

ifeq ($(TC_VERS),4.3)
TC_FIRMWARE = $(TC_VERS)-3776
endif

ifeq ($(TC_VERS),5.0)
TC_FIRMWARE = $(TC_VERS)-4458
endif

ifeq ($(TC_VERS),5.1)
TC_FIRMWARE = $(TC_VERS)-5004
endif

ifeq ($(TC_VERS),5.2)
TC_FIRMWARE = $(TC_VERS)-5644
endif

ifeq ($(TC_VERS),6.0)
TC_FIRMWARE = $(TC_VERS)-7321
endif

ifeq ($(TC_VERS),6.0.2)
TC_FIRMWARE = $(TC_VERS)-8451
endif

ifeq ($(TC_VERS),6.1)
TC_FIRMWARE = $(TC_VERS)-15047
endif

ifeq ($(TC_VERS),6.2)
TC_FIRMWARE = $(TC_VERS)-22259
endif

ifeq ($(TC_VERS),6.2.2)
TC_FIRMWARE = $(TC_VERS)-24922
endif
endif
