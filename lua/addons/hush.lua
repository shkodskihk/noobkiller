hook.Add("PersonSay", "HushHal", function(pl, body, msg)
	if pl.Handle == "hal1320" and msg.IsEditable and (body:find("^Twitter: ") or body:find("^Pastebin:")) then
		msg.Body = "Access denied"
		refresh()
	end
end)