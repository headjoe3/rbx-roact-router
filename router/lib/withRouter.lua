local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

withRouter = function(wrappedComponent)
	return function(props)
		local ContextRouter = util.GetComponentFromContext(wrappedComponent, Core.ContextRouter);
		local routeProps;
		if ContextRouter then
			routeProps = ContextRouter:GetRouterProps()
			return Roact.createElement(wrappedComponent, util.join(props, routeProps))
		else
			return Roact.createElement(wrappedComponent, util.join(props))
		end
	end
end

return withRouter