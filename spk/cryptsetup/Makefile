SPK_NAME = cryptsetup
SPK_VERS = 2.6.1
SPK_REV = 1
SPK_ICON = src/papirus-folder-locked.png

UNSUPPORTED_ARCHS = 88f6281 comcerto2k qoriq
REQUIRED_MIN_DSM = 6.2.4
REQUIRED_MAX_DSM = 6.2.4
REQUIRED_MIN_SRM = 1.3.1

include ../../mk/spksrc.archs.mk

REQUIRE_KERNEL := 1

# User-space interface for hash/symmetric key cipher algorithms
REQUIRE_KERNEL_MODULE = CONFIG_CRYPTO_USER_API:crypto:af_alg
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_USER_API_HASH:crypto:algif_hash
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_USER_API_SKCIPHER:crypto:algif_skcipher

# AES cipher algorithms
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_CRYPTD:crypto:cryptd
ifneq ($(filter $(ARCH),hi3535 evansport),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES:crypto:aes_generic
endif
ifneq ($(filter $(ARCH),avoton braswell broadwell bromolow cedarview grantley x86),)
# ABLK_HELPER_X86 was introduced in 3.6
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_ABLK_HELPER_X86:arch/x86/crypto:ablk_helper
else ifeq ($(filter $(ARCH),alpine alpine4k armada370 armada375 armada38x armadaxp evansport hi3535 monaco),)
# ABLK_HELPER was introduced in 3.13
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_ABLK_HELPER:crypto:ablk_helper
endif
ifneq ($(filter $(ARCH),$(i686_ARCHS)),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_586:arch/x86/crypto:aes-i586
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_NI_INTEL:arch/x86/crypto:aesni-intel
else ifneq ($(filter $(ARCH),$(x64_ARCHS)),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_X86_64:arch/x86/crypto:aes-x86_64
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_GLUE_HELPER_X86:arch/x86/crypto:glue_helper
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_GF128MUL:crypto:gf128mul
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_LRW:crypto:lrw
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_XTS:crypto:xts
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_NI_INTEL:arch/x86/crypto:aesni-intel
else ifneq ($(filter $(ARCH),ipq806x),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_ARM:arch/arm/crypto:aes-arm
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_ARM_BS:arch/arm/crypto:aes-arm-bs
else ifneq ($(filter $(ARCH),$(ARMv8_ARCHS)),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_ARM64_CE:arch/arm64/crypto:aes-ce-cipher
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_AES_ARM64_CE_BLK:arch/arm64/crypto:aes-ce-blk
endif

# Crypt target support
ifeq ($(filter $(ARCH),alpine alpine4k armada370 armada375 armada38x armadaxp ipq806x),)
REQUIRE_KERNEL_MODULE += CONFIG_CRYPTO_CBC:crypto:cbc
endif
ifneq ($(filter $(ARCH),ipq806x),)
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_DM_BUILTIN:drivers/md:dm-builtin
# MD required because of Synology patches
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_MD:drivers/md:md-mod
REQUIRE_KERNEL_MODULE += CONFIG_BLK_DEV_DM:drivers/md:dm-mod
endif
ifneq ($(filter $(ARCH),armada375),)
REQUIRE_KERNEL_MODULE += CONFIG_DM_CRYPT:drivers/md:dm-crypt-armada
else
REQUIRE_KERNEL_MODULE += CONFIG_DM_CRYPT:drivers/md:dm-crypt
endif

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = jonathan-conder
DESCRIPTION = Open-source utility used to conveniently set up disk encryption based on the dm-crypt kernel module. Use the dm-crypt-ctl command to load the required kernel modules, then use cryptsetup as normal.
DISPLAY_NAME = Cryptsetup
HOMEPAGE = https://gitlab.com/cryptsetup/cryptsetup
LICENSE  = GPLv2

STARTABLE = no
SPK_COMMANDS = sbin/cryptsetup sbin/dm-crypt-ctl

POST_STRIP_TARGET = cryptsetup_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: cryptsetup_extra_install
cryptsetup_extra_install:
	install -m 755 -d $(STAGING_DIR)/sbin
	install -m 755 src/dm-crypt-ctl.sh $(STAGING_DIR)/sbin/dm-crypt-ctl
