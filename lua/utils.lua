function sleep(sec)
    socket.select(nil, nil, sec)
end

function PrintTable(tab, depth)
	depth = depth or 0

	for k, v in pairs(tab) do
		if type(v) ~= "table" then
			print( ("\t"):rep(depth) .. tostring(k) .. "\t=\t" .. tostring(v) )
		else
			print( ("\t"):rep(depth) .. tostring(k) .. "\t=\t{" )
			PrintTable(v, depth + 1)
			print( ("\t"):rep(depth) .. "}" )
		end
	end
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
