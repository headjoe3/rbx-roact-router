local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)

local util
util = {
	BindComponentToContext = function(thisComponent, symbol)
		rawset(rawget(thisComponent, "_context"), symbol, thisComponent)
	end,
	GetComponentFromContext = function(thisComponent, symbol)
		return rawget(rawget(thisComponent, "_context"), symbol)
	end,
	PassThroughComponent = function(thisComponent, props)
		local parent = rawget(rawget(thisComponent, "_handle"), "_parent")
		return Roact.createElement(Roact.Portal, util.InjectComponentChildren({
			target = parent
		}, props))
	end,
	InjectComponentChildren = function(elementProps, componentProps)
		if elementProps == componentProps then
			error("Attempt to inject component children into its own tree")
		end
		local newProps = {}
		for propName,value in pairs(elementProps) do
			newProps[propName] = value
		end
		if componentProps[Roact.Children] then
			newProps[Roact.Children] = newProps[Roact.Children] or {}
			for key, child in pairs(componentProps[Roact.Children]) do
				newProps[Roact.Children][key] = child
			end
		end
		return newProps
	end,
	join = function(...)
		local result = {}
	
		for i = 1, select("#", ...) do
			local source = select(i, ...)
	
			if source ~= nil then
				for key, value in pairs(source) do
					result[key] = value
				end
			end
		end
	
		return result
	end,
}
return util