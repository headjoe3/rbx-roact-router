local util = require(script.Parent.util)
local Core = require(script.Parent.Core)

local getRouter = function(component)
	return util.GetComponentFromContext(component, Core.ContextRouter)
end

return getRouter