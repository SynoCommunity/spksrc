CFG_FILE="${SYNOPKG_PKGDEST}/var/mtproxy.conf"
BIN="${SYNOPKG_PKGDEST}/bin/mtproto-proxy"
AES_PWD_FILE="${SYNOPKG_PKGDEST}/var/secret.conf"
RULES_FILE="${SYNOPKG_PKGDEST}/var/rules.conf"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

SECRETS_CMD=$(echo "-S $PROXY_SECRETS" | sed "s|,| -S |g")
INTERNAL_IP="$(ip -4 route get 8.8.8.8 | grep '^8\.8\.8\.8\s' | grep -Po 'src\s+\d+\.\d+\.\d+\.\d+' | awk '{print $2}')"
EXTERNAL_IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"

SERVICE_COMMAND="/bin/stdbuf -o L -e L ${BIN} -u nobody -p 2398 -H ${PROXY_PORT} -M ${PROXY_WORKERS} -C 60000 --aes-pwd ${AES_PWD_FILE} ${RULES_FILE} --allow-skip-dh --nat-info $INTERNAL_IP:$EXTERNAL_IP ${SECRETS_CMD}"
if [[ ! -z "$PROXY_TAG" ]]; then
    SERVICE_COMMAND+=" -P $PROXY_TAG"
fi

SVC_BACKGROUND=y
SVC_WRITE_PID=y

get_aes_pwd() {
    wget -t 3 -O "${AES_PWD_FILE}" \
        --https-only https://core.telegram.org/getProxySecret \
        >> "${LOG_FILE}" 2>&1
}

get_rules() {
    wget -t 3 -O "${RULES_FILE}" \
        --https-only https://core.telegram.org/getProxyConfig \
        >> "${LOG_FILE}" 2>&1
}

service_prestart() {
    get_aes_pwd
    get_rules
}

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@proxy_port@|${wizard_proxy_port:=1984}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_workers@|${wizard_proxy_workers:=2}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_secrets@|${wizard_proxy_secrets:=}|g" ${CFG_FILE}
        sed -i -e "s|@proxy_tag@|${wizard_proxy_tag:=}|g" ${CFG_FILE}
    fi
}
