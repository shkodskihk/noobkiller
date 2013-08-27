print (" ========================== ")

require("luacom")
require("socket")
luasocket = require("luasocket")

skype = luacom.CreateObject("Skype4COM.Skype", "Skype_")

if not skype.Client.IsRunning then
	skype.Client:Start()
end

require("utils")

Config = {}

function ReloadConfig()
	local ok, ret, err = pcall(loadfile, "config.lua")
	if ret then
		local env = {}
		setmetatable(env, {
			__newindex = function(_, key, val)
				if type(val) == "function" then
					print("Config execution warning: Why did you pass a function?")
					debug.trace()
					return
				end
				Config[key] = val
			end
		})
		setfenv(ret, env)

		local ok, ret = pcall(ret)
		if not ok then
			print("Confing execution error: ", ret)
		end
	else
		print("Config load error: ", err)
	end
end

ReloadConfig()

require("events"); skype:Attach(nil, false);
require("hooks")
require("timer")
timer.Create("CollectGarbage", 5, 0, collectgarbage)

if pcall(require, "lfs") then
	function LoadAddons()
		for file in lfs.dir("addons") do
			if file ~= "." and file ~= ".." then
				local attr=lfs.attributes("addons/" ..file)
				if attr.mode ~= "directory" and file:find("%.lua$") then
					require("addons/"..file:gsub("%.lua$", ""))
				end
			end
		end
	end

	LoadAddons()
end

hook.Add("PersonSay", "Monitor", function(pl, str, msg)
	print(msg.Timestamp, pl.FullName ~= "" and (pl.FullName .. "(" .. pl.Handle .. ")") or pl.Handle, str)
end)

hook.Add("PersonSay", "Lua", function(pl, str, msg)
	local _,_,str = str:find("!l (.*)")

	if not str then return end

	if pl.Handle ~= skype.CurrentUser.Handle then
		return
	end

	local Say = function(line)
		msg.Chat:SendMessage(line)
	end

	local globals = {
		Say = Say,
		me = pl,
		we = getUsers(msg.Chat),
		chat = msg.Chat,
		print = Say,
	}

	local copy = {}

	for k, v in pairs(globals) do
		copy[k] = _G[k]
		_G[k] = v
	end

	local s, r = pcall(loadstring, str, pl.FullName)

	if not s then
		Say(r)
	else
		local s, e = pcall(r)
		if not s then
			Say(e)
		end
	end

	for k, v in pairs(globals) do
		_G[k] = nil
	end

	for k, v in pairs(copy) do
		_G[k] = v
	end
end)

local default_chat="TxjzXtCTc5yqq0I6O-8dBa2n7rDqsbTYf3ffCwduQ-0kFj5bn5UleK1pzqK01DuDnXLCeTEZ2xK8XN-N4kf8jTnWYtf5PI8EGZUgU-oaMQzw4SertRUo9LZaknDtjnuAFTVHTnw"
Say = function(s) skype:FindChatUsingBlob(default_chat):SendMessage(tostring(s)) end

hook.Add("Think", "socket_think", function()
	luasocket.Update()
end)

while 1 do
	skype:Attach(nil, false)
	hook.Call("Think")
	sleep(.33)
end