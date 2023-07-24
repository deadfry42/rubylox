local genderchoose = {}
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

local twns = game:GetService("TweenService")

local selected = 1

local brendan
local may

genderchoose.run = function()
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
	engine.dialogueBox("font3_dark", false, "", dialogue.birch.p, true, y, txtbox, function(a, b)
		inputs.wipeAllFuncs()
		local namesM = {
			"LANDON",
			"TERRY",
			"SETH",
			"TOM"
		}
		local namesF = {
			"TERRA",
			"KIMMY",
			"NICOLA",
			"SARA"
		}
		local names = namesM
		if gender == true then names = namesF end
		local namesMenu = engine.createMenuBox("/assets/ui/"..txtbox..".png", 16, 8, 9, 10, Color3.new(1,1,1))
		local newnametxt = engine.drawText("font3_dark", "NEW NAME", 24, 16, Color3.new(1,1,1))
		local option1 = engine.drawText("font3_dark", names[1], 24, 32, Color3.new(1,1,1))
		local option2 = engine.drawText("font3_dark", names[2], 24, 48, Color3.new(1,1,1))
		local option3 = engine.drawText("font3_dark", names[3], 24, 64, Color3.new(1,1,1))
		local option4 = engine.drawText("font3_dark", names[4], 24, 80, Color3.new(1,1,1))
		local prevoutline = Instance.new("Frame")
		prevoutline.BackgroundTransparency = 1
		
		local selection = 1
		
		local function updateOutline()
			prevoutline:Destroy()
			local outline = engine.drawOutline(23, (selection*16), 75, 17, Color3.new(1, 0.388235, 0.352941))
			prevoutline = outline
		end
		
		updateOutline()
		
		local min = 1
		local max = 5
		
		local function moveSelection(up)
			rendering.playSFX("sel.wav")
			if up then
				selection -= min
				if selection < min then
					selection = max
				end
			else
				selection +=1
				if selection > max then
					selection = min
				end
			end
			updateOutline()
		end
		
		local function removeMenu()
			namesMenu:Destroy()
			newnametxt:Destroy()
			option1:Destroy()
			option2:Destroy()
			option3:Destroy()
			option4:Destroy()
			prevoutline:Destroy()
		end
		
		inputs.assignKeyToFunc(ctrls.scheme1.up, "nameselect", function() moveSelection(true) end)
		inputs.assignKeyToFunc(ctrls.scheme1.down, "nameselect", function() moveSelection(false) end)
		inputs.assignKeyToFunc(ctrls.scheme1.interact, "nameselect", function()
			local name = names[1]
			inputs.wipeAllFuncs()
			if selection > 1 then
				--probably a preassigned name, set now
				pcall(function()
					name = names[selection-1]
				end)
				savefile.saveData(0, "trainer.name", name, "")
				removeMenu()
			else
				
			end
			a:Destroy()
			b:Destroy()
			engine.dialogueBox("font3_dark", false, "", dialogue.birch.q, true, y, txtbox, function(a, b)
				
			end)
		end)
		inputs.assignKeyToFunc(ctrls.scheme1.cancel, "exitnames", function()
			rendering.playSFX("sel.wav")
			removeMenu()
			scenes.openscene("ProfTalkSections.GenderChoose")
		end, false)
	end)
end

return genderchoose
