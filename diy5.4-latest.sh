#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# 删除openwrt-latest自带的插件
# rm -rf ./package/ctcgew
# rm -rf ./package/lean
# rm -rf ./package/lienol
# rm -rf ./package/ntlf9t
# rm -rf ./package/zxlhhyccc
# 修改fullconenat加速模块Makefile适配5.4内核
rm -rf ./package/openwrt-package/lean/openwrt-fullconenat
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/openwrt-fullconenat package/openwrt-package/lean/openwrt-fullconenat
# 去除feeds中的material主题多余固件名
rm -f ./feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
wget -P ./feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
# 添加pfring依赖包
# svn co  https://github.com/openwrt/packages/branches/openwrt-19.07/kernel/pfring feeds/packages/kernel/pfring
# 升级feeds中的exfat-nofuse源码
rm -rf ./feeds/packages/kernel/exfat-nofuse
svn co  https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/kernel/exfat-nofuse feeds/packages/kernel/exfat-nofuse
svn co  https://github.com/openwrt/packages/trunk/libs/libcups feeds/packages/libs/libcups
# 修改mwan3检测IP
rm -f ./feeds/packages/net/mwan3/files/etc/config/mwan3
wget -P ./feeds/packages/net/mwan3/files/etc/config/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/net/mwan3/files/etc/config/mwan3
# 修改sqm-scripts汉化help
rm -rf ./feeds/packages/net/sqm-scripts
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/net/sqm-scripts feeds/packages/net/sqm-scripts
# 删除sqm仍未进行汉化的po文件
rm -rf ./feeds/luci/applications/luci-app-sqm/po/zh_Hans
# 删除feeds里的与自有包冲突插件
rm -rf ./feeds/packages/net/frp
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/smartdns
rm -rf ./feeds/packages/utils/syncthing
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-ksmbd
rm -rf ./package/openwrt-package/lean/luci-app-nft-qos
rm -rf ./package/openwrt-package/lean/nft-qos
rm -rf ./package/openwrt-package/lean/autocore-18.06
