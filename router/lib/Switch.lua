
local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

local Switch = Roact.Component:extend("Switch")
function Switch:init(props)
	self.routes = {}
	util.BindComponentToContext(self, Core.ContextSwitch)
	self.props.children = self.props[Roact.Children]
end
function Switch:MountRoute(route, priority)
	priority = priority and priority + 1
	if priority and priority < #self.routes then
		table.insert(self.routes, priority, route)
	else
		table.insert(self.routes, route)
	end
end
function Switch:UnmountRoute(route)
    local newRoutes = {}
    for key, other in pairs(self.routes) do
        if (other ~= route) then
            table.insert(newRoutes, other)
        end
    end
	self.routes = newRoutes
end
function Switch:render()
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
	local activeURL = ContextRouter and ContextRouter:GetURL()
	local foundRoute = false
	local toSetInactive = {}
	local toSetActive
	for _,route in pairs(self.routes) do
		if not foundRoute and activeURL and route:PathMatchesURL(activeURL) then
			foundRoute = true
			if route:GetOverrideActive() ~= true then
				toSetActive = route
			end
		else
			if route:GetOverrideActive() ~= false then
				table.insert(toSetInactive, route)
			end
		end
	end
	-- Set active route visible first to ensure a seemless transition (this is followed up with a cache thaw)
	if (toSetActive) then
		toSetActive:SetOverrideActive(true)
	end
	-- Set inactive routes invisible after the active cache has been thawed
	for _,route in pairs(toSetInactive) do
		route:SetOverrideActive(false)
	end
	return util.PassThroughComponent(self, self.props)
end
return Switch