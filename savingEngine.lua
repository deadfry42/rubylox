local module = {}

module.checkForSave = function()
	local s, e = pcall(function()
		if game.Players.LocalPlayer:FindFirstChild("save") then
			if #game.Players.LocalPlayer:FindFirstChild("save"):GetChildren() > 0 then
				if #game.Players.LocalPlayer.save.trainer:GetChildren() > 0 then
					return true
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end)
	if e then
		return false
	end
end

module.pullFromSaveData = function(path, resort) --"options.txtspd", "slow"
	local val = resort
	local s, e = pcall(function()
		if path and game.Players.LocalPlayer.save then
			local pathSplit = path:split(".")
			local currentURl = game.Players.LocalPlayer.save
			for i, v in ipairs(pathSplit) do
				currentURl = currentURl[v]
			end
			val = currentURl.Value
		end
	end)
	return val
end

return module
