local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)


local Router = Roact.Component:extend("Router")
function Router:init(props)
	self:setState(Router.getDefaultState(self, props))
	util.BindComponentToContext(self, Core.ContextRouter)
	self.props.children = self.props[Roact.Children]
end
Router.getDefaultState = function(this, props)
	local lastRedirectTick = tick()
	local rootURL = props.root or '/'
    return ({
        url = rootURL,
        routerInjectedPropsCache = {
            router = {
				redirect = function(url, delayDuration)
					if (delayDuration) then
						local redirectTick = tick()
						lastRedirectTick = redirectTick
						delay(delayDuration, function()
							if (lastRedirectTick == redirectTick) then
								this:SetURL(url)
							end
						end)
					else
						this:SetURL(url)
					end
                end,
                location = rootURL,
            },
            match = {
                path = rootURL,
                url = rootURL,
                isExact = true,
                params = {},
            },
        },
    })
end
function Router:GetURL()
	if not self.state then
		return
	end
	return self.state.url
end
function Router:SetURL(url)
	if not self.state then
		return
	end
	self:setState({
		url = url
	})
end
function Router:GetIsCaching()
	if not self.props then
		return false
	end
	return self.props.caching and true or false
end
function Router:GetRouterProps()
	return self.state.routerInjectedPropsCache
end
function Router:render()
	return util.PassThroughComponent(self, self.props)
end
return Router