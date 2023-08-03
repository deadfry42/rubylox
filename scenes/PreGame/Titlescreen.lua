local titlescreen = {}
local twns = game:GetService("TweenService")
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(script.Parent.Parent.Parent.Engines.inputEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local ctrls = require(game.ReplicatedStorage.inputs)
local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

function p2()
	local s, e = pcall(function()
		coroutine.close(p1working)
		local movement = nil
		local function mmm()
			coroutine.resume(coroutine.create(function()
				local twni = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
				local g = {} g.Volume = 0
				twns:Create(newsound, twni, g):Play()
				wait(2)
				newsound:Destroy()
			end))

			inputs.wipeAllFuncs()		
			script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
			script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(1,1,1)
			rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 0, 10, function()
				coroutine.close(movement)
				rendering.clearGraphics()
				scenes.openscene("PreGame.Menuscreen")
			end)
		end
		inputs.assignKeyToFunc(ctrls.scheme1.interact, "mmm", mmm, false)
		inputs.assignKeyToFunc(ctrls.scheme1.menu, "mmm", mmm, false)
		flash:Destroy()
		shine:Destroy()
		local newtitle = title:Clone()
		newtitle.Parent = game.Players.LocalPlayer.PlayerGui.gameplay.bg.gry.loadedassets
		title:Destroy()
		local title = newtitle
		title.Position = UDim2.new(title.Position.X.Scale, 0, 35/maxY, 0)
		local newvers = vers:Clone()
		newvers.Parent = game.Players.LocalPlayer.PlayerGui.gameplay.bg.gry.loadedassets
		vers:Destroy()
		local vers = newvers
		for i, v in ipairs(vers:GetChildren()) do
			v.ImageTransparency = 0
			v.Position = UDim2.new(v.Position.X.Scale, 0, 55/maxY, 0)
		end
		local x = 0
		for i=1, 10 do
			local ground = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", x, maxY-24, 24, 16, Vector2.new(0,0), Vector2.new(88, 32), Vector2.new(24, 16))
			local groundground = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", x, maxY-8, 24, 8, Vector2.new(0,0), Vector2.new(88, 40), Vector2.new(24, 8))
			x+=24
		end
		local prevY = 0
		local blox = {}
		local screens = {}
		
		local masterY = 0
		for i=1, 2 do
			print("screnz")
			for i=1, 5 do
				local x = 0
				for i=1, 8 do
					local newf = Instance.new("Frame")
					newf.BackgroundTransparency = 1
					newf.Size = UDim2.new(1,0,1,0)
					newf.AnchorPoint = Vector2.new(0,0)
					newf.Position = UDim2.new(0,0,0,0)
					table.insert(blox, newf)
					local y = 0
					for i=1, 32 do
						local buble = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", -1+x, 0+y+masterY, 32, 1, Vector2.new(0, 0), Vector2.new(7, 0+y), Vector2.new(32, 1), function(ni)
							ni.Name = i
							ni.Parent = newf
							ni.ImageTransparency = 0.5
							ni.ZIndex = -1000
						end)
						y+=1
					end
					x+=31
				end
				masterY+=32
			end
			local onescreen = Instance.new("Frame")
			onescreen.BackgroundTransparency = 1
			onescreen.Size = UDim2.new(1,0,1,0)
			onescreen.Position = UDim2.new(0,0,0,0)
			onescreen.AnchorPoint = Vector2.new(0,0)
			onescreen.Parent = game.Players.LocalPlayer.PlayerGui.gameplay.bg.gry.loadedassets
			onescreen.ZIndex = -2000
			table.insert(screens, onescreen)
			for i, blok in ipairs(blox) do
				blok.Parent = onescreen
			end
		end
		movement = coroutine.create(function()
			local loops = 0
			while task.wait() do
				for i, screen in ipairs(screens) do
					screen.Position -= UDim2.new(0, 0, .5/maxY, 0)
					if screen.Position.Y.Scale <= -1 then
						screen.Position += UDim2.new(0, 0, 1, 0)
					end
				end
				loops +=1
			end
		end)
		coroutine.resume(movement)
	end)
	if e then print(e) end
end




newsound = nil

flash = nil
title = nil
shine = nil
vers = nil


function p1()
	local s, e = pcall(function()
		local function mmm()
			local ss, ee = pcall(function()
				coroutine.close(p1working)
				coroutine.resume(coroutine.create(p2))
			end)
			if ee then print(ee) end
		end
		inputs.assignKeyToFunc(ctrls.scheme1.interact, "mmm", mmm, false)
		inputs.assignKeyToFunc(ctrls.scheme1.menu, "mmm", mmm, false)
		flash = rendering.renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0, 0))
		title = rendering.renderMaskImg("/assets/titlescreen/title.png", maxX/2, 68, 175, 64, Vector2.new(0.5, .5))
		shine = rendering.renderMaskImg("/assets/titlescreen/logo_shine.png", -85, 0, 85, maxY, Vector2.new(0, 0))
		local versxbase = (maxX/2)-(64/2)
		vers = rendering.createElemFromBatchImgs({
			{["x"] = versxbase, ["y"] = 10, ["sizex"] = 46, ["sizey"] = 28, ["anchor"] = Vector2.new(0,0), ["frameRectOffset"] = Vector2.new(18, 2), ["frameRectSize"] = Vector2.new(46,28), ["callback"] = (function(ni) ni.ImageTransparency = 1 end),},
			{["x"] = versxbase+46, ["y"] = 10, ["sizex"] = 35, ["sizey"] = 28, ["anchor"] = Vector2.new(0,0), ["frameRectOffset"] = Vector2.new(0, 34), ["frameRectSize"] = Vector2.new(45,28), ["callback"] = (function(ni) ni.ImageTransparency = 1 end),}
		}, "/assets/titlescreen/version.png")
		shine.Parent = title

		flash.ImageTransparency = 1

		shine.maskedwithinframe.ImageTransparency = 0.5

		rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 1, 10, function()
			shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
			shine:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear)
			wait(1.45)
			flash.ImageTransparency = 1
			rendering.genericOpacityTween(flash, 0, 10, function()
				wait()
				shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
				shine:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear)
				wait(0.05)
				rendering.genericOpacityTween(flash, 1, 20, function()
					wait(0.6)
					rendering.genericOpacityTween(flash, 0, 10, function()
						shine.Position = UDim2.new(0-shine.Size.X.Scale,0,0,0)
						wait(0.05)
						shine:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear)
						rendering.genericOpacityTween(flash, 1, 20, function()
							wait(0.5)
							for i, v in ipairs(vers:GetChildren()) do
								rendering.genericOpacityTween(v, 0, 30)
								rendering.genericPosTween(v, v.Position.X.Scale*maxX, 55, 1)
							end
							rendering.genericPosTween(title, maxX/2, 35, 1, function()
								wait(1)
								coroutine.resume(coroutine.create(p2))
							end)
						end)
					end)
				end)
			end)
		end)
	end)
	if e then
		print(e)
	end
end

p1working = coroutine.create(p1)

titlescreen.run = function()
	rendering.clearGraphics()
	inputs.wipeAllFuncs()
	
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 0
	
	p1working = coroutine.create(p1)
	coroutine.resume(p1working)
	
	newsound = Instance.new("Sound")
	newsound.Volume = 1
	newsound.Parent = game.Players.LocalPlayer.PlayerGui.gameplay
	newsound.SoundId = pbu.."/music/3.mp3"
	newsound:Play()
	
	newsound.Ended:Connect(function()
		newsound:Destroy()
		script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
		script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
		rendering.genericOpacityTween(script.Parent.Parent.Parent.Parent.gry.overlay, 0, 10, function()
			rendering.clearGraphics()
			scenes.openscene("PreGame.CreditsBoot")
		end)
	end)

	--finaly should be ~35?
end

return titlescreen
