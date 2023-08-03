local module = {}

module.checkForSave = function()
	local returning = false
	local s, e = pcall(function()
		if game.Players.LocalPlayer:FindFirstChild("save") then
			if #game.Players.LocalPlayer:FindFirstChild("save"):GetChildren() > 0 then
				if #game.Players.LocalPlayer.save.trainer:GetChildren() > 0 then
					returning = true
				end
			end
		end
	end)
	return returning
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

module.getObjectValueNameFromData = function(value)
	local first = tostring(typeof(value))
	if first == "boolean" then first = "bool" end
	local letter = string.sub(first, 1, 1)
	letter = string.upper(letter)
	letter = letter..string.sub(first, 2, -1)
	local toReturn = letter.."Value"
	return toReturn
end

module.refreshSlot0 = function()
	print("refreshing slot 0...")
	pcall(function()
		if game.Players.LocalPlayer:FindFirstChild("save") then
			game.Players.LocalPlayer:FindFirstChild("save"):Destroy()
		end
	end)
	pcall(function()
		if game.Players.LocalPlayer:FindFirstChild("datastore") then
			local replacer = game.Players.LocalPlayer:FindFirstChild("datastore")
			local replacement = replacer:Clone()

			replacement.Name = "save"
			replacement.Parent = game.Players.LocalPlayer
		end
	end)
end

module.saveData = function(saveslot, path, value, resort) --saveslots, 0=currentlyloaded, 1=saveddata (gets stored)
	print("saving data to slot "..saveslot)	
	if saveslot == 0 then
		saveslot = "save"
	else
		saveslot = "datastore"
	end
	local savefile = nil
	local ss, ee = pcall(function()
		if game.Players.LocalPlayer:FindFirstChild(saveslot) then
			savefile = game.Players.LocalPlayer[saveslot]
		end
	end)
	if savefile == nil then
		savefile = Instance.new("Folder")
		savefile.Name = saveslot
		savefile.Parent = game.Players.LocalPlayer
	end
	if value == nil then value = resort end
	local s, e = pcall(function()
		if path and savefile then
			local pathSplit = path:split(".")
			local currentURl = savefile
			for i, v in ipairs(pathSplit) do
				local sss, eee = pcall(function()
					local a = currentURl:FindFirstChild(v)
					if a then
						currentURl = a
					else
						error("invalid directory")
					end
				end)
				if eee then
					if i == #pathSplit then
						local vtype = module.getObjectValueNameFromData(value)
						local val = Instance.new(vtype)
						val.Name = v
						val.Parent = currentURl
						currentURl = val
					else
						local new = Instance.new("Folder")
						new.Name = v
						new.Parent = currentURl
						currentURl = new
					end
				end
			end
			currentURl.Value = value
		end
	end)
end

return module
