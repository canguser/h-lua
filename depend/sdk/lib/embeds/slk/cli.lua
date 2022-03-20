require 'h-lua-console'
require 'const.enchant'
require 'const.abilityTarget'
require 'const.attribute'
require 'const.ubertip'
require 'const.cache'
require 'const.damageSource'
require 'const.damageType'
require 'const.event'
require 'const.hero'
require 'const.hotKey'
require 'const.item'
require 'const.monitor'
require 'const.target'
require 'const.textTag'
require 'const.unit'
require 'const.orderStr'
require 'foundation.color'
require 'foundation.json'
require 'foundation.array'
require 'foundation.math'
require 'foundation.string'
require 'foundation.table'
require 'h-lua-slk.pilot'
require 'h-lua-slk.setter'
require 'h-lua-slk.slk'
require 'h-lua-slk.system'
require 'main'
if (cj ~= nil) then
    local t = cj.CreateTrigger()
    cj.TriggerRegisterTimerEvent(t, 0.1, false)
    cj.TriggerAddAction(t, function()
        cj.DisableTrigger(t)
        cj.DestroyTrigger(t)
        t = nil
        if (type(main) == "function") then
            main()
        end
    end)
else
    if (type(main) == "function") then
        main()
    end
end
