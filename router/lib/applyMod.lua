local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Reconciler = require(RoactModule.roact.lib.Reconciler)
local Core = require(script.parent.Core);

local function applyMod()
    -- MOD: Freeze when "Core.Freeze" is encountered!
    local _reconcileInternal_original = Reconciler._reconcileInternal
    Reconciler._reconcileInternal = function(instance, element, ...)
        if (element and element.props[Core.Freeze]) then
            return instance
        end
        return _reconcileInternal_original(instance, element, ...)
    end
end

return applyMod()