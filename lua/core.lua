print (" ========================== ")

require "luacom"
require "socket"
luasocket = require"luasocket"

http = require"socket.http"

function sleep(sec)
    socket.select(nil, nil, sec)
end

local blob="TxjzXtCTc5yqq0I6O-8dBa2n7rDqsbTYf3ffCwduQ-0kFj5bn5UleK1pzqK01DuDnXLCeTEZ2xK8XN-N4kf8jTnWYtf5PI8EGZUgU-oaMQzw4SertRUo9LZaknDtjnuAFTVHTnw"

function refresh()
	skype = luacom.CreateObject("Skype4COM.Skype", "Skype_")
	skype:Attach(5)
	chat = skype:FindChatUsingBlob(blob)
end
refresh()

function restart()
	if os.getenv("OS") == "Windows_NT" then
		os.execute("start lua " .. arg[0])
	end

	os.exit()
end

math.randomseed(os.time()); math.random(); math.random()

function table.Random(tab)
	math.random(); math.random()
	while 1 do
		for k, v in pairs(tab) do
			if math.random(1, 1e4) == 666 then
				return v
			end
		end
	end
end

SysTime = os.clock
CurTime = os.clock -- ???
RealTime = os.clock

function getUsers()
	local UserCollection = chat.ActiveMembers
	local tab = {}

	for i = 1, UserCollection.Count do
		table.insert(tab, UserCollection:Item(i))
	end
	
	return tab
end

function include(path)
	local s, r = pcall(loadfile, path)

	local Say = Say or print

	if not s then
		Say("Error while including " .. path .. ": \n" .. (tostring(r) or "N\\A"))
	else
		local s, e = pcall(r)
		if not s then
			Say("Error while including (II) " .. path .. ": \n" .. (tostring(r) or "N\\A"))
		end
	end
end

do -- http
	function string.NiceSize(num)
		if num < 1024 then
			return num .. " B"
		else
			return math.ceil(num / 1024) .. " KB"
		end
	end

	function http.Size(addr)
		_, err, h, terr = http.request {
			method = "HEAD",
			url = addr,
		}

		return tonumber(h["content-length"])
	end

	function http.Head(addr)
		_, err, h, terr = http.request {
			method = "HEAD",
			url = addr,
		}

		return h
	end

	function http.Get(addr, cb)
		local data, cb = "", cb or function()end

		_, err, _, terr = http.request {
			method = "GET",
			url = addr,
			sink = function(d)
				if d == nil then
					cb(data)
				else
					data = data .. d
					return true
				end
			end
		}
	end
end

include("hooks.lua")
include("timer.lua")
timer.Create("CollectGarbage", 5, 0, collectgarbage)
include("anime.lua")
include("hentai.lua")
include("gelbooru.lua")
include("hush.lua")

hook.Add("PersonSay", "Monitor", function(pl, str)
	print(os.date(), pl.FullName ~= "" and (pl.FullName .. "(" .. pl.Handle .. ")") or pl.Handle, str)
end)

hook.Add("PersonSay", "Lua", function(pl, str)
	local _,_,str = str:find("!l (.*)")

	if not str then return end

	if pl.Handle ~= "noiwex" then
		Say("Access denied: " .. pl.Handle)
		return
	end

	local _print = print
	_G["me"] = pl
	print = Say

	local s, r = pcall(loadstring, str, pl.FullName)

	if not s then
		Say(r)
	else
		local s, e = pcall(r)
		if not s then
			Say(e)
		end
	end

	print = _print
end)

local count = chat.Messages.Count
local lastAct = chat.ActivityTimestamp
hook.Add("Think", "GetMessages", function()
	if chat.ActivityTimestamp ~= lastAct then
		lastAct = chat.ActivityTimestamp
		refresh()
	end

	local newCount = chat.Messages.Count

	local delta = newCount - count
	if delta > 0 then
		count = newCount
		for i = 1, delta do
			local msg = chat.Messages:Item(i)
			hook.Call("PersonSay", msg.Sender, msg.Body, msg)
		end
	end
end)

Say = function(s) chat:SendMessage(tostring(s)) end

hook.Add("Think", "socket_think", function()
	luasocket.Update()
end)

--[=[http.Get("http://www.youtube.com/watch?v=4GkL0LPyYew&feature=g-feat", function(data)
	_, _, title = data:find[[<meta property="og:title" content="([^"]+)">]]
	Say(title)
end)]=]

--local inp = lanes.gen(function() return io.read() end)

local usr = skype:User()
usr.Handle = "echo123"
print(usr.FullName)

while 1 do
	local cmd = skype:Command()
	cmd.Command = "PING"
	cmd.Blocking = false
	skype:SendCommand(cmd)
	hook.Call("Think")
	sleep(1/3)
end