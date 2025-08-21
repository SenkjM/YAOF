#!/bin/bash
# OpenWrt 默认 IP 地址修改脚本
# 用于修改 OpenWrt 的默认管理 IP 地址

# 原始IP固定为192.168.1.1，只允许配置新IP
ORIGINAL_IP="192.168.1.1"
NEW_IP="${NEW_IP:-192.168.0.1}"

echo "INFO: 开始修改默认 IP 地址配置 ($ORIGINAL_IP -> $NEW_IP)..."

# 修改 config_generate 文件
CONFIG_FILE="package/base-files/files/bin/config_generate"

if [ -f "$CONFIG_FILE" ]; then
    if grep -q "192\.168\.1\.1" "$CONFIG_FILE" 2>/dev/null; then
        sed -i "s/192\.168\.1\.1/$NEW_IP/g" "$CONFIG_FILE"
        echo "INFO: 已修改 $CONFIG_FILE ($ORIGINAL_IP -> $NEW_IP)"
    else
        echo "INFO: $CONFIG_FILE 中未找到 $ORIGINAL_IP"
    fi
else
    echo "INFO: 文件 $CONFIG_FILE 不存在"
fi

echo "INFO: IP 地址修改完成"
exit 0
