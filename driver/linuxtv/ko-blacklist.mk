# Disable RC (remote controls)
BLACKLIST  = CONFIG_IR_IMON
BLACKLIST += CONFIG_IR_MCEUSB
BLACKLIST += CONFIG_IR_STREAMZAP
BLACKLIST += CONFIG_RC_ATI_REMOTE
BLACKLIST += CONFIG_RC_XBOX_DVD

# Disable USB devices
BLACKLIST += CONFIG_VIDEO_TM6000
BLACKLIST += CONFIG_VIDEO_TM6000_ALSA
BLACKLIST += CONFIG_VIDEO_TM6000_DVB

# Disable all PCI adapters
BLACKLIST += CONFIG_DVB_B2C2_FLEXCOP_PCI
BLACKLIST += CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG
BLACKLIST += CONFIG_DVB_BT8XX
BLACKLIST += CONFIG_DVB_BUDGET
BLACKLIST += CONFIG_DVB_BUDGET_AV
BLACKLIST += CONFIG_DVB_BUDGET_CI
BLACKLIST += CONFIG_DVB_BUDGET_CORE
BLACKLIST += CONFIG_DVB_BUDGET_PATCH
BLACKLIST += CONFIG_DVB_DDBRIDGE
BLACKLIST += CONFIG_DVB_DDBRIDGE_MSIENABLE
BLACKLIST += CONFIG_DVB_DM1105
BLACKLIST += CONFIG_DVB_HOPPER
BLACKLIST += CONFIG_DVB_MANTIS
BLACKLIST += CONFIG_MANTIS_CORE
BLACKLIST += CONFIG_DVB_NETUP_UNIDVB
BLACKLIST += CONFIG_DVB_NGENE
BLACKLIST += CONFIG_DVB_PLUTO2
BLACKLIST += CONFIG_DVB_PT1
BLACKLIST += CONFIG_DVB_PT3
BLACKLIST += CONFIG_DVB_SMIPCIE
BLACKLIST += CONFIG_MEDIA_ALTERA_CI
BLACKLIST += CONFIG_TTPCI_EEPROM
BLACKLIST += CONFIG_VIDEO_MXB
BLACKLIST += CONFIG_VIDEO_BT819
BLACKLIST += CONFIG_VIDEO_BT848
BLACKLIST += CONFIG_VIDEO_BT856
BLACKLIST += CONFIG_VIDEO_BT866
BLACKLIST += CONFIG_VIDEO_CX18
BLACKLIST += CONFIG_VIDEO_CX18_ALSA
BLACKLIST += CONFIG_VIDEO_CX23885
BLACKLIST += CONFIG_VIDEO_CX25821
BLACKLIST += CONFIG_VIDEO_CX25821_ALSA
BLACKLIST += CONFIG_VIDEO_CX88
BLACKLIST += CONFIG_VIDEO_CX88_ALSA
BLACKLIST += CONFIG_VIDEO_CX88_BLACKBIRD
BLACKLIST += CONFIG_VIDEO_CX88_DVB
BLACKLIST += CONFIG_VIDEO_CX88_ENABLE_VP3054
BLACKLIST += CONFIG_VIDEO_CX88_MPEG
BLACKLIST += CONFIG_VIDEO_CX88_VP3054
BLACKLIST += CONFIG_VIDEO_DT3155
BLACKLIST += CONFIG_VIDEO_FB_IVTV
BLACKLIST += CONFIG_VIDEO_HEXIUM_GEMINI
BLACKLIST += CONFIG_VIDEO_HEXIUM_ORION
BLACKLIST += CONFIG_VIDEO_IVTV
BLACKLIST += CONFIG_VIDEO_IVTV_ALSA
BLACKLIST += CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS
BLACKLIST += CONFIG_VIDEO_SAA7134
BLACKLIST += CONFIG_VIDEO_SAA7134_RC
BLACKLIST += CONFIG_VIDEO_SAA7134_GO7007
BLACKLIST += CONFIG_VIDEO_SAA7134_DVB
BLACKLIST += CONFIG_VIDEO_SAA7134_ALSA
BLACKLIST += CONFIG_VIDEO_SAA7164
BLACKLIST += CONFIG_VIDEO_TW5864
BLACKLIST += CONFIG_VIDEO_TW68
BLACKLIST += CONFIG_VIDEO_TW686X