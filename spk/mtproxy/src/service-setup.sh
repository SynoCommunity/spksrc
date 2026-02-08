CFG_FILE="${SYNOPKG_PKGDEST}/var/mtproxy.conf"
BIN="${SYNOPKG_PKGDEST}/bin/mtproto-proxy"
AES_PWD_FILE="${SYNOPKG_PKGDEST}/var/secret.conf"
RULES_FILE="${SYNOPKG_PKGDEST}/var/rules.conf"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

SECRETS_CMD=$(echo "-S $PROXY_SECRETS" | sed "s|,| -S |g")
INTERNAL_IP="${PROXY_INTERNAL_IP}"
EXTERNAL_IP="${PROXY_EXTERNAL_IP}"

if [[ -z "$INTERNAL_IP" ]]; then
    INTERNAL_IP="$(ip -4 route get 8.8.8.8 | grep '^8\.8\.8\.8\s' | grep -Po 'src\s+\d+\.\d+\.\d+\.\d+' | awk '{print $2}')"
fi

if [[ -z "$EXTERNAL_IP" ]]; then
    EXTERNAL_IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"
    if [[ -z "$EXTERNAL_IP" ]]; then
        EXTERNAL_IP="$(curl -s -4 "https://checkip.amazonaws.com/")"
    fi
fi

SERVICE_COMMAND="/bin/stdbuf -o L -e L ${BIN} -u nobody -p 2398 -H ${PROXY_PORT} -M ${PROXY_WORKERS} -C 60000 --aes-pwd ${AES_PWD_FILE} ${RULES_FILE} --allow-skip-dh --nat-info $INTERNAL_IP:$EXTERNAL_IP ${SECRETS_CMD}"
if [[ ! -z "$PROXY_TAG" ]]; then
    SERVICE_COMMAND+=" -P $PROXY_TAG"
fi

SVC_BACKGROUND=y
SVC_WRITE_PID=y

get_aes_pwd() {
    curl -s https://core.telegram.org/getProxySecret -o "${AES_PWD_FILE}" || {
        echo "[W] Cannot download AES password from Telegram servers." >> "${LOG_FILE}"

        if [ -f "${AES_PWD_FILE}" ]; then
            echo "[+] Using old AES password from file ${AES_PWD_FILE}" >> "${LOG_FILE}"
        else
            echo "[E] AES password file not found. Cannot start." >> "${LOG_FILE}"
            exit 2
        fi
    }
}

get_rules() {
    curl -s https://core.telegram.org/getProxyConfig -o "${RULES_FILE}" || {
        echo '[W] Cannot download proxy configuration from Telegram servers.' >> "${LOG_FILE}"

        if [ -f "${RULES_FILE}" ]; then
            echo "[+] Using old proxy configuration from file ${RULES_FILE}" >> "${LOG_FILE}"
        else
            echo "[E] Proxy configuration file not found. Cannot start." >> "${LOG_FILE}"
            exit 2
        fi
    }
}

service_prestart() {
    get_aes_pwd
    get_rules
}

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@proxy_internal_ip@|${wizard_proxy_internal_ip:=}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_external_ip@|${wizard_proxy_external_ip:=}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_port@|${wizard_proxy_port:=1984}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_workers@|${wizard_proxy_workers:=2}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_secrets@|${wizard_proxy_secrets:=}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_tag@|${wizard_proxy_tag:=}|g" ${CFG_FILE}
    fi
}
