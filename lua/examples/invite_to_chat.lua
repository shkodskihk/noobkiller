local Blob = "123456789abcdef"

local function InviteToBlob(usr, greet)
	local chat = skype:FindChatUsingBlob(Blob)
	local group = chat.Members
	group:RemoveAll()
	group:Add(usr)
	skype:FindChatUsingBlob(Blob):AddMembers(group)

	if greet then
		timer.Simple(3, function()
			chat:SendMessage("Greetings, " .. (usr.FullName ~= "" and usr.FullName or usr.Handle) .. "!")
		end)
	end
end

hook.Add("PersonSay", "JoinChat", function(pl, line)
	if line:find("^!chat") then
		InviteToBlob(pl, true)
	end
end)