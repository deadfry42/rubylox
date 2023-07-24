--includes
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local scenes = require(script.Engines.sceneEngine)

--services
local cntp = game:GetService("ContentProvider")
local bs = game:GetService("BadgeService")

--game settings compiled at runtime
local folder = game.ReplicatedStorage.compileSettings
---
local versionPng = folder.versionPng.Value

--[[
things to fix (at a later date):
 - logo_shine not properly masking onto logo
 - add the funny cutscene at the start of the game booting
 - fix how goofy the title screen looks
 - make the continue option actually work
 - fix weird looping issues
]]

local function playTheGame()
	game.ReplicatedStorage["remote events (RARE!!!!)"]["gib welcome badge"]:FireServer()
	print("Patch recognised! Correct version ("..versionPng:split(".")[1]..")")
	print("Booting...")
	scenes.openscene("PreGame.CreditsBoot")
	print("Successfully booted scene (PreGame.Movie1)!")
end

cntp:PreloadAsync({pbu.."/confirmation/has_patch.png"}, function(assetID, assetwhatevermajiggy) 
	if assetwhatevermajiggy == Enum.AssetFetchStatus.Success then
		script.Parent.gry.Error.Visible = false
		cntp:PreloadAsync({pbu.."/confirmation/"..versionPng}, function(assetID2, assetwhatevermajiggy2)
			if assetwhatevermajiggy2 == Enum.AssetFetchStatus.Success then
				local success, errmsg = pcall(function()
					playTheGame()
				end)
				if errmsg then
					print(errmsg)
					while wait(math.random(1, 1.2)) do
						local newerrorimg = Instance.new("ImageLabel")
						newerrorimg.Image = "rbxassetid://1847653031"
						newerrorimg.BackgroundTransparency = 1
						newerrorimg.Size = UDim2.new(0.05, 0, 0.05, 0)
						newerrorimg.Position = UDim2.new(math.random(1,1000)/1000, 0, math.random(1,1000)/1000, 0)
						local uiconstraint = Instance.new("UIAspectRatioConstraint")
						uiconstraint.Parent = newerrorimg
						newerrorimg.Parent = script.Parent
						local sfx = Instance.new("Sound")
						sfx.SoundId = "rbxassetid://9066167010"
						sfx.PlayOnRemove = true
						sfx.Parent = script.Parent
						sfx:Destroy()
					end
				end
			else
				script.Parent.gry.Error.Text = "Your patch is out of date! Please re-install the patch."
				script.Parent.gry.Error.Visible = true
			end
		end)
	else
		script.Parent.gry.Error.Visible = true
		print("Please join the discord.")
	end
end)
