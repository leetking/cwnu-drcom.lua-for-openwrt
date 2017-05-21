local http = require("socket.http")
local config = require("config")
local syscfg = config.sys
local user = config.user

-- 加密密码
local encryt_pwd = function(pwd)
    local md5  = require("md5")
    local pid = syscfg.pid
    local calg = syscfg.calg
    return md5.sumhexa(pid..pwd..calg)..calg..pid
end
-- 把table转换为url数据string
local table2string = function(tb)
    local ret = ""
    local isfirst = true
    for k, v in pairs(tb) do
        if not isfirst then
            ret = ret.."&"
        end
        isfirst = false
        ret = ret..tostring(k).."="..tostring(v)
    end
    return ret
end

local body = {
    ["DDDDD"]  = (user.net == "SNET") and user.usr or user.usr.."@tel",
    ["upass"]  = encryt_pwd(user.pwd),
    ["R1"]     = 0,
    ["R2"]     = 1,
    ["para"]   = "00",
    ["0MKKey"] = "123456",
    ["v6ip"]   = "",
}
local strbody = table2string(body)
local resbody = {}

-- 开始请求
local function login()
    print(("User(%s) Logining..."):format(body["DDDDD"]))
    local res, code, reshd = http.request({
        url = "http://"..syscfg.ser..syscfg.path,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded";
            ["Content-Length"] = #strbody
        },
        source = ltn12.source.string(strbody),
        sink = ltn12.sink.table(resbody),
    })

    -- TODO 处理反馈信息
    if 200 == code and 1 == res then
        return true
    else
        return false
    end
end

local function relogin()
end

local function logoff()
end

-- 导出的接口
return {
    login   = login,
    relogin = relogin,
    logoff  = logoff,
}

-- $ curl -X POST --data "DDDDD=201413640731&upass=e63b77b435ec97b7c1bfeeb860128c9d123456782&R1=0&R2=1&para=00&0MKKey=123456&v6ip=" http://10.255.0.204/0.htm
