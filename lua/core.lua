print (" ========================== ")

require "luacom"
require "socket"
luasocket = require"luasocket"

function sleep(sec)
    socket.select(nil, nil, sec)
end

local default_chat="TxjzXtCTc5yqq0I6O-8dBa2n7rDqsbTYf3ffCwduQ-0kFj5bn5UleK1pzqK01DuDnXLCeTEZ2xK8XN-N4kf8jTnWYtf5PI8EGZUgU-oaMQzw4SertRUo9LZaknDtjnuAFTVHTnw"

skype = luacom.CreateObject("Skype4COM.Skype", "Skype_")

TAttachmentStatus = {
	[-1] = "AttachUnknown",
	[0] = "AttachSuccess",
	[1] = "AttachPendingAuthorization",
	[2] = "AttachRefused",
	[3] = "AttachNotAvailable",
	[4] = "AttachAvailable"	
}

TConnectionStatus = {
	[-1] = "conUnknown",
	[0] = "conOffline",
	[1] = "conConnecting",
	[2] = "conPausing",
	[3] = "conOnline"
}

events = {
	AttachmentStatus = function(a,b) print(TAttachmentStatus[b]) end,

	ConnectionStatus = function(_, b) print(TConnectionStatus[b]) end,

	Command = function(a,b)
				--print("CMD", b.Command) 
			end,
	Reply = function(a,b)
				--print("REPLY", b.Reply)
			end,

	MessageStatus = function(_, msg)
		if msg.Type == 4 then
			hook.Call("PersonSay", msg.Sender, msg.Body, msg)
		end

		print(msg.Status, msg.Body, msg.Type)
	end,

}

setmetatable(events, {__index = function(_, key) print("Unhandled event: " .. key) end})

if not skype.Client.IsRunning then
	skype.Client:Start()
end

luacom.Connect(skype, events)
skype:Attach(nil, false)

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

function getUsers(chat)
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
			Say("Error while including (II) " .. path .. ": \n" .. (tostring(e) or "N\\A"))
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
end

include("hooks.lua")
include("timer.lua")
timer.Create("CollectGarbage", 5, 0, collectgarbage)
include("anime.lua")
include("hentai.lua")
include("gelbooru.lua")
include("hush.lua")
--include("mtgox.lua")

hook.Add("PersonSay", "Monitor", function(pl, str, msg)
	print(msg.Timestamp, pl.FullName ~= "" and (pl.FullName .. "(" .. pl.Handle .. ")") or pl.Handle, str)
end)

hook.Add("PersonSay", "Lua", function(pl, str, msg)
	local _,_,str = str:find("!l (.*)")

	if not str then return end

	local _Say = Say
	_G.Say = function(line)
		msg.Chat:SendMessage(line)
	end

	if pl.Handle ~= "noiwex" then
		Say("Access denied: " .. pl.Handle)
		return
	end

	local _print = print
	_G.me = pl
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
	Say = _Say
end)

Say = function(s) skype:FindChatUsingBlob(default_chat):SendMessage(tostring(s)) end

hook.Add("Think", "socket_think", function()
	luasocket.Update()
end)

--[[local usr = skype:User()
usr.Handle = "python1320"
Say(usr.FullName)]]

while 1 do
	skype:Attach(nil, false)
	hook.Call("Think")
	sleep(.33)
end