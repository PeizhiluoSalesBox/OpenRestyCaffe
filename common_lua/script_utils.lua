------------------------�ű�������------------------------
--ע����Щ�ű��Ƿ��͵�Զ��Redis���ݿ���ȥִ�е�

local _M = {} -- �ֲ��ı���
_M._VERSION = '1.0' -- ģ��汾

-----------------------------------------------------------------------
----------------------[[У�����Ȩ�޵Ľű�]]---------------------------
--EVAL script numkeys key [key ...] arg [arg ...]
--���� numkeys=1 KEYS[1]=[project:$name:sms:$phonenumber] ARGV[1]=authcode
--���� true|false
--ʾ����
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
