hook.Add("PersonSay", "Monitor", function(pl, str, msg)
	--print(msg.Timestamp, pl.FullName ~= "" and (pl.FullName .. "(" .. pl.Handle .. ")") or pl.Handle, str)
	SetColor(0x13); io.write(os.date("%H:%M - "))
	SetColor(0x14); io.write(pl.FullName ~= "" and (pl.FullName .. "(" .. pl.Handle .. ")") or pl.Handle)
	ResetColor()
	io.write(": " .. str .. "\n")
end)