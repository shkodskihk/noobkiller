hook.Add("AuthRequest", "AutoAdd", function(usr, line)
	usr.IsAuthorized = true
	skype.Friends:Add(usr)
	usr.BuddyStatus = 2 -- accept request
	skype:SendMessage(usr.Handle, "Request accepted automatically")
end)