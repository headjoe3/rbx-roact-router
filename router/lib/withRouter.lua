local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

withRouter = function(wrappedComponent)
	local class = Roact.Component:extend("withRouterWrappedComponent")
	local oldIndex = getmetatable(class).__index
	function class:render()
		local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter);
		if ContextRouter then
			local routeProps = ContextRouter:GetRouterProps()
			return Roact.createElement(wrappedComponent, util.join(self.props, routeProps))
		else
			return Roact.createElement(wrappedComponent, util.join(self.props))
		end
	end
	return class
end

return withRouter