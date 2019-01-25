local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)

local thawElement
thawElement = function(element)
	element.props[Core.Freeze] = nil
	local children = (element.props)[Roact.Children]
	if children then
		for _,child in pairs(children) do
			thawElement(child)
		end
	end
end
return thawElement