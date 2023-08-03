local confirmation = {}
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(script.Parent.Parent.Parent.Engines.inputEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local savefile = require(script.Parent.Parent.Parent.Engines.savingEngine)
local engine = require(script.Parent.Parent.Parent.Engines.gameEngine)
local ctrls = require(game.ReplicatedStorage.inputs)
local dialogue = require(game.ReplicatedStorage.talkscript)
local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

confirmation.run = function()
	local prevAssets = require(script.Parent.Parent.PreGame.ProfTalk).retrieveAssets()
	local tlp = prevAssets[1]
	local blp = prevAssets[2]
	local trp = prevAssets[3]
	local brp = prevAssets[4]
	local bir = prevAssets[5]
	local azur = prevAssets[6]
	local prevAssets1 = require(script.Parent.GenderChoose).retrieveAssets()
	local brendan = prevAssets1[1]
	local may = prevAssets1[2]
	local gender = prevAssets1[3]
	local txtbox = savefile.pullFromSaveData("options.txtbx", 1)
	local y = maxY-46
	engine.dialogueBox("font3_dark", false, "", dialogue.birch.q, true, y, txtbox, function(a, b)
		engine.getOptionFromMenu(16, 8, 5, false, true, {"YES", "NO"}, function(sel)
			a:Destroy()
			b:Destroy()
			if sel == 1 then
				engine.dialogueBox("font3_dark", true, "", dialogue.birch.r, false, y, txtbox, function(a, b)
					a:Destroy()
					b:Destroy()
				end)
			else
				scenes.openscene("ProfTalkSections.GenderChoose")
			end
		end, function()
			scenes.openscene("ProfTalkSections.GenderChoose")
		end)
	end)
end

return confirmation
