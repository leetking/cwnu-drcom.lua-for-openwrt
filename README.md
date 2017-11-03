# cwnu-drcom.lua for openwrt

The original project at [cwnu-drcom.lua](https://github.com/leetking/cwnu-drcom.lua).

## Build

```shell
$ git clone https://github.com/leetking/cwnu-drcom.lua-for-openwrt.git
$ cd cwnu-drcom.lua-for-openwrt
$ git submodule update
$ make
$ # move it into OpenWrt, then run
OpenWrt# opkg install Drcom4CWNU-*-web.ipk
```

# Dependence

- Lua           Auto install
- LuaSocket     Auto install
- ss-redir      Manual install (provide via shadowsocks-libev or shadowsocks-redir)
