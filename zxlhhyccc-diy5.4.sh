#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# 去除feeds中的material主题多余openwrt名
sed -i 's#boardinfo.hostname or "?"#""#g' feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
# 将tty、ksmd等所在服务目录改到系统、网络存储目录
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-minidlna/root/usr/share/luci/menu.d/luci-app-minidlna.json
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-mjpg-streamer/root/usr/share/luci/menu.d/luci-app-mjpg-streamer.json
# sed -i 's/services/nas/g' feeds/luci/applications/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
# 将htop替换为官方master的htop
# rm -rf ./feeds/packages/admin/htop
# svn co https://github.com/openwrt/packages/trunk/admin/htop feeds/packages/admin/htop
# sed -i '25s/libjpeg/libjpeg-turbo/g' feeds/telephony/net/freeswitch/Makefile
# 替换more.zh_Hans.po
rm -f ./package/op-package/lean/default-settings/i18n/more.zh_Hans.po
wget -P ./package/op-package/lean/default-settings/i18n/ https://raw.githubusercontent.com/project-openwrt/openwrt/master/package/lean/default-settings/i18n/more.zh_Hans.po
# 屏蔽socat/openvpn的与luci冲突的config、init以编译luci
wget -P ./feeds/packages/net/socat/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/net/socat/patches/001-shield-socat-config-init.patch
pushd feeds/packages/net/socat
patch -p1 < 001-shield-socat-config-init.patch
popd
wget -P ./package/network/services/openvpn/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/openvpn/patches/001-shield-config.patch
pushd package/network/services/openvpn
patch -p1 < 001-shield-config.patch
popd
# 删除feeds里的与自有包冲突插件
rm -rf ./feeds/packages/net/frp
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/smartdns
rm -rf ./feeds/packages/utils/syncthing
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-smartdns
# rm -rf ./feeds/luci/applications/luci-app-ksmbd
rm -rf ./package/openwrt-package/lean/luci-app-nft-qos
rm -rf ./package/openwrt-package/lean/nft-qos
