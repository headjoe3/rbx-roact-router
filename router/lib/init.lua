local Core = require(script.Core)
local util = require(script.util)

local Router = require(script.Router)
local Switch = require(script.Switch)
local Route = require(script.Route)
local Redirect = require(script.Redirect)
local RouteCache = require(script.RouteCache)

local withRouter = require(script.withRouter)

local getRouter = require(script.getRouter)
local getSwitch = require(script.getSwitch)

return {
    -- Components
    Router = Router,
    Switch = Switch,
    Route = Route,
    Redirect = Redirect,
    RouteCache = RouteCache,

    -- Higher-order functions
    withRouter = withRouter,

    -- Util functions
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