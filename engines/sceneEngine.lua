local module = {}

module.openscene = function(path) -- "PreGame.Movie1"
	local s, e = pcall(function()
		if path then
			local pathSplit = path:split(".")
			local currentURl = script.Parent.Parent.Scenes
			for i, v in ipairs(pathSplit) do
				currentURl = currentURl[v]
			end
			if currentURl then
				local scene = require(currentURl)
				scene.run()
			else
				error("sceneEngine - Invalid scene path!")
			end
		else
			error("sceneEngine - No scene path!")
		end
	end)
	if e then
		error(e)
	end
end

return module
