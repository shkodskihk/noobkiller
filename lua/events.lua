TAttachmentStatus = {
	[-1] = "AttachUnknown",
	[0] = "Client is successfully attached",
	[1] = "Waiting for user authorization",
	[2] = "User has explicitly denied access to the client",
	[3] = "Skype API is not available",
	[4] = "Skype API is available"	
}

TConnectionStatus = {
	[-1] = "conUnknown",
	[0] = "Connection does not exist",
	[1] = "Establishing connection",
	[2] = "Connection is pausing",
	[3] = "Made connection"
}

events = {}

function events:AttachmentStatus(b)
	SetColor(0x1a); io.write("[api] "); ResetColor()
	print(TAttachmentStatus[b])
end

function events:ConnectionStatus(b)
	SetColor(0x1a); io.write("[api] "); ResetColor()
	print(TConnectionStatus[b])
end

function events:Command(b)
	--print("CMD", b.Command) 
end

function events:Reply(b)
	--print("REPLY", b.Reply)
end

function events:GroupUsers()
end

function events:ContactsFocused()
end

function events:MessageStatus(msg, status)
	if (status == 1 or status == 2) and msg.Type == 4 then
		hook.Call("PersonSay", msg.Sender, msg.Body, msg)
	end
end

function events:UserAuthorizationRequestReceived(usr)
	print(usr.handle .. " requests auth")
	print("Text: ", usr.ReceivedAuthRequest)
	hook.Call("AuthRequest", usr, usr.ReceivedAuthRequest)
end

function events:UserMood(usr, str)
	print('[mood] ' .. usr.handle, str)
end

local OnlineStatus = {
	[-1] = "crossed galaxy through matter and time",
	[0] = "goes offline",
	[1] = "goes online",
	[2] = "is away",
	[3] = "is not available",
	[4] = "goes into DnD",
	[5] = "SkypeOut",
	[6] = "SkypeMe",
}

function events:OnlineStatus(usr, status)
	print('[stat] ' .. usr.handle .. ' ' .. OnlineStatus[status])
end

setmetatable(events, {__index = function(_, key) SetColor(0x1c); io.write("Unhandled event: "); ResetColor(); print(key) end})
luacom.Connect(skype, events)