local util = require(script.Parent.util)
local Core = require(script.Parent.Core)

local getSwitch = function(component)
	return util.GetComponentFromContext(component, Core.ContextSwitch)
end

return getSwitch