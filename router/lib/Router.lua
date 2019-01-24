local TS = require(game:GetService("ReplicatedStorage").RobloxTS.Include.RuntimeLib);
local _exports = {};
local GetRouter, withRouter;
local CSS = TS.import("StarterPlayer", "StarterPlayerScripts", "Compiled", "Gui", "Stylesheet").CSS;
local _0 = TS.import("StarterPlayer", "StarterPlayerScripts", "Compiled", "Util", "ReactComponentUtils");
local PropsBase, InjectComponentChildren, BindComponentToContext, GetComponentFromContext, PassThroughComponent, FreezeElement, ThawElement = _0.PropsBase, _0.InjectComponentChildren, _0.BindComponentToContext, _0.GetComponentFromContext, _0.PassThroughComponent, _0.FreezeElement, _0.ThawElement;
local Roact = require(TS.getModule("rbx-roact", script.Parent).roact.lib);
local RoactMod = TS.import("ReplicatedStorage", "Compiled", "Core", "RoactFreezeMod");
local RouterContextKey = TS.Symbol("Roact-Router contextual router");
local SwitchContextKey = TS.Symbol("Roact-Router contextual switch");
local Route = Roact.Component:extend("Route");
function Route:init(props)
	self:setState(Route.defaultState);
	self.lastRenderedCache = (Roact.createElement("Frame", 
		TS.Object_assign({}, CSS.ambient)
	));
	self.routeComponentProps = {
		router = {
			redirect = function(url)
				local ContextRouter = GetComponentFromContext(self, RouterContextKey);
				if ContextRouter then
					ContextRouter:SetURL(url);
				end;
			end;
			location = props.path;
		};
		match = {
			path = props.path;
			url = "";
			isExact = false;
			params = {};
		};
	};
	if self.props.render then
		self.staticComponent = self.props.render(self.routeComponentProps);
	end;
	self.wasActive = false;
	self.props.children = self.props[Roact.Children];
end;
Route.defaultState = {
	overrideActive = nil;
};
function Route:didMount()
	local ContextSwitch = GetComponentFromContext(self, SwitchContextKey);
	if ContextSwitch then
		ContextSwitch:MountRoute(self, self.props.priority);
	end;
end;
function Route:willUnmount()
	local ContextSwitch = GetComponentFromContext(self, SwitchContextKey);
	if ContextSwitch then
		ContextSwitch:UnmountRoute(self);
	end;
end;
function Route:PathMatchesURL(url)
	if not self.props then
		return false;
	end;
	local paramsStart = string.find(self.props.path, "[%(]?%/%:");
	local matchPath;
	if paramsStart then
		matchPath = string.lower(string.sub(self.props.path, 1, paramsStart - 1));
	else
		matchPath = string.lower(self.props.path);
	end;
	if self.props.exact then
		return string.lower(url) == matchPath;
	else
		return (select(1, string.find(string.lower(url), matchPath, nil, true))) ~= nil;
	end;
end;
function Route:GetRouteParams(url)
	local paramsStart = string.find(self.props.path, "[%(]?%/%:");
	if paramsStart then
		local couldContainParams = string.sub(self.props.path, paramsStart);
		local couldContainValues = string.sub(url, paramsStart);
		local parseable = true;
		local parsedParams = {};
		while parseable do
			local optional = false;
			if string.sub(couldContainParams, 1, 1) == "(" then
				optional = true;
				couldContainParams = string.sub(couldContainParams, 2);
			end;
			if string.sub(couldContainParams, 1, 1) == "/" and string.sub(couldContainValues, 1, 1) == "/" then
				if string.sub(couldContainParams, 2, 2) == ":" then
					couldContainParams = string.sub(couldContainParams, 3);
					couldContainValues = string.sub(couldContainValues, 2);
				else
					break;
				end;
			else
				break;
			end;
			local nextValueStart = string.find(couldContainValues, "%/");
			local value = "";
			if nextValueStart then
				value = string.sub(couldContainValues, 1, nextValueStart - 1);
				couldContainValues = string.sub(couldContainValues, nextValueStart);
			else
				value = couldContainValues;
				parseable = false;
			end;
			local key = "";
			if optional then
				local closeParenthesisPos = string.find(couldContainParams, "%)");
				if closeParenthesisPos then
					key = string.sub(couldContainParams, 1, closeParenthesisPos - 1);
					couldContainParams = string.sub(couldContainParams, closeParenthesisPos + 1);
				else
					break;
				end;
			else
				local nextKeyStart = string.find(couldContainParams, "[%(%/)]");
				if nextKeyStart then
					value = string.sub(couldContainParams, 1, nextKeyStart - 1);
					couldContainParams = string.sub(couldContainParams, nextKeyStart);
				else
					value = couldContainParams;
					parseable = false;
				end;
			end;
			parsedParams[key] = value;
		end;
		return parsedParams;
	else
		return {};
	end;
end;
function Route:SetOverrideActive(isActive)
	self.overrideActive = isActive;
end;
function Route:GetOverrideActive()
	return self.overrideActive;
end;
function Route:render()
	local ContextRouter = GetComponentFromContext(self, RouterContextKey);
	local isCaching = ContextRouter and ContextRouter:GetIsCaching();
	local activeURL = ContextRouter and ContextRouter:GetURL();
	local isActive = false;
	if self.overrideActive ~= nil then
		isActive = self.overrideActive;
	else
		isActive = (activeURL and function() return self:PathMatchesURL(activeURL) end or function() return false end)();
	end;
	local wasActive = self.wasActive;
	self.wasActive = isActive;
	if isActive then
		if not wasActive or self.routeComponentProps.match.url ~= activeURL then
			self.routeComponentProps.match = {
				path = self.props.path;
				url = activeURL;
				isExact = activeURL == self.props.path;
				params = self:GetRouteParams(activeURL);
			};
		end;
		local activeElement = (self.props.render and self.staticComponent or Roact.createElement(self.props.component, self.routeComponentProps));
		if isCaching then
			if self.lastRenderedCache.props[RoactMod.Freeze] then
				ThawElement(self.lastRenderedCache);
			end;
			self.lastRenderedCache = activeElement;
			activeElement = Roact.createElement("Frame", TS.Object_assign({}, CSS.ambient, {
				Visible = true;
			}), {
				Cache = activeElement;
			});
		end;
		return activeElement;
	else
		if isCaching then
			if not self.lastRenderedCache.props[RoactMod.Freeze] then
				FreezeElement(self.lastRenderedCache);
			end;
			return Roact.createElement("Frame", TS.Object_assign({}, CSS.ambient, {
				Visible = false;
			}), {
				Cache = self.lastRenderedCache;
			});
		end;
		return (Roact.createElement("Frame", 
			TS.Object_assign({
				Visible = false 
			},
			CSS.ambient)
		));
	end;
end;
local Router = Roact.Component:extend("Router");
function Router:init(props)
	self:setState(Router.getDefaultState());
	BindComponentToContext(self, RouterContextKey);
	self.props.children = self.props[Roact.Children];
end;
Router.getDefaultState = function() return ({
	url = "/";
}); end;
function Router:GetURL()
	if not self.state then
		return;
	end;
	return self.state.url;
end;
function Router:SetURL(url)
	if not self.state then
		return;
	end;
	self:setState({
		url = url;
	});
end;
function Router:GetIsCaching()
	if not self.props then
		return false;
	end;
	return self.props.caching;
end;
function Router:render()
	return PassThroughComponent(self, self.props);
end;
local Switch = Roact.Component:extend("Switch");
function Switch:init(props)
	self:setState({
		routes = {};
	});
	BindComponentToContext(self, SwitchContextKey);
	self.props.children = self.props[Roact.Children];
end;
function Switch:MountRoute(route, priority)
	priority = priority and priority + 1;
	if priority and priority < #self.state.routes then
		table.insert(self.state.routes, priority, route);
	else
		TS.array_push(self.state.routes, route);
	end;
end;
function Switch:UnmountRoute(route)
	self.state.routes = TS.array_filter(self.state.routes, function(other) return other ~= route; end);
end;
function Switch:render()
	local ContextRouter = GetComponentFromContext(self, RouterContextKey);
	local activeURL = ContextRouter and ContextRouter:GetURL();
	local foundRoute = false;
	TS.array_forEach(self.state.routes, function(route)
		if not foundRoute and activeURL and route:PathMatchesURL(activeURL) then
			foundRoute = true;
			if route:GetOverrideActive() ~= true then
				route:SetOverrideActive(true);
			end;
		else
			if route:GetOverrideActive() ~= false then
				route:SetOverrideActive(false);
			end;
		end;
	end);
	return PassThroughComponent(self, self.props);
end;
local Redirect = Roact.Component:extend("Redirect");
function Redirect:init(props)
	self.props.children = self.props[Roact.Children];
end;
function Redirect:render()
	local ContextRouter = GetComponentFromContext(self, RouterContextKey);
	if ContextRouter then
		spawn(function() return ContextRouter:SetURL(self.props.to); end);
	end;
	return nil;
end;
GetRouter = function(component)
	return GetComponentFromContext(component, RouterContextKey);
end;
withRouter = function(wrappedComponent)
	return function(props)
		local ContextRouter = GetComponentFromContext(wrappedComponent, RouterContextKey);
		local routeProps;
		if ContextRouter then
			routeProps = {
				router = {
					redirect = function(url)
						ContextRouter:SetURL(url);
					end;
					location = ContextRouter:GetURL() or "";
				};
			};
			return Roact.createElement(wrappedComponent, TS.Object_assign({}, props, routeProps));
		else
			return Roact.createElement(wrappedComponent, TS.Object_assign({}, props));
		end;
	end;
end;
_exports.Route = Route;
_exports.Router = Router;
_exports.Switch = Switch;
_exports.Redirect = Redirect;
_exports.GetRouter = GetRouter;
_exports.withRouter = withRouter;
return _exports;
