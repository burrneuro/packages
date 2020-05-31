local state_msg = "" --alex: add running status indicator
local listen_port = luci.sys.exec ("uci get redsocks2. @ redsocks2_udprelay [0] .local_port")
local udp_tcp_on = string.len (luci.sys.exec ("netstat -nlp | grep" .. listen_port))> 0
if udp_tcp_on then
state_msg = "<b> <font color = \" green \ ">" .. translate ("Running") .. "</ font> </ b>"
else
state_msg = "<b> <font color = \" red \ ">" .. translate ("Not running") .. "</ font> </ b>"
end

m = Map ("redsocks2", translate ("Redsocks2-UDP OVER TCP"),
translatef ("Translate UDP protocol request to TCP protocol and send to proxy server for proxy request, suitable for SSH, socks5 proxy environment DNS request forwarding. The function is similar to ss-tunnel, note that only one port can be fixed to an IP forwarding, equivalent to the remote port mapping to the local router ") .." <br> <br> state - ".. state_msg)
s = m: section (TypedSection, "redsocks2_udprelay", translate ("UDP OVER TCP"))
s.anonymous = true
s.addremove = false
o = s: option (Flag, "enabled", translate ("Enable UDP over TCP"), translate ("After enabling, please manually modify [DNS forwarding of [DHCP / DNS] to the listening address set below"))
o = s: option (Value, "local_ip", translate ("listening IP"))
o.datatype = "ip4addr"
o = s: option (Value, "local_port", translate ("listening port"))
o.datatype = "uinteger"
o = s: option (ListValue, "proxy_type", translate ("Proxy Server Type"))
o: value ("shadowsocks", translate ("Shadowsocks port tunnel"))
o: value ("overtcp", translate ("UDP to TCP"))
o = s: option (Value, "ip", translate ("Proxy Server IP"))
o: depends ({proxy_type = "shadowsocks"})
o.datatype = "ip4addr"
o = s: option (Value, "port", translate ("Proxy Server Port"))
o: depends ({proxy_type = "shadowsocks"})
o.datatype = "uinteger"
o = s: option (ListValue, "enc_type", translate ("Cipher Method"))
o: depends ({proxy_type = "shadowsocks"})
o: value ("table")
o: value ("rc4")
o: value ("rc4-md5")
o: value ("aes-128-cfb")
o: value ("aes-192-cfb")
o: value ("aes-256-cfb")
o: value ("bf-cfb")
o: value ("cast5-cfb")
o: value ("des-cfb")
o: value ("camellia-128-cfb")
o: value ("camellia-192-cfb")
o: value ("camellia-256-cfb")
o: value ("idea-cfb")
o: value ("rc2-cfb")
o: value ("seed-cfb")
o = s: option (Value, "password", translate ("Password"))
o: depends ({proxy_type = "shadowsocks"})
o.password = true
o = s: option (Value, "udp_timeout", translate ("UDP Timeout"))
o: depends ({proxy_type = "shadowsocks"})
o.placeholder = "10"
o = s: option (Value, "tcp_timeout", translate ("TCP DNS timeout time"))
o: depends ({proxy_type = "overtcp"})
o.placeholder = "10"
o.datatype = "uinteger"
o = s: option (Value, "dest_ip", translate ("Destination IP"))
o.datatype = "ip4addr"
o.placeholder = "8.8.8.8"
o = s: option (Value, "dest_ip2", translate ("Alternate DNS Server IP"))
o.datatype = "ip4addr"
o.placeholder = "8.8.4.4"
o: depends ({proxy_type = "overtcp"})
o = s: option (Value, "dest_port", translate ("Destination Port"))
o: depends ({proxy_type = "shadowsocks"})
o.datatype = "uinteger"
o.placeholder = "53"
o = s: option (Flag, "tcp_proxy", translate ("forward to proxy server"))
o: depends ({proxy_type = "overtcp"})
o = s: option (Value, "red_port", translate ("iptables forwarding port"), translate ("redsocks listening port or SS / SSR transparent proxy port" in [Basic Settings]))
o: depends ("tcp_proxy", "1")
o.datatype = "uinteger"
o.placeholder = "11111"
o = s: option (Flag, "set_dnsmasq", translate ("Automatically modify dnsmasq global configuration"))
o.rmempty = true
------------------------------------------------- ---
local apply = luci.http.formvalue ("cbi.apply")
if apply then
os.execute ("/ etc / init.d / redsocks2 restart> / dev / null 2> & 1 &")
end
return m
