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

events = {}

function events:AttachmentStatus(b)
	print(TAttachmentStatus[b])
end

function events:ConnectionStatus(b)
	print(TConnectionStatus[b])
end

function events:Command(b)
	--print("CMD", b.Command) 
end

function events:Reply(b)
	--print("REPLY", b.Reply)
end

function events:MessageStatus(msg, status)
	if (status == 1 or status == 2) and msg.Type == 4 then
		hook.Call("PersonSay", msg.Sender, msg.Body, msg)
	end
end

function events:UserAuthorizationRequestReceived(usr)
	print(usr.handle .. " requests auth")
	print("Text: ", usr.ReceivedAuthRequest)
	usr.IsAuthorized = true
	skype.Friends:Add(usr)
	usr.BuddyStatus = 2 -- accept request
	skype:SendMessage(usr.Handle, "Request accepted automatically")
end

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

do -- http
	function string.NiceSize(num)
		if num < 1024 then
			return num .. " B"
		else
			return math.ceil(num / 1024) .. " KB"
		end
	end
end

require("hooks")
require("timer")
timer.Create("CollectGarbage", 5, 0, collectgarbage)

if pcall(require, "lfs") then
	function LoadAddons()
		for file in lfs.dir("addons") do
			if file ~= "." and file ~= ".." then
				local attr=lfs.attributes("addons/" ..file)
				if attr.mode ~= "directory" then
					require("addons/"..file:gsub(".lua$", ""))
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