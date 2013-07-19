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
	"goes online",
	"is away",
	"is not available",
	"goes into DnD",
	"SkypeOut",
	"SkypeMe",
}

function events:OnlineStatus(usr, status)
	print('[stat] ' .. usr.handle .. ' ' .. OnlineStatus(status))
end

setmetatable(events, {__index = function(_, key) print("Unhandled event: " .. key) end})
luacom.Connect(skype, events)