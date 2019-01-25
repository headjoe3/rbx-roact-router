local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)
local css = require(script.Parent.css)
local freezeElement = require(script.Parent.freezeElement)
local thawElement = require(script.Parent.thawElement)

local Route = Roact.Component:extend("Route")
function Route:init(props)
	self.lastRenderedCache = (Roact.createElement("Frame",
		util.join(css.ambient)
	))
    local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
    if ContextRouter then
        self.routeComponentProps = ContextRouter:GetRouterProps()
        if self.props.render then
            self.staticComponent = self.props.render(util.join(self.routeComponentProps))
        end
	end
	self.wasActive = false
	-- Bind to context
	util.BindComponentToContext(self, Core.ContextRoute)
	self.props.children = self.props[Roact.Children]
end
function Route:didMount()
	local ContextSwitch = util.GetComponentFromContext(self, Core.ContextSwitch)
	if ContextSwitch then
		ContextSwitch:MountRoute(self, self.props.priority)
	end
end
function Route:willUnmount()
	local ContextSwitch = util.GetComponentFromContext(self, Core.ContextSwitch)
	if ContextSwitch then
		ContextSwitch:UnmountRoute(self)
	end
end
function Route:PathMatchesURL(url)
	if not self.props then
		return false
	end
	local paramsStart = string.find(self.props.path, "[%(]?%/%:")
	local matchPath
	if paramsStart then
		matchPath = string.lower(string.sub(self.props.path, 1, paramsStart - 1))
	else
		matchPath = string.lower(self.props.path)
	end
	if self.props.exact then
		return string.lower(url) == matchPath
	else
		return (select(1, string.find(string.lower(url), matchPath, nil, true))) ~= nil
	end
end
function Route:GetRouteParams(url)
	local paramsStart = string.find(self.props.path, "[%(]?%/%:")
	if paramsStart then
		local couldContainParams = string.sub(self.props.path, paramsStart)
		local couldContainValues = string.sub(url, paramsStart)
		local parseable = true
		local parsedParams = {}
		while parseable do
			local optional = false
			if string.sub(couldContainParams, 1, 1) == "(" then
				optional = true
				couldContainParams = string.sub(couldContainParams, 2)
			end
			if string.sub(couldContainParams, 1, 1) == "/" and string.sub(couldContainValues, 1, 1) == "/" then
				if string.sub(couldContainParams, 2, 2) == ":" then
					couldContainParams = string.sub(couldContainParams, 3)
					couldContainValues = string.sub(couldContainValues, 2)
				else
					break
				end
			else
				break
			end
			local nextValueStart = string.find(couldContainValues, "%/")
			local value = ""
			if nextValueStart then
				value = string.sub(couldContainValues, 1, nextValueStart - 1)
				couldContainValues = string.sub(couldContainValues, nextValueStart)
			else
				value = couldContainValues
				parseable = false
			end
			local key = ""
			if optional then
				local closeParenthesisPos = string.find(couldContainParams, "%)")
				if closeParenthesisPos then
					key = string.sub(couldContainParams, 1, closeParenthesisPos - 1)
					couldContainParams = string.sub(couldContainParams, closeParenthesisPos + 1)
				else
					break
				end
			else
				local nextKeyStart = string.find(couldContainParams, "[%(%/)]")
				if nextKeyStart then
					value = string.sub(couldContainParams, 1, nextKeyStart - 1)
					couldContainParams = string.sub(couldContainParams, nextKeyStart)
				else
					value = couldContainParams
					parseable = false
				end
			end
			parsedParams[key] = value
		end
		return parsedParams;
	else
		return {}
	end
end
function Route:SetOverrideActive(isActive)
	self.overrideActive = isActive
end
function Route:GetOverrideActive()
	return self.overrideActive
end
function Route:GetIsActive()
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
	local activeURL = ContextRouter and ContextRouter:GetURL()
	if self.overrideActive ~= nil then
		return self.overrideActive
	else
		return (activeURL and function() return self:PathMatchesURL(activeURL) end or function() return false end)()
	end
end
function Route:render()
	local ContextRouter = util.GetComponentFromContext(self, Core.ContextRouter)
	local isCaching = ContextRouter and ContextRouter:GetIsCaching()
	local activeURL = ContextRouter and ContextRouter:GetURL()
	local isActive = false
	if self.overrideActive ~= nil then
		isActive = self.overrideActive
	else
		isActive = (activeURL and function() return self:PathMatchesURL(activeURL) end or function() return false end)()
	end
	local wasActive = self.wasActive
	self.wasActive = isActive
	if isActive then
        if not wasActive or (self.routeComponentProps and self.routeComponentProps.match.url ~= activeURL) then
            -- Gobally override "match" props
			self.routeComponentProps.match = {
				path = self.props.path,
				url = activeURL,
				isExact = activeURL == self.props.path,
				params = self:GetRouteParams(activeURL),
			}
		end
		local activeElement = (self.props.render and self.staticComponent or Roact.createElement(self.props.component, self.routeComponentProps))
		if isCaching then
			if self.lastRenderedCache.props[Core.Freeze] then
				thawElement(self.lastRenderedCache)
			end
			self.lastRenderedCache = activeElement
			activeElement = Roact.createElement("Frame", util.join(css.ambient, {
				Visible = true,
			}), {
				Cache = activeElement,
			})
		end
		return activeElement
	else
		if isCaching then
			if not self.lastRenderedCache.props[Core.Freeze] then
				freezeElement(self.lastRenderedCache)
			end
			return Roact.createElement("Frame", util.join(css.ambient, {
				Visible = false,
			}), {
				Cache = self.lastRenderedCache,
			})
		end
		return (Roact.createElement("Frame", 
			util.join({
				Visible = false,
			},
			css.ambient)
		))
	end
end
return Route