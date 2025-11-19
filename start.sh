#!/bin/bash

# Ameba烧录脚本
echo "=== Ameba D 烧录脚本 v1.0（小网洞） ==="

# 检查并安装socat
if ! command -v socat &> /dev/null; then
    echo "安装socat..."
    pkg install socat -y > /dev/null 2>&1
fi

# 启动socat
pkill -9 socat
echo "启动socat..."
socat pty,raw,echo=0 tcp:127.0.0.1:8080 < /dev/null > /dev/null 2>&1 &
sleep 1
if pgrep -f "socat.*tcp:.*:8080" > /dev/null; then
    echo "socat 启动完成 (PID: $!)"
else
    echo "socat 启动失败"
    exit 1
fi

# 直接使用 /dev/pts/1
PTS_DEVICE="/dev/pts/1"
echo "使用设备: $PTS_DEVICE"

# 检测外部固件
BASE_PATH="/data/data/com.termux/files/home"
FILE_PATH="downloads/km0_km4_image2.bin"
TARGET_FILE=$BASE_PATH/$FILE_PATH
if [ -f "$TARGET_FILE" ]; then
	mv "$TARGET_FILE" bin
	echo "检测到外部固件，已移动到bin目录下"
fi

# 执行烧录
echo "准备烧录..."
sleep 0.5
echo "1.请确保已连接设备"
sleep 2
echo "2.请确保已启用TCPUART(建议用小窗口模式)"
sleep 2
echo "3.请确保已通过按键使设备进入bootloader状态"
sleep 3
./upload ./bin "$PTS_DEVICE"
echo "烧录结束"