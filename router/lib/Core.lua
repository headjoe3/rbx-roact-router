--[[
	Provides a set of markers used for annotating data in Roact.
]]

local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Symbol = require(RoactModule.roact.lib.Symbol)

local Core = {}

-- Marker to freeze the reconciler on an element
Core.Freeze = Symbol.named("Freeze")

return Core