hook = {}
local hooks = {}

function hook.Add(hk, name, fun)
	print("Adding hook",hk,name,fun)

	if not hooks[hk] then
		hooks[hk] = {}
	end

	hooks[hk][name] = fun
end

function hook.Call(hk, ...)
	if hooks[hk] then
		for k, fn in pairs(hooks[hk]) do
			local t = os.clock()
			
			local ret = {fn(...)}

			if (os.clock() - t) > .2 then
				print("Warning! Hook", hk, k, " has been running for " .. (os.clock() - t) .. " seconds")
			end

			if #ret>0 then
				return unpack(ret)
			end
		end
	end
end