local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

local Redirect = Roact.Component:extend("Redirect");
function Redirect:init(props)
    self:setState(Redirect.getDefaultState())
    self.props.children = self.props[Roact.Children]
    -- Markers to prevent infinite redirects
    self.lastRedirectSecond = 0
    self.redirectsThisSecond = 0
end
Redirect.getDefaultState = function()
    return ({
        redirecting = false,
    })
end
function Redirect:render()
	local ContextRoute = util.GetComponentFromContext(self, Core.ContextRoute)
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
    if ContextRouter and ContextRoute and ContextRoute:GetIsActive() then
        if (tick() - self.lastRedirectSecond < 1) then
            if self.redirectsThisSecond > 50 then
                warn("Infinite redirect at path", self._handle._parent:GetFullName() .. "." .. self._handle._key)
            else
                self.redirectsThisSecond = self.redirectsThisSecond + 1
            end
        else
            self.lastRedirectSecond = tick()
            self.redirectsThisSecond = 0
        end
        ContextRouter:GetRouterProps().router.redirect(self.props.to, self.props.delay or 0.03)
	end
	return nil
end
return Redirect