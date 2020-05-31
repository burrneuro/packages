# luci-app-redsocks2
The luci configuration page developed for Redsocks2 on OpenWRT supports almost all functions of Redsocks2 v0.66

Introduction
---
Makefile written to compile the dependent packages required by [this firmware] [N], please download the translation of some interfaces [i18n ipk] [3]

The package contains only the luci configuration page of OpenWrt. Please refer to this project for compiling the ipk of Redsocks2 executable file [openwrt-redsocks2] [1]

The main function

1. Support Socks5, Socks4, HTTP and Shadowsocks transparent proxy

2. Support Shadowsocks UDP forwarding function

3. Support UDP over TCP and forward DNS requests to the proxy server, which can remotely resolve DNS to prevent pollution

4. Support remote DNS resolution like ss-tunnel

5. Support VPN sharing function

6. Support the use of transparent proxy to achieve NAT, and can modify the TTL of incoming and outgoing routing data packets to achieve the effect of breaking the routing blockade

7. Support target IP address white list function (domestic routing table)

8. Support designated LAN host without proxy

rely
---
+ redsocks2 redsocks main program, should be placed under / usr / sbin

+ kmod-ipt-ipopt is used to modify TTL

+ iptables-mod-ipopt is used to modify TTL

+ ipset for IP whitelist function

+ ip-full for Shadowsocks UDP forwarding function

+ iptables-mod-tproxy for Shadowsocks UDP forwarding function

+ kmod-ipt-tproxy for Shadowsocks UDP forwarding function

+ iptables-mod-nat-extra for Shadowsocks UDP forwarding function

Compile
---

 -Compile from [SDK] [S] of OpenWrt

   `` `bash
   # Take ar71xx platform as an example
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx- *
   # Get Makefile
   git clone https://github.com/AlexZhuo/luci-app-redsocks2.git package / luci-app-redsocks2
   # Select the package to be compiled Luci-> Network-> luci-app-redsocks2
   make menuconfig
   # Start compiling
   make package / luci-app-redsocks2 / compile V = 99
   `` `

----------

Instructions for use
---
1. Socks5 proxy, generally used for SSH proxy
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-3.png)

2. ShadowSocks proxy
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-1.png)

3. Socks5 proxy server resolves DNS. After configuring Redsocks2, you also need to modify dnsmasq to use Redsocks2 as the upstream DNS server. You can also use GFWList with ipset to achieve a more efficient DNS resolution strategy
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-2.png)

4. The Shadowsocks proxy server resolves DNS, the usage is the same as above
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-6.png)

5. Modify the upstream server of dnsmasq to Redsocks2

Fill in the UDP listening port of Redsocks2 for DNS forwarding, and tick "Ignore analysis file"
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-7.png)
! [demo] (https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-8.png)

6. Obtain and update the domestic routing table

The domestic routing table can be downloaded directly [the file] [2], and placed in the / etc directory, and then configured according to the "Enable White List" item on the first picture, which can save proxy server traffic and speed up the Chinese mainland website Access speed


[1]: https://github.com/AlexZhuo/openwrt-redsocks2
[S]: http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
[2]: https://github.com/AlexZhuo/BlockedDomains/blob/master/china_route
[N]: http://www.right.com.cn/forum/thread-198649-1-1.html
[3]: https://github.com/AlexZhuo/BreakwallOpenWrt/blob/master/ar71xx/ImageBuilder/packages/base/luci-i18n-redsocks2-zh-cn_git-15.111.32254-5ecd256-1_all.ipk
