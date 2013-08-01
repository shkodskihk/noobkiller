timer={}
local timers={}

local systime = os.clock

function timer.Create(name, delay, count, func)
	timers[name] = {
		func = func,
		delay = delay,
		runs = count == 0 and math.huge or count,
		lastrun = -math.huge
	}
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