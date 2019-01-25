local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)

local Redirect = Roact.Component:extend("Redirect");
function Redirect:init(props)
    self:setState(Redirect.getDefaultState())
    self.props.children = self.props[Roact.Children]
end
Redirect.getDefaultState = function()
    return ({
        hasRedirected = false
    })
end
function Redirect:render()
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
	if ContextRouter then
        spawn(function()
            if (self.state.hasRedirected) then return end
            self:setState({hasRedirected = true})
            return ContextRouter:SetURL(self.props.to)
        end)
	end
	return nil
end
return Redirect