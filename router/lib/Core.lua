--[[
	Special symbols for element props in modded Roact
]]

local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Symbol = require(RoactModule.roact.lib.Symbol)

local Core = {}

-- Marker to freeze the reconciler on an element
Core.Freeze = Symbol.named("Freeze")

-- Context marker for routers
Core.ContextRouter = Symbol.named("ContextRouter")

-- Context marker for switches
Core.ContextSwitch = Symbol.named("ContextSwitch")

-- Context marker for routers
Core.ContextRoute = Symbol.named("ContextRoute")

return Core