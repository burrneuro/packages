RedSocks2 for OpenWrt
===
版本 0.66

为编译[此固件][N]所需依赖包而写的Makefile


简介
---

 软件包只包含 [redsocks2][1] 的可执行文件,可配合[luci-app-redsocks2][M]使用
 
 本项目是 [RedSocks2][1] 在 OpenWrt 上的移植  
 
 当前版本: 0.66(2016.12.3最后一次commit)  
 
 可以修改Makefile中PKG_SOURCE_VERSION为你需要编译的commit id
 
新版特性
---

1、支持Socks5协议的透明代理

2、内置Shadowsocks协议，支持全局UDP转发，无需再专门安装Shadowsocks

3、支持透明代理转VPN，可以把流量直接转发到VPN的虚拟网卡上去

4、支持TCPDNS，配合透明代理不仅可有效避免污染，还能实现国内外智能分流

配置文件写法请[点击此处][1]

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译  

   ```bash
   # 以 ar71xx 平台为例
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   # 获取 Makefile
   git clone https://github.com/AlexZhuo/openwrt-redsocks2.git package/redsocks2
   # 安装依赖包源码
   ./scripts/feeds update base
   ./scripts/feeds install libevent2
   # 选择要编译的包 Network -> redsocks2
   make menuconfig
   # 开始编译
   make package/redsocks2/compile V=99
   ```

编译错误解决方案
---

1、报错`utils.h:7:26: fatal error: event2/event.h: No such file or directory`

错误原因：SDK没有找到libevent2的源码，可能是你的feeds源有问题

解决方案：直接把libevnet2的Makefile放到packages目录下 

git clone https://github.com/AlexZhuo/openwrt-feeds.git package/feeds

----------




  [1]: https://github.com/semigodking/redsocks
  [2]: http://sourceforge.net/projects/openwrt-dist/files/redsocks2/
  [5]: https://github.com/aa65535/openwrt-chinadns
  [6]: https://github.com/aa65535/openwrt-dnsmasq
  [7]: https://github.com/shadowsocks/openwrt-shadowsocks
  [8]: https://github.com/aa65535/openwrt-shadowvpn
  [S]: http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [L]: https://github.com/aa65535/openwrt-dist-luci
  [N]: http://www.right.com.cn/forum/thread-198649-1-1.html
  [M]: https://github.com/AlexZhuo/luci-app-redsocks2
