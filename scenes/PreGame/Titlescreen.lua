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
titlescreen.run = function()
	rendering.clearGraphics()
	local newsound = Instance.new("Sound")
	newsound.Volume = 1
	newsound.Parent = game.Players.LocalPlayer.PlayerGui
	newsound.SoundId = pbu.."/music/3.mp3"
	newsound:Play()
	
	newsound.Ended:Connect(function()
		newsound:Destroy()
		scenes.openscene("PreGame.CreditsBoot")
	end)

	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundColor3 = Color3.new(1, 1, 1)
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 0

	inputs.wipeAllFuncs()
	
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
			rendering.clearGraphics()
			scenes.openscene("PreGame.Menuscreen")
		end)
	end
	inputs.assignKeyToFunc(ctrls.scheme1.interact, "mmm", mmm, false)
	inputs.assignKeyToFunc(ctrls.scheme1.cancel, "mmm", mmm, false)
	inputs.assignKeyToFunc(ctrls.scheme1.menu, "mmm", mmm, false)

	--finaly should be ~35?
	local flash = rendering.renderImg("/assets/titlescreen/brightwhitelight.png", 0, 0, maxX, maxY, Vector2.new(0, 0))
	local title = rendering.renderMaskImg("/assets/titlescreen/title.png", maxX/2, 68, 175, 64, Vector2.new(0.5, .5))
	local shine = rendering.renderMaskImg("/assets/titlescreen/logo_shine.png", -85, 0, 85, maxY, Vector2.new(0, 0))
	local versxbase = (maxX/2)-(64/2)
	local vers = rendering.createElemFromBatchImgs({
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
							shine:Destroy()
							flash:Destroy()

								--[[ shelve for a rainy day
								local prevY = 0
								local blox = {}
								
								local masterY = 0
								for i=1, 10 do
									local x = 0
									for i=1, 8 do
										local newf = Instance.new("Frame")
										newf.BackgroundTransparency = 1
										newf.Size = UDim2.new(1,0,1,0)
										newf.AnchorPoint = Vector2.new(0,0)
										newf.Position = UDim2.new(0,0,0,0)
										newf.Parent = script.Parent.game.loadedassets
										newf.ZIndex = -2000
										table.insert(blox, newf)
										local y = 0
										for i=1, 32 do
											local buble = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", -1+x, 0+y+masterY, 32, 1, Vector2.new(0, 0), Vector2.new(7, 0+y), Vector2.new(32, 1), function(ni)
												ni.Name = i
												ni.Parent = newf
												ni.ImageTransparency = 0.5
												ni.ZIndex = -1000
												coroutine.resume(coroutine.create(function()
													for i=1, y do
														wait()
													end
													local loop = 5
													local move = 1/maxX
													for i=1, loop do
														ni.Position+=UDim2.new(move,0,0,0)
														wait()
													end
													while start == true do
														for i=1, loop*2 do
															ni.Position-=UDim2.new(move,0,0,0)
															wait()
														end
														for i=1, loop*2 do
															ni.Position+=UDim2.new(move,0,0,0)
															wait()
														end
													end
												end))
											end)
											y+=1
										end
										x+=31
									end
									masterY+=32
								end
								for i, v in ipairs(blox) do
									coroutine.resume(coroutine.create(function()
										while start == true do
											v.Position -= UDim2.new(0, 0, 1/maxY, 0)
											if v.Position.Y.Scale <= -1 then
												v.Position += UDim2.new(0, 0, 2, 0)
											end
											wait()
										end
									end))
									
								end
								]]
							local x = 0
							for i=1, 10 do
								local ground = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", x, maxY-24, 24, 16, Vector2.new(0,0), Vector2.new(88, 32), Vector2.new(24, 16))
								local groundground = rendering.renderImgInBounds("/assets/titlescreen/debugmonster.png", x, maxY-8, 24, 8, Vector2.new(0,0), Vector2.new(88, 40), Vector2.new(24, 8))
								x+=24
							end
						end)
					end)
				end)
			end)
		end)
	end)
end

return titlescreen
