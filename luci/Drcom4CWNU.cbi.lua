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
local APP_NAME    = "Dr.com"
local DESCRIPTION = [[项目所在<a href='https://github.com/leetking/cwnu-drcom'>cwnu-drcom</a><br/>
一个为<a href='http://www.cwnu.edu.cn'>西华师范大学</a>开发的第三方dr.com登录客户端.<br/>
VERSION: freezen-web
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
ispc = s:option(ListValue, "model", translate("模式"))
ispc:value("true", "PC模式")
ispc:value("false", "手机模式")
ispc.default = "true"

local apply = luci.http.formvalue()
if apply then
    io.popen(DRCOM_PATH..WR2DRCOMRC.." start")
end

return m
