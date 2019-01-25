local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Roact = require(RoactModule.roact.lib)
local Core = require(script.Parent.Core)
local util = require(script.Parent.util)
local css = require(script.Parent.css)

local returnFalse = function() return false end
local returnTrue = function() return true end

local RouteCache = Roact.Component:extend("Cache");
function RouteCache:init(props)
    self.props.children = self.props[Roact.Children]
    self.props._component = self
    self.cacheRef = Roact.createRef()
    self.active = true
end
function RouteCache:Freeze()
    self.shouldUpdate = returnFalse
    self.active = false
    if (self.cacheRef.current) then
        self.cacheRef.current.Visible = false
    end
end
function RouteCache:Thaw()
    self.shouldUpdate = returnTrue
    self.active = true
    if (self.cacheRef.current) then
        self.cacheRef.current.Visible = true
    end
end
function RouteCache:render()
    return Roact.createElement("Frame", util.InjectComponentChildren(util.join(css.ambient, {Visible = self.active, [Roact.Ref] = self.cacheRef,}), self.props))
end
return RouteCache