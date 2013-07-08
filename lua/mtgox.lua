module("mtgox", package.seeall)

local json=require'json'

function Price(cb)
	luasocket.Get('http://data.mtgox.com/api/1/BTCUSD/ticker_fast', function(tab)
		local str = tab.content:gsub("^(.-){", "{"):gsub("}[%c%d]-$", "}")
		local ret = json.decode(str)
		cb(tonumber(ret["return"].last.value))
	end)
end

function Update(cb)
	Price(function(val)
		LastPrice = CurPrice or val
		CurPrice = val

		if cb then
			cb()
		end
	end)
end

function Shout()
	Update(function()
		local delta = CurPrice - LastPrice
		Say("[mtgox] Current BTC Price: $" .. CurPrice .. " ( delta: $" .. math.floor(delta * 1000)/1000 .. " )")
	end)
end

Update()

timer.Create("mtgox", 600, 0, Shout)

hook.Add("PersonSay", "mtgox", function(pl, line)
	if line:find("^!btc",1) or line:find("^!bitcoin",1) or line:find("^!mtgox",1) then
		Shout()
	end
end)