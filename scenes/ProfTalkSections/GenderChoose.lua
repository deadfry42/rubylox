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

local brendan = nil
local may = nil

genderchoose.run = function()
	inputs.wipeAllFuncs()
	local prevAssets = require(script.Parent.Parent.PreGame.ProfTalk).retrieveAssets()
	local tlp = prevAssets[1]
	local blp = prevAssets[2]
	local trp = prevAssets[3]
	local brp = prevAssets[4]
	local bir = prevAssets[5]
	local azur = prevAssets[6]
	local y = maxY-46
	local txtbox = savefile.pullFromSaveData("options.txtbx", 1)
	if brendan == nil then brendan = rendering.renderImg("/assets/trainers/portraits/brendan.png", maxX-(tlp.Size.X.Scale*maxX),93,64,64,Vector2.new(0.5,1), function(ni)
		ni.ImageTransparency = 1
	end) end
	if may == nil then may = rendering.renderImg("/assets/trainers/portraits/may.png", maxX-(tlp.Size.X.Scale*maxX),93,64,64,Vector2.new(0.5,1), function(ni)
		ni.ImageTransparency = 1
	end) end
	if selected == 1 then brendan.ImageTransparency = 0 end
	engine.dialogueBox("font3_dark", false, "", dialogue.birch.o, true, y, txtbox, function(newf, bx)
		local box = engine.createMenuBox("/assets/ui/"..txtbox..".png", 16, 32, 5, 4, Color3.new(1,1,1))
		local boytxt = engine.drawText("font3_dark", "BOY", 24, 40, Color3.new(1,1,1))
		local girltxt = engine.drawText("font3_dark", "GIRL", 24, 56, Color3.new(1,1,1))
		local selBoy = engine.drawOutline(23, 40, 43, 17, Color3.new(1, 0.388235, 0.352941), function(no) no.Visible = false end)
		local selGirl = engine.drawOutline(23, 56, 43, 17, Color3.new(1, 0.388235, 0.352941), function(no) no.Visible = false end)
		
		local debounce = false

		local gIn = {}
		gIn.Position = UDim2.new(1-tlp.Size.X.Scale, 0, 93/maxY, 0)
		gIn.ImageTransparency = 0

		local gOut = {}
		gOut.Position = UDim2.new(1, 0, 93/maxY, 0)
		gOut.ImageTransparency = 1

		local twni = TweenInfo.new(.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local twnibutFAST = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		
		local reSelect = function()
			if selected == 1 then
				debounce = true
				selBoy.Visible = true
				selGirl.Visible = false
				twns:Create(may, twni, gOut):Play()
				wait(.25)
				twns:Create(brendan, twni, gIn):Play()
				wait(.25)
				debounce = false
			else
				debounce = true
				selBoy.Visible = false
				selGirl.Visible = true
				twns:Create(brendan, twni, gOut):Play()
				wait(.25)
				twns:Create(may, twni, gIn):Play()
				wait(.25)
				debounce = false
			end
		end

		selBoy.Visible = true
		selGirl.Visible = false
		if selected == true then
			selected = 2
		else
			selected = 1
		end
		if selected == 1 then twns:Create(may, twnibutFAST, gOut):Play() else selected = 1 reSelect() end

		local changeSelection = function(up)
			if debounce == true then return end
			if up == true and selected == 2 then
				selected = 1
				rendering.playSFX("sel.wav")
				reSelect()
			elseif up == false and selected == 1 then
				selected = 2
				rendering.playSFX("sel.wav")
				reSelect()
			end
		end
		inputs.wipeAllFuncs()
		inputs.assignKeyToFunc(ctrls.scheme1.up, "gendersel", function() changeSelection(true) end, false)
		inputs.assignKeyToFunc(ctrls.scheme1.down, "gendersel", function() changeSelection(false) end, false)
		inputs.assignKeyToFunc(ctrls.scheme1.interact, "gendersel", function()
			if selected == 2 then selected = true else selected = false end
			rendering.playSFX("sel.wav")
			savefile.saveData(0, "trainer.gender", selected, false)
			selBoy:Destroy()
			selGirl:Destroy()
			boytxt:Destroy()
			girltxt:Destroy()
			newf:Destroy()
			box:Destroy()
			bx:Destroy()
			scenes.openscene("ProfTalkSections.NameChoose")
		end, true)
	end)
end

genderchoose.retrieveAssets = function()
	return {brendan, may, selected}
end

return genderchoose
