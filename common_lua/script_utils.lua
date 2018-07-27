------------------------脚本工具箱------------------------
--注意这些脚本是发送到远端Redis数据库中去执行的

local _M = {} -- 局部的变量
_M._VERSION = '1.0' -- 模块版本

-----------------------------------------------------------------------
----------------------[[校验操作权限的脚本]]---------------------------
--EVAL script numkeys key [key ...] arg [arg ...]
--参数 numkeys=1 KEYS[1]=[project:$name:sms:$phonenumber] ARGV[1]=authcode
--返回 true|false
--示例：
--EVAL script_check_sms_authcode 1 [project:$name:sms:$phonenumber] 123
_M.script_check_sms_authcode = [[
	local authcode=redis.pcall('get',KEYS[1])
	if not authcode then
		return {["err"]="authcode is empty"}
	elseif authcode~=ARGV[1] then
		return {["err"]="authcode dismatch"}
	else
		return {["ok"]="authcode match success"}
	end
]]

return _M
