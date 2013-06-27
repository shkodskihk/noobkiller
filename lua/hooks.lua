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
			local ret = {fn(...)}
			if #ret>0 then
				return unpack(ret)
			end
		end
	end
end