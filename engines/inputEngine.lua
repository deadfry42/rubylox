local module = {}
local maps = {}

local uis = game:GetService("UserInputService")

module.assignKeyToFunc = function(key, id, func, oneTime)
	if maps[tostring(key)] == nil then
		maps[tostring(key)] = {}
	end
	maps[tostring(key)].id = {
		["func"] = func,
		["id"] = id,
		["del"] = oneTime,
	}
end

module.wipeFuncsInKey = function(key)
	maps[key] = nil
end

module.wipeFuncByIdInKey = function(key, id)
	maps[key][id] = nil
end

module.wipeAllFuncs = function()
	maps = {}
end

module.isKeyDown = function(key)
	return uis:IsKeyDown(key)
end

module.pullInputMap = function()
	return maps
end

module.restoreInputs = function(map)
	maps = map
end

uis.InputBegan:Connect(function(inp, gpe)
	if gpe == false then
		local key = inp.KeyCode
		--not in rbx menu
		if maps[tostring(key)] ~= nil then
			for i, v in pairs(maps[tostring(key)]) do
				local func = v.func
				coroutine.resume(coroutine.create(func))
				if v.del == true then v = {} end
			end
		end
	end
end)

return module
