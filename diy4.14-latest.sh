#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# 删除openwrt-latest自带的插件
# rm -rf ./package/ctcgew
# rm -rf ./package/lean
# rm -rf ./package/lienol
# rm -rf ./package/ntlf9t
# rm -rf ./package/zxlhhyccc
# 替换文件应用新IP为192.168.50.1及默认中文及设置登录密码为admin
rm -f ./package/base-files/files/bin/config_generate
wget -P ./package/base-files/files/bin/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/base-files/files/bin/config_generate
chmod 755 ./package/base-files/files/bin/config_generate
rm -f ./package/base-files/files/etc/shadow
wget -P ./package/base-files/files/etc/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/base-files/files/etc/shadow
# 开启wifi
rm -f ./package/kernel/mac80211/files/lib/wifi/mac80211.sh
wget -P ./package/kernel/mac80211/files/lib/wifi/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/mac80211/files/lib/wifi/mac80211.sh
# openssl升级为1.1.1e
rm -rf ./package/libs/openssl
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/package/libs/openssl package/libs/openssl
# 替换network中为19.07的odhcpd源码包解决dns解析导致无法获取dns不能上网问题
rm -rf ./package/network/services/odhcpd
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/19.07/network/services/odhcpd package/network/services/odhcpd
# 添加bcm53xx默认内核为4.14
rm -f ./target/linux/bcm53xx/Makefile
wget -P ./target/linux/bcm53xx/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/4.19-5.4-bcm53xx/Makefile
# 添加x86默认编译包及内核为4.14
rm -f ./target/linux/x86/Makefile
wget -P ./target/linux/x86/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/4.19-5.4-x86/Makefile
# 去除feeds中的material主题多余固件名
rm -f ./feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
wget -P ./feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
# 将tty所在服务目录改到系统目录
rm -f ./feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
wget -P ./feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
# 添加feeds里的依赖包
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/lang/python/Flask-RESTful feeds/packages/lang/python/Flask-RESTful
# 升级feeds中的exfat-nofuse源码
rm -rf ./feeds/packages/kernel/exfat-nofuse
svn co  https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/kernel/exfat-nofuse feeds/packages/kernel/exfat-nofuse
# 删除feeds里的与自有包冲突插件
rm -rf ./feeds/packages/net/frp
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/smartdns
rm -rf ./feeds/packages/utils/syncthing
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-ksmbd
