#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# squashfs：使mkfs具有多CPU加速
sed -i 's/processors 1/processors $(shell nproc)/g' include/image.mk
# openssl：通过以下方式，使ARMv8设备适配ChaCha20-Poly1305而不是AES-GCM
sed -i 's/default y if !x86_64 && !aarch64/default y if !x86_64/g' package/libs/openssl/Config.in
# 添加默认编译包
rm -f ./include/target.mk
wget -P ./include/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/include/target.mk
rm -f ./include/netfilter.mk
wget -P ./include/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/include/netfilter.mk
# kernel支持及修改连接数
rm -f ./package/kernel/linux/modules/netdevices.mk
wget -P ./package/kernel/linux/modules/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/linux/modules/netdevices.mk
rm -f ./package/kernel/linux/modules/netfilter.mk
wget -P ./package/kernel/linux/modules/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/linux/modules/netfilter.mk
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i 's/7440/7200/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
# 修改network中防火墙等源码包
rm -rf ./package/network/config/firewall
svn co https://github.com/project-openwrt/openwrt/branches/master/package/network/config/firewall package/network/config/firewall
rm -rf ./package/network/utils/iptables
svn co https://github.com/project-openwrt/openwrt/branches/master/package/network/utils/iptables package/network/utils/iptables
rm -rf ./package/network/utils/iproute2
svn co https://github.com/project-openwrt/openwrt/branches/master/package/network/utils/iproute2 package/network/utils/iproute2
rm -rf ./package/network/services/uhttpd
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/package/network/services/uhttpd package/network/services/uhttpd
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/package/network/services/shellsync package/network/services/shellsync
# MWAN3回退到2.8.12版本以适配多拨
rm -rf ./feeds/packages/net/mwan3
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/net/mwan3 feeds/packages/net/mwan3
# 关闭https-dns-proxy自启动
sed -i 's/'*'/''/g' feeds/packages/net/https-dns-proxy/files/https-dns-proxy.config
sed -i 's/'*'/''/g' feeds/packages/net/https-dns-proxy/files/https-dns-proxy.init
# 修改feeds里的luci-app-firewall加速开关等源码包
wget -P ./feeds/luci/applications/luci-app-firewall/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/applications/luci-app-firewall/patches/001-luci-app-firewall-Enable-FullCone-NAT.patch
pushd feeds/luci/applications/luci-app-firewall
patch -p1 < 001-luci-app-firewall-Enable-FullCone-NAT.patch
popd
# 添加wifi的MU-MIMO功能
wget -P ./feeds/luci/modules/luci-mod-network/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/modules/luci-mod-network/patches/001-wifi-add-MU-MIMO-option.patch
pushd feeds/luci/modules/luci-mod-network
patch -p1 < 001-wifi-add-MU-MIMO-option.patch
popd
# 更新htop、libyaml-cpp
rm -rf ./feeds/packages/admin/htop
svn co https://github.com/project-openwrt/packages/trunk/admin/htop feeds/packages/admin/htop
rm -rf ./feeds/packages/libs/libyaml-cpp
svn co https://github.com/project-openwrt/packages/trunk/libs/libyaml-cpp feeds/packages/libs/libyaml-cpp
# 添加5.4内核ACC、shortcut-fe补丁
rm -f ./target/linux/generic/hack-5.4/250-netfilter_depends.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/250-netfilter_depends.patch
rm -f ./target/linux/generic/hack-5.4/650-netfilter-add-xt_OFFLOAD-target.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/650-netfilter-add-xt_OFFLOAD-target.patch
rm -f ./target/linux/generic/hack-5.4/661-use_fq_codel_by_default.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/661-use_fq_codel_by_default.patch
rm -f ./target/linux/generic/hack-5.4/662-remove_pfifo_fast.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/662-remove_pfifo_fast.patch
rm -f ./target/linux/generic/hack-5.4/721-phy_packets.patch
wget -P ./target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/721-phy_packets.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/998-add-ndo-do-ioctl.patch
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/hack-5.4/999-thermal-tristate.patch
# 修复pending-5.4部分补丁及添加imq模块补丁
wget -P target/linux/generic/pending-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/pending-5.4/601-add-kernel-imq-support.patch
rm -f ./target/linux/generic/pending-5.4/655-increase_skb_pad.patch
wget -P ./target/linux/generic/pending-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/pending-5.4/655-increase_skb_pad.patch
rm -f ./target/linux/generic/pending-5.4/680-NET-skip-GRO-for-foreign-MAC-addresses.patch
wget -P ./target/linux/generic/pending-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/pending-5.4/680-NET-skip-GRO-for-foreign-MAC-addresses.patch
rm -f ./target/linux/generic/pending-5.4/690-net-add-support-for-threaded-NAPI-polling.patch
wget -P ./target/linux/generic/pending-5.4/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/pending-5.4/690-net-add-support-for-threaded-NAPI-polling.patch
rm -f ./target/linux/generic/config-5.4
wget -P ./target/linux/generic/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/generic/config-5.4
# mwlwifi添加disable-amsdu补丁
wget -P package/kernel/mwlwifi/patches/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/mwlwifi/patches/002-disable-AMSDU.patch
# 给luci-base添加无线图标
wget -P feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons/ https://github.com/zxlhhyccc/acc-imq-bbr/raw/master/master/feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons/wifi_big.png
# wireless-regdb：自定义更改txpower和dfs的补丁
wget -P package/firmware/wireless-regdb/patches/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/firmware/wireless-regdb/patches/600-custom-change-txpower-and-dfs.patch
# 添加upx压缩源码
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/tools/ucl tools/ucl
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/tools/upx tools/upx
rm -f ./tools/Makefile
wget -P ./tools/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/tools/Makefile
# 去除feeds中的material主题多余openwrt名
sed -i 's#boardinfo.hostname or "?"#""#g' feeds/luci/themes/luci-theme-material/luasrc/view/themes/material/header.htm
# 将tty、ksmd所在服务目录改到系统、网络存储目录
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-ksmbd/root/usr/share/luci/menu.d/luci-app-ksmbd.json
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
# 添加feeds里的依赖包
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/lang/python/Flask-RESTful feeds/packages/lang/python/Flask-RESTful
svn co https://github.com/project-openwrt/packages/trunk/libs/opencv feeds/packages/libs/opencv
svn co https://github.com/openwrt/packages/branches/openwrt-19.07/libs/fcgi feeds/packages/libs/fcgi
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/libs/libdouble-conversion feeds/packages/libs/libdouble-conversion
# 添加dnamasq的IPV6展示
wget -P ./package/network/services/dnsmasq/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/dnsmasq/patches/0001-dnsmasq-add-filter-aaaa-option.patch
pushd package/network/services/dnsmasq
patch -p1 < 0001-dnsmasq-add-filter-aaaa-option.patch
popd
wget -P ./feeds/luci/modules/luci-mod-network/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/dnsmasq/patches/0001-luci-add-filter-aaaa-option.patch
pushd feeds/luci/modules/luci-mod-network
patch -p1 < 0001-luci-add-filter-aaaa-option.patch
popd
wget -P ./package/network/services/dnsmasq/patches/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/dnsmasq/patches/910-mini-ttl.patch
wget -P ./package/network/services/dnsmasq/patches/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/dnsmasq/patches/911-add-filter-aaaa-option.patch
# 添加dnamasq的多核心dns负载均衡解析
wget -P ./package/network/services/dnsmasq/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/network/services/dnsmasq/patches/001-auto-multiple-service-instances.patch
pushd package/network/services/dnsmasq
patch -p1 < 001-auto-multiple-service-instances.patch
popd
# 添加k2p的lan/wan
wget -P ./target/linux/ramips/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/ramips/patches/000-k2p-network.patch
pushd target/linux/ramips
patch -p1 < 000-k2p-network.patch
popd
wget -P ./target/linux/ramips/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/target/linux/ramips/patches/0003-mt7621.dtsi-add-missing-pinctrl-to-ethernet-node.patch
pushd target/linux/ramips
patch -p1 < 0003-mt7621.dtsi-add-missing-pinctrl-to-ethernet-node.patch
popd
# rtl8812au-ac：更新无线5.8
svn co https://github.com/project-openwrt/openwrt/branches/master/package/kernel/rtl8812au-ac package/kernel/rtl8812au-ac
# 修改transmission依赖
wget -P ./feeds/packages/net/transmission-web-control/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/net/transmission-web-control/patches/001-transmission-web-control-dbengine.patch
pushd feeds/packages/net/transmission-web-control
patch -p1 < 001-transmission-web-control-dbengine.patch
popd
wget -P ./feeds/luci/applications/luci-app-transmission/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/applications/luci-app-transmission/patches/001-luci-app-transmission-with-dbengine.patch
pushd feeds/luci/applications/luci-app-transmission
patch -p1 < 001-luci-app-transmission-with-dbengine.patch
popd
# 修改sqm-scripts汉化help
svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/net/sqm-scripts/patches feeds/packages/net/sqm-scripts/patches
rm -rf ./feeds/packages/net/sqm-scripts/patches/.svn
# 修复新版luci的cpu等寄存器显示
wget -P ./feeds/luci/modules/luci-mod-status/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/modules/luci-mod-status/patches/001-luci-mod-status-fix-register-functions.patch
pushd feeds/luci/modules/luci-mod-status
patch -p1 < 001-luci-mod-status-fix-register-functions.patch
popd
wget -P ./feeds/luci/modules/luci-mod-status/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/modules/luci-mod-status/patches/002-luci-mod-status-drop-lluci.ver-display.patch
pushd feeds/luci/modules/luci-mod-status
patch -p1 < 002-luci-mod-status-drop-lluci.ver-display.patch
popd
# 添加netdata显示中文日期补丁及升级到1.22.1
# sed -i 's/1.20.0/1.22.1/g' feeds/packages/admin/netdata/Makefile
# sed -i 's/c739e0fa8d6d7f433c0c7c8016b763e8f70519d67f0b5e7eca9ee5318f210d90/6efd785eab82f98892b4b4017cadfa4ce1688985915499bc75f2f888765a3446/g' feeds/packages/admin/netdata/Makefile
# wget -P ./feeds/packages/admin/netdata/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/admin/netdata/patches/002-netdata-with-dbengine.patch
# pushd feeds/packages/admin/netdata
# patch -p1 < 002-netdata-with-dbengine.patch
# popd
wget -P ./feeds/packages/admin/netdata/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/admin/netdata/patches/003-netdata-init-with-TZ.patch
pushd feeds/packages/admin/netdata
patch -p1 < 003-netdata-init-with-TZ.patch
popd
wget -P ./feeds/packages/admin/netdata/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/admin/netdata/patches/004-netdata-with-config.patch
pushd feeds/packages/admin/netdata
patch -p1 < 004-netdata-with-config.patch
popd
# svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/libs/libJudy feeds/packages/libs/libJudy
# luci-lib-jsoncs使用int64
wget -P ./feeds/luci/libs/luci-lib-jsonc/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/luci/libs/luci-lib-jsonc/patches/0001-use_json_object_new_int64.patch
pushd feeds/luci/libs/luci-lib-jsonc
patch -p1 < 0001-use_json_object_new_int64.patch
popd
# 添加samba36
# svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/package/network/services/samba36 package/network/services/samba36
# svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/luci/applications/luci-app-samba feeds/luci/applications/luci-app-samba
# 添加python2
# svn co https://github.com/zxlhhyccc/acc-imq-bbr/trunk/master/feeds/packages/lang/python/python2 feeds/packages/lang/python/python2
# wget -P ./feeds/packages/lang/python/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/lang/python/python2-host.mk
# wget -P ./feeds/packages/lang/python/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/lang/python/python2-package-install.sh
# wget -P ./feeds/packages/lang/python/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/lang/python/python2-package.mk
# wget -P ./feeds/packages/lang/python/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/feeds/packages/lang/python/python2-version.mk
# 删除feeds里的与自有包冲突插件
rm -rf ./feeds/packages/net/frp
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/smartdns
rm -rf ./feeds/packages/utils/syncthing
rm -rf ./feeds/packages/utils/coremark
rm -rf ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/luci/applications/luci-app-frps
rm -rf ./feeds/luci/applications/luci-app-smartdns
# rm -rf ./feeds/luci/applications/luci-app-ksmbd
rm -rf ./package/openwrt-package/lean/luci-app-nft-qos
rm -rf ./package/openwrt-package/lean/nft-qos
# 替换acc
# rm -rf ./package/openwrt-package/lean/luci-app-flowoffload-master
# pushd package/openwrt-package/lean
# unzip luci-app-flowoffload-master-NAT.zip
# popd
# 打开wifi并设置区域为US
wget -P ./package/kernel/mac80211/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/mac80211/patches/001-wifi-auto.patch
pushd package/kernel/mac80211
patch -p1 < 001-wifi-auto.patch
popd
# mac80211：为ath / subsys：在2g上允许vht添加补丁
wget -P ./package/kernel/mac80211/patches/subsys/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/mac80211/patches/subsys/600-mac80211-allow-vht-on-2g.patch
wget -P ./package/kernel/mac80211/patches/ath/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/kernel/mac80211/patches/ath/983-ath10k-allow-vht-on-2g.patch
# 修正友善补丁
rm -rf target/linux/rockchip/patches-5.4
svn co https://github.com/zxlhhyccc/openwrt-master/trunk/target/linux/rockchip/patches-5.4 target/linux/rockchip/patches-5.4
# busybox：为docker top命令添加ps -ef选项的补丁
wget -P ./package/utils/busybox/patches/ https://raw.githubusercontent.com/zxlhhyccc/acc-imq-bbr/master/master/package/utils/busybox/patches/900-add-e-f-option-for-docker.patch
# golang更新到1.15.3
# sed -i 's/GO_VERSION_PATCH:=2/GO_VERSION_PATCH:=3/g' feeds/packages/lang/golang/golang/Makefile
# sed -i 's/28bf9d0bcde251011caae230a4a05d917b172ea203f2a62f2c2f9533589d4b4d/896a602570e54c8cdfc2c1348abd4ffd1016758d0bd086ccd9787dbfc9b64888/g' feeds/packages/lang/golang/golang/Makefile
