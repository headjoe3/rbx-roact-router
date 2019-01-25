local Core = require(script.Core)
local applyMod = require(script.applyMod)
local util = require(script.util)

-- Apply Roact Freeze mod
applyMod()

local Router = require(script.Router)
local Switch = require(script.Switch)
local Route = require(script.Route)

local withRouter = require(script.withRouter)

local freezeElement = require(script.freezeElement)
local thawElement = require(script.thawElement)
local getRouter = require(script.getRouter)
local getSwitch = require(script.getSwitch)

return {
    -- Components
    Router = Router,
    Switch = Switch,
    Route = Route,

    -- Higher-order functions
    withRouter = withRouter,

    -- Util functions
    freezeElement = freezeElement,
    thawElement = thawElement,
    getRouter = getRouter,
    getSwitch = getSwitch,

    -- Core symbols
    Freeze = Core.Freeze,
    ContextRouter = Core.ContextRouter,
    ContextSwitch = Core.ContextSwitch,

    -- Util functions
    --BindComponentToContext = util.BindComponentToContext,
    --GetComponentFromContext = util.GetComponentFromContext,
    --PassThroughComponent = util.PassThroughComponent,
    --InjectComponentChildren = util.InjectComponentChildren,
}