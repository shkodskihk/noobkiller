package.path = "?.lua;modules\\?.lua;"
package.cpath = "..\\bin\\libs\\?.dll;"

_G.ffi = require("ffi")

require("luacom")
require("socket")
luasocket = require("luasocket")

skype = luacom.CreateObject("Skype4COM.Skype", "Skype_")

if not skype.Client.IsRunning then
	skype.Client:Start()
end

os.execute("color 17")
require("color")
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

function LoadAddons()
	for file in io.popen("dir /b addons"):read("*all"):gmatch("(.-)\n") do
		if file ~= "." and file ~= ".." then
			--local attr=lfs.attributes("addons/" ..file)
			if file:find("%.lua$") and not Config.AddonBlacklist[file:gsub("%.lua$", "")] then
				require("addons/"..file:gsub("%.lua$", ""))
			end
		end
	end
end

LoadAddons()

local default_chat="TxjzXtCTc5yqq0I6O-8dBa2n7rDqsbTYf3ffCwduQ-0kFj5bn5UleK1pzqK01DuDnXLCeTEZ2xK8XN-N4kf8jTnWYtf5PI8EGZUgU-oaMQzw4SertRUo9LZaknDtjnuAFTVHTnw"
Say = function(s) skype:FindChatUsingBlob(default_chat):SendMessage(tostring(s)) end

hook.Add("Think", "socket_think", function()
	luasocket.Update()
end)

while 1 do
	skype:Attach(nil, false)
	hook.Call("Think")
	sleep(Config.sleeptime or .33)
end