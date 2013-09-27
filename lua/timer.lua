timer={}
local timers={}

local start = socket.gettime()
local systime = function()
	return socket.gettime() - start
end

function timer.Create(name, delay, count, func)
	timers[name] = {
		func = func,
		delay = delay,
		runs = count == 0 and math.huge or count,
		lastrun = systime()
	}
end

function timer.Simple(delay, func)
	table.insert(timers, {
		func = func,
		delay = delay,
		runs = 1,
		lastrun = systime()
	})
end

function timer.Remove(name)
	timers[name] = nil
end

local function CheckTimers()
	for name, tab in pairs(timers) do
		if tab.lastrun + tab.delay <= systime() then
			tab.func()

			tab.lastrun = systime()

			tab.runs = tab.runs - 1
			if tab.runs <= 0 then
				timers[name] = nil
			end
		end
	end
end

hook.Add("Think", "CheckTimers", CheckTimers)