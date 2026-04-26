#!/bin/bash
# 遇到错误即刻停止运行
set -e

echo "--- 正在初始化 iOS 构建环境 ---"

# 关键修复：Xcode 14 移除了 libarclite，强制提高最低 iOS 编译目标版本以避开该库的依赖
export IPHONEOS_DEPLOYMENT_TARGET="14.0"
export CGO_CFLAGS="-miphoneos-version-min=14.0"
export CGO_LDFLAGS="-miphoneos-version-min=14.0"

# 1. 安装 gogio
echo "正在下载并安装 gogio..."
go install github.com/lianhong2758/gio-cmd/gogio@latest

# 2. 准备构建
# 进入 Gio UI 源码所在的入口目录
if [ -d "desktop_app" ]; then
    cd desktop_app
else
    echo "错误: 找不到 desktop_app 目录"
    exit 1
fi

echo "--- 开始编译 iOS App ---"

# 3. 使用 gogio 编译未签名的 .app 目录
gogio -target ios \
 -o ../music-dl.app \
 -name MusicDL \
 -version 1.0.0.1 \
 -icon ../winres/icon_256x256.png \
 github.com/guohuiyuan/go-music-dl/desktop_app

cd ..

# 4. 打包为未签名的 .ipa 文件，供侧载使用
echo "--- 正在打包为 IPA ---"
if [ -d "music-dl.app" ]; then
    mkdir -p Payload
    cp -r music-dl.app Payload/
    zip -qr music-dl-ios-unsigned.ipa Payload/
    rm -rf Payload
    echo "构建成功: music-dl-ios-unsigned.ipa"
else
    echo "错误: 编译未生成 .app 文件"
    exit 1
fi