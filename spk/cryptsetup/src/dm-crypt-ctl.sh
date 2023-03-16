#!/bin/sh

set -e

maybe_insmod() {
    [ ! -e "${KPATH}/${1}.ko" ] || /sbin/insmod "${KPATH}/${1}.ko"
}

maybe_rmmod() {
    [ ! -e "${KPATH}/${1}.ko" ] || /sbin/rmmod "${KPATH}/${1}.ko"
}

grepmod() {
    /sbin/lsmod | grep -q "^${1}\\>"
}

insmod_all() {
    maybe_insmod crypto/af_alg
    maybe_insmod crypto/algif_hash
    maybe_insmod crypto/algif_skcipher

    maybe_insmod crypto/cryptd
    maybe_insmod crypto/aes_generic
    maybe_insmod arch/x86/crypto/ablk_helper
    maybe_insmod crypto/ablk_helper
    maybe_insmod arch/x86/crypto/aes-i586
    maybe_insmod arch/x86/crypto/aes-x86_64
    maybe_insmod arch/x86/crypto/glue_helper
    maybe_insmod crypto/gf128mul
    maybe_insmod crypto/lrw
    maybe_insmod crypto/xts
    maybe_insmod arch/x86/crypto/aesni-intel
    maybe_insmod arch/arm/crypto/aes-arm
    maybe_insmod arch/arm/crypto/aes-arm-bs
    maybe_insmod arch/arm64/crypto/aes-ce-cipher
    maybe_insmod arch/arm64/crypto/aes-ce-blk

    maybe_insmod crypto/cbc
    # dm_builtin is unsafe to unload so it may already be loaded
    grepmod dm_builtin || maybe_insmod drivers/md/dm-builtin
    maybe_insmod drivers/md/md-mod
    maybe_insmod drivers/md/dm-mod
    maybe_insmod drivers/md/dm-crypt
    maybe_insmod drivers/md/dm-crypt-armada
}

rmmod_all() {
    maybe_rmmod drivers/md/dm-crypt-armada
    maybe_rmmod drivers/md/dm-crypt
    maybe_rmmod drivers/md/dm-mod
    maybe_rmmod drivers/md/md-mod
    maybe_rmmod crypto/cbc

    maybe_rmmod arch/arm64/crypto/aes-ce-blk
    maybe_rmmod arch/arm64/crypto/aes-ce-cipher
    maybe_rmmod arch/arm/crypto/aes-arm-bs
    maybe_rmmod arch/arm/crypto/aes-arm
    maybe_rmmod arch/x86/crypto/aesni-intel
    maybe_rmmod crypto/xts
    maybe_rmmod crypto/lrw
    maybe_rmmod crypto/gf128mul
    maybe_rmmod arch/x86/crypto/glue_helper
    maybe_rmmod arch/x86/crypto/aes-x86_64
    maybe_rmmod arch/x86/crypto/aes-i586
    maybe_rmmod crypto/ablk_helper
    maybe_rmmod arch/x86/crypto/ablk_helper
    maybe_rmmod crypto/aes_generic
    maybe_rmmod crypto/cryptd

    maybe_rmmod crypto/algif_skcipher
    maybe_rmmod crypto/algif_hash
    maybe_rmmod crypto/af_alg
}

grepmod_all() {
    if { grepmod dm_crypt || grepmod dm_crypt_armada; } && \
        grepmod algif_hash && \
        grepmod algif_skcipher; then

        if grepmod aesni_intel || \
            grepmod aes_arm_bs || \
            grepmod aes_ce_blk; then
            echo 'dm-crypt is loaded with AES acceleration'
        else
            echo 'dm-crypt is loaded without AES acceleration'
        fi
    else
        echo 'dm-crypt is not loaded'
        return 1
    fi
}

ARCH="$(uname -a | awk '{print $NF}' | cut -f2 -d_)"
DSM_VERSION="$(sed -n 's/^productversion=\(.*\)/\1/p' /etc/VERSION)"
KVER="$(uname -r | awk -F. '{print $1 "." $2 "." $3}')"

DSM_VERSION="${DSM_VERSION#\"}"
DSM_VERSION="${DSM_VERSION%\"}"

KPATH="/var/packages/cryptsetup/target/lib/modules/${ARCH}-${DSM_VERSION}/${KVER}"
if [ ! -d "$KPATH" ]; then
    KPATH="${KPATH}+"
    if [ ! -d "$KPATH" ]; then
        echo 'Failed to locate kernel modules'
        exit 1
    fi
fi

case $1 in
    insmod|start)
        insmod_all
        grepmod_all
        ;;
    rmmod|stop)
        rmmod_all
        ;;
    status)
        grepmod_all
        ;;
    *)
        echo "Usage: $0 <insmod,start|rmmod,stop|status>"
        exit 1
        ;;
esac
