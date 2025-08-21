#!/bin/bash
# PassWall 冲突检查脚本
# 检查PassWall和PassWall2是否同时启用，如果是则删除冲突文件

echo "INFO: 开始检查 PassWall 冲突..."

# 配置文件路径（相对于工作区根目录）
CONFIG_FILE="../SEED/R4S/config.seed"
CONFLICT_FILE="package/new/openwrt_helloworld/luci-app-passwall/htdocs/luci-static/resources/qrcode.min.js"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: 配置文件不存在: $CONFIG_FILE"
    exit 1
fi

echo "INFO: 检查配置文件: $CONFIG_FILE"

# 检查是否同时存在两个PassWall配置且都没有被注释
passwall_enabled=$(grep -E "^CONFIG_PACKAGE_luci-app-passwall=y$" "$CONFIG_FILE" 2>/dev/null || true)
passwall2_enabled=$(grep -E "^CONFIG_PACKAGE_luci-app-passwall2=y$" "$CONFIG_FILE" 2>/dev/null || true)

# 显示检查结果
if [ -n "$passwall_enabled" ]; then
    echo "INFO: 检测到 PassWall 已启用"
else
    echo "INFO: PassWall 未启用或被注释"
fi

if [ -n "$passwall2_enabled" ]; then
    echo "INFO: 检测到 PassWall2 已启用"
else
    echo "INFO: PassWall2 未启用或被注释"
fi

# 如果两个都启用，删除冲突文件
if [ -n "$passwall_enabled" ] && [ -n "$passwall2_enabled" ]; then
    echo "WARNING: 检测到 PassWall 和 PassWall2 同时启用！"
    echo "INFO: 准备删除 PassWall 的冲突文件..."
    
    if [ -f "$CONFLICT_FILE" ]; then
        echo "INFO: 删除冲突文件: $CONFLICT_FILE"
        rm -f "$CONFLICT_FILE"
        
        if [ $? -eq 0 ]; then
            echo "INFO: 冲突文件删除成功"
        else
            echo "ERROR: 冲突文件删除失败"
            exit 1
        fi
    else
        echo "INFO: 冲突文件不存在: $CONFLICT_FILE"
    fi
    
    echo "INFO: PassWall 冲突处理完成"
else
    echo "INFO: 未检测到 PassWall 冲突，无需处理"
fi

echo "INFO: PassWall 冲突检查完成"
exit 0
