--[[
    cbi 模块
    用于处理登录
    位于 /usr/lib/lua/luci/model/cbi/Drcom4CWNU.lua
]]--

local sys = require("luci.sys")

local ETC_CONFIG = "drcomrc"
local ETC_CONFIG_SECTION = "setting"
local DRCOM_PATH  = "/overlay/Drcom4CWNU/"
local WR2DRCOMRC  = "wr2drcomrc.sh"
local WR2WIRELESS = "wr2wireless.sh"
local WR2PASS_LOCAL= "wr2pass-local.sh"
local APP_NAME    = "Dr.com"
local DESCRIPTION = [[项目所在<a href='https://github.com/leetking/cwnu-drcom'>cwnu-drcom</a><br/>
一个为<a href='http://www.cwnu.edu.cn'>西华师范大学</a>开发的第三方dr.com登录客户端.<br/>
VERSION: 0.0.7.5-web
]]

m = Map(ETC_CONFIG, translate(APP_NAME), translate(DESCRIPTION))

s = m:section(TypedSection, ETC_CONFIG_SECTION, "")
s.addremove = false --不允许添加NamedSection
s.anonymous = true  --匿名显示这个(setting)NamedSection

username = s:option(Value, "username", translate("学号"))
password = s:option(Value, "password", translate("密码"))
password.password = true
net = s:option(ListValue, "net", translate("网络类型"))
net:value("SNET", "校园网")
net:value("INET", "互联网")
net.default = "INET"
--[[server = s:option(ListValue, "server", translate("校区"))
server:value("10.255.0.204", "新区二期")
server:value("10.255.0.203", "老区或一期")
server.default = "10.255.0.204"
--]]
-- 把wifi配置移到这里
wifissid = s:option(Value, "wifissid", translate("WIFI名字"))
wifipwd  = s:option(Value, "wifipwd", translate("WIFI密码"))
wifipwd.password = true
function wifipwd:validate(value)
    return (string.len(value) >= 8) and value or nil
end
-- 绕过本地检测的代理服务器设置
local proxy      = s:option(Value, "proxy", translate("代理服务器"))
local proxy_port = s:option(Value, "proxy_port", translate("代理端口"))
proxy_port.default = "2333"
local proxy_pwd  = s:option(Value, "proxy_pwd", translate("代理密码"))
proxy_pwd.password = true
function proxy_pwd:validate(value)
    return (string.len(value) >= 1) and value or nil
end

local apply = luci.http.formvalue()
if apply then
    io.popen(DRCOM_PATH..WR2DRCOMRC.." start")
    io.popen(DRCOM_PATH..WR2WIRELESS.." start")
    io.popen(DRCOM_PATH..WR2PASS_LOCAL.." start")
end

return m
