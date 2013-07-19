require("bit")

local line = string.char(0xff, 0xff, 0xff, 0xff, 0x54, 0x53, 0x6f, 0x75, 0x72, 0x63, 0x65, 0x20, 0x45, 0x6e, 0x67, 0x69, 0x6e, 0x65, 0x20, 0x51, 0x75, 0x65, 0x72, 0x79, 0x00)

local strings_source = {
	'name', 'map', 'folder', 'game'
}

function Query(addr, port, cb)
	local cl = luasocket.Client'udp'
	cl:Connect(addr, port)

	local function ToShort(byte1, byte2)
		return bit.lshift(byte2, 8) + byte1
	end

	function cl:OnReceive(str)
		local tab = {}

		local solid = str:sub(1, 4) == string.char(0xff, 0xff, 0xff, 0xff)
		str = str:sub(5)

		if str:sub(1, 1):byte() == 0x49 then
			local protocol = str:sub(2,2); str = str:sub(3)

			for _, key in pairs(strings_source) do
				local _, e, s = string.find(str, "(.-)%z")
				str = str:sub(e+1)
				tab[key] = s
			end

			tab.appid = ToShort(str:sub(1,1):byte(), str:sub(2,2):byte()); str = str:sub(3)

			tab.players = str:sub(1,1):byte()
			tab.maxplayers = str:sub(2,2):byte()
			str = str:sub(3)

			--[[for c in str:gmatch(".") do
				print(c:byte(), c)
			end]]
		elseif str:sub(1, 1):byte() == 0x6d then

		end

		cb(tab)
	end

	cl:Send(line)
end

hook.Add("PersonSay", "Source", function(pl, line, msg)
	local _, _, ip, port = line:find("([%d%.]+):(%d+)")

	print(ip, port)

	Query(ip, port, function(tab)
		msg.Chat:SendMessage(tab.name .. "\n" ..
			"Game: " .. tab.game .. "\n" .. 
			tab.players .. "/" .. tab.maxplayers .. " players on map " .. tab.map
		)
	end)
end)