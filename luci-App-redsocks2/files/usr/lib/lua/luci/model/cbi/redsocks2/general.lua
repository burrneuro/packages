
local state_msg = "" --alex: add running status indicator
local listen_port = luci.sys.exec ("uci get redsocks2. @ redsocks2_redirect [0] .local_port")
local red_on = string.len (luci.sys.exec ("netstat -nlp | grep" .. listen_port))> 0
if red_on then
state_msg = "<b> <font color = \" green \ ">" .. translate ("Running") .. "</ font> </ b>"
else
state_msg = "<b> <font color = \" red \ ">" .. translate ("Not running") .. "</ font> </ b>"
end
m = Map ("redsocks2", translate ("Redsocks2-General Settings"),
translatef ( ". A modified version of redsocks.Beside the basic function of redsocks, it can redirect TCP connections which are blocked via proxy automatically without a blacklist") .. "<br> <br> status -" .. state_msg)
s = m: section (TypedSection, "redsocks2_base", translate ("Basic Settings"))
s.anonymous = true
o = s: option (ListValue, "loglevel", translate ("Log Level"))
o: value ("debug", translate ("Verbose"))
o: value ("info", translate ("Normal"))
o: value ("off", translate ("Off"))
s = m: section (TypedSection, "redsocks2_redirect", translate ("Redirector Settings"))
s.anonymous = true
s.addremove = false
o = s: option (Flag, "enabled", translate ("Enable transparent proxy"))
o = s: option (Value, "local_ip", translate ("Local IP"))
o.datatype = "ip4addr"
o = s: option (Value, "local_port", translate ("Local Port"))
o.datatype = "uinteger"
o = s: option (Value, "ip", translate ("Proxy Server IP"))
o.datatype = "ip4addr"
o: depends ({proxy_type = "shadowsocks"})
o: depends ({proxy_type = "socks5"})
o: depends ({proxy_type = "socks4"})
o: depends ({proxy_type = "http-connect"})
o: depends ({proxy_type = "http-relay"})
o = s: option (Value, "port", translate ("Proxy Server Port"))
o.datatype = "uinteger"
o: depends ({proxy_type = "shadowsocks"})
o: depends ({proxy_type = "socks5"})
o: depends ({proxy_type = "http-connect"})
o: depends ({proxy_type = "http-relay"})
o = s: option (ListValue, "proxy_type", translate ("Proxy Server Type"))
o: value ("shadowsocks", translate ("Shadowsocks"))
o: value ("socks5", translate ("Socks5"))
o: value ("socks4", translate ("Socks4 proxy"))
o: value ("http-connect", translate ("Http proxy"))
o: value ("http-relay", translate ("http-relay"))
o: value ("direct", translate ("forward traffic to VPN"))
o: value ("campus_router", translate ("Crack router restrictions"))
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
o = s: option (Flag, "udp_relay", translate ("Enable UDP forwarding"), translate ("Note that it cannot be used with HAProxy")
o: depends ({proxy_type = "shadowsocks"})
o = s: option (Value, "username", translate ("Username"), translate ("Leave empty if your proxy server doesn't need authentication."))
o: depends ({proxy_type = "socks5"})
o: depends ({proxy_type = "socks4"})
o: depends ({proxy_type = "http-connect"})
o: depends ({proxy_type = "http-relay"})
o = s: option (Value, "password", translate ("Password"))
o: depends ({proxy_type = "shadowsocks"})
o: depends ({proxy_type = "socks5"})
o: depends ({proxy_type = "socks4"})
o: depends ({proxy_type = "http-connect"})
o: depends ({proxy_type = "http-relay"})
o.password = true
o = s: option (Value, "interface", translate ("Outgoing interface"), translate ("Outgoing interface for redsocks2."))
o: depends ({proxy_type = "direct"})
o: depends ({proxy_type = "campus_router"})
o.rmempty = 'eth0.2'
o = s: option (Flag, "out_ttl", translate ("The TTL of the modified route is 64"))
o: depends ({proxy_type = "campus_router"})
o.rmempty = false
o = s: option (Flag, "in_ttl", translate ("Automatically add 1 to the TTL of the modified routing")
o: depends ({proxy_type = "campus_router"})
o.rmempty = false
o = s: option (Flag, "autoproxy", translate ("Enable Auto Proxy"), translate ("Not recommended to open"))
o.rmempty = false
o: depends ({proxy_type = "shadowsocks"})
o: depends ({proxy_type = "socks5"})
o: depends ({proxy_type = "direct"})
o: depends ({proxy_type = "socks4"})
o: depends ({proxy_type = "http-connect"})
o: depends ({proxy_type = "http-relay"})
o = s: option (Value, "timeout", translate ("Timeout"))
o: depends ({autoproxy = 1})
o.datatype = "uinteger"
o.rmempty = 10
o = s: option (Flag, "adbyby", translate ("Use with Adbyby or koolproxy"), translate ("Please do not check this option when Adbyby or koolproxy is not enabled")
o.rmempty = true
o.default = true

s = m: section (TypedSection, "redsocks2_iptables", translate ("Iptables Redirect Settings"))
s.anonymous = true
o = s: option (Flag, "blacklist_enabled", translate ("Enable Blacklist"), translate ("Specify local IP addresses which won't be redirect to redsocks2."))
o.rmempty = false
o = s: option (Value, "ipset_blacklist", translate ("Blacklist Path"))
o: depends ({blacklist_enabled = 1})
o = s: option (Flag, "whitelist_enabled", translate ("Enable Whitelist"), translate ("Specify destination IP addresses which won't be redirect to redsocks2."))
o.rmempty = false
o = s: option (Value, "ipset_whitelist", translate ("Whitelist Path"))
o: depends ({whitelist_enabled = 1})
--o = s: option (Value, "dest_port", translate ("Destination Port"))
--o.datatype = "uinteger"
------------------------------------------------- ---
local apply = luci.http.formvalue ("cbi.apply")
if apply then
os.execute ("/ etc / init.d / redsocks2 restart> / dev / null 2> & 1 &")
end
return m
