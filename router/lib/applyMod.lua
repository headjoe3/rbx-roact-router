local RoactModule = game:GetService("ReplicatedStorage"):FindFirstChild("rbx-roact", true)
local Reconciler = require(RoactModule.roact.lib.Reconciler)
local Core = require(script.parent.Core);

-- Mods Roact to freeze the ceconciler when "RoactRouter.Freeze" is encountered
local function applyMod()
    local _reconcileInternal_original = Reconciler._reconcileInternal
    Reconciler._reconcileInternal = function(instance, element, ...)
        if (element and element.props[Core.Freeze]) then
            return instance
        end
        return _reconcileInternal_original(instance, element, ...)
    end
end

return applyMod