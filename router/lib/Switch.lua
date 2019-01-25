
local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

local Switch = Roact.Component:extend("Switch")
function Switch:init(props)
	self:setState({
		routes = {}
	})
	util.BindComponentToContext(self, Core.ContextSwitch)
	self.props.children = self.props[Roact.Children]
end
function Switch:MountRoute(route, priority)
	priority = priority and priority + 1
	if priority and priority < #self.state.routes then
		table.insert(self.state.routes, priority, route)
	else
		table.insert(self.state.routes, route)
	end
end
function Switch:UnmountRoute(route)
    local newRoutes = {}
    for key, other in pairs(self.state.routes) do
        if (other ~= route) then
            table.insert(newRoutes, other)
        end
    end
	self.state.routes = newRoutes
end
function Switch:render()
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
	local activeURL = ContextRouter and ContextRouter:GetURL()
	local foundRoute = false
	for _,route in pairs(self.state.routes) do
		if not foundRoute and activeURL and route:PathMatchesURL(activeURL) then
			foundRoute = true
			if route:GetOverrideActive() ~= true then
				route:SetOverrideActive(true)
			end
		else
			if route:GetOverrideActive() ~= false then
				route:SetOverrideActive(false)
			end
		end
	end
	return util.PassThroughComponent(self, self.props)
end
return Switch