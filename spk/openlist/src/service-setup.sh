#!/bin/sh

# 创建服务用户
SERVICE_USER="sc-${SYNOPKG_PKGNAME}"
SERVICE_GROUP="users"

# 创建数据目录
DATA_DIR="${SYNOPKG_PKGDEST}/var"

# 设置权限
chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${DATA_DIR}
chmod -R 755 ${DATA_DIR}

# 复制配置文件（如果不存在）
CONFIG_FILE="${DATA_DIR}/config.json"
if [ ! -f "${CONFIG_FILE}" ]; then
    cp "${SYNOPKG_PKGDEST}/var/config.json.template" "${CONFIG_FILE}"
    chown ${SERVICE_USER}:${SERVICE_GROUP} "${CONFIG_FILE}"
fi