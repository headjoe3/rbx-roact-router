local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)

local freezeElement
freezeElement = function(element)
	element.props[Core.Freeze] = true
	local children = (element.props)[Roact.Children]
	if children then
		for _,child in pairs(children) do
			freezeElement(child)
		end
	end
end
return freezeElement