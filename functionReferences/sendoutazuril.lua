return function(loc)
	local rendering = require(loc.Parent.renderingEngine)
	rendering.renderImg("/assets/creatures/front/298.png", 50,50,64,64,Vector2.new(0,0), function()
		print("drew azuril")
	end)
	wait(5)
end
