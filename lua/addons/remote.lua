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