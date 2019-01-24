local Core = require(script.Core)
local applyMod = require(script.applyMod)

-- Apply Roact Freeze mod
applyMod()

return {
    Freeze = Core.Freeze
}