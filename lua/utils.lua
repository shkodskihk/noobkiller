ffi.cdef[[
void Sleep(int ms);
]]

function sleep(sec)
    ffi.C.Sleep(sec * 1000)
end

local function TableMemberToString(val)
	local type = type(val)
	if type == "string" then
		return string.format('"%s"', val)
	else
		return tostring(val)
	end
end

local function recursetable(tab, depth, known, str)
	depth = depth or 0
	known = known or {tab}
	str = str or ""

	for k, v in pairs(tab) do
		if type(v) ~= "table" then
			str = str .. (" "):rep(depth*4) .. tostring(k) .. "\t=\t" .. TableMemberToString(v) .. "\n"
		else
			if table.HasValue(known, v) then
				str = str .. (" "):rep(depth*4) .. tostring(k) .. "\t=\t" .. TableMemberToString(v) .. "\n"
			else
				table.insert(known, v)
				str = str .. (" "):rep(depth*4) .. tostring(k) .. "\t=\t{" .. "\n"
				str, known = recursetable(v, depth + 1, known, str)
				str = str .. (" "):rep(depth*4) .. "}" .. "\n"
			end
		end
	end
	
	return str, known
end

function PrintTable(tab)
	assert(type(tab) == "table", "Parameter 1 must be a table!")
	print( (recursetable(tab)) )
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

function table.HasValue(tab, value)
	assert(type(tab) == "table", "Parameter 1 must be a table!")
	assert(value, "Parameter 2 must be a value!")
	for k, v in next, tab do
		if v == value then return true end
	end
	return false
end

function getUsers(chat)
	local UserCollection = chat.ActiveMembers
	local tab = {}

	for i = 1, UserCollection.Count do
		table.insert(tab, UserCollection:Item(i))
	end
	
	return tab
end

function debug.trace()
	print("Debug Trace:")
	local i = 0
	while 1 do
		i = i + 1
		local tab = debug.getinfo(i, "Sln")
		
		if tab == nil then
			return
		end

		print(i, tab.short_src .. ":" .. tab.currentline)
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
