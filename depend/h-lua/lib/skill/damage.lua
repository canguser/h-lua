-- 伤害漂浮字
local _damageTtgQty = 0
local _damageTtg = function(targetUnit, damage, fix, rgb, speed)
    _damageTtgQty = _damageTtgQty + 1
    local during = 1.0
    local x = hunit.x(targetUnit) - 0.05 - _damageTtgQty * 0.013
    local y = hunit.y(targetUnit)
    htextTag.model({ msg = fix .. math.floor(damage), x = x, y = y, red = rgb[1], green = rgb[2], blue = rgb[3], speed = speed })
    htime.setTimeout(during, function(t)
        t.destroy()
        _damageTtgQty = _damageTtgQty - 1
    end)
end

--[[
    造成伤害
    options = {
        sourceUnit = nil, --伤害来源(可选)
        targetUnit = nil, --目标单位
        damage = 0, --实际伤害
        damageString = "", --伤害漂浮字颜色
        damageRGB = {255,255,255}, --伤害漂浮字颜色RGB
        effect = nil, --伤害特效
        damageSrc = "unknown", --伤害来源请查看 CONST_DAMAGE_SRC
    }
]]
---@param options pilotDamage
hskill.damage = function(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    local damage = options.damage or 0
    if (damage < 0.125) then
        return
    end
    if (targetUnit == nil) then
        return
    end
    if (his.dead(options.targetUnit) or his.deleted(targetUnit)) then
        return
    end
    if (his.deleted(targetUnit)) then
        return
    end
    if (sourceUnit ~= nil and his.deleted(sourceUnit)) then
        return
    end
    if (options.damageSrc == nil) then
        options.damageSrc = CONST_DAMAGE_SRC.unknown
    end
    --双方attr get
    if (hattribute.get(targetUnit) == nil) then
        return
    end
    if (sourceUnit ~= nil and hattribute.get(sourceUnit) == nil) then
        return
    end
    local damageSrc = options.damageSrc
    -- 最终伤害
    local lastDamage = 0
    local lastDamagePercent = 0.0
    -- 文本显示
    local damageString = options.damageString or ""
    local damageRGB = options.damageRGB or { 255, 255, 255 }
    local effect = options.effect
    local speed
    -- 判断伤害方式
    if (damageSrc == CONST_DAMAGE_SRC.attack) then
        if (his.unarm(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.skill) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    elseif (damageSrc == CONST_DAMAGE_SRC.item) then
        if (his.silent(sourceUnit) == true) then
            return
        end
    else
        damageSrc = CONST_DAMAGE_SRC.unknown
    end
    -- 计算单位是否无敌
    if (his.invincible(targetUnit) == true) then
        htextTag.model({ msg = "无敌", whichUnit = targetUnit, red = 255, green = 215, blue = 0 })
        return
    end
    -- 伤害计算
    lastDamage = damage
    if (lastDamage > 0) then
        -- 计算护甲
        local defend = hattr.get(targetUnit, "defend")
        if (defend ~= 0) then
            lastDamage = lastDamage - defend
        end
        -- 合计 lastDamagePercent
        lastDamage = lastDamage * (1 + lastDamagePercent)
    end
    -- 上面都是先行计算
    if (lastDamage > 0.125 and his.deleted(targetUnit) == false) then
        -- 设置单位|玩家正在受伤
        local isBeDamagingTimer = hcache.get(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        if (isBeDamagingTimer ~= nil) then
            isBeDamagingTimer.destroy()
            hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        end
        hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, true)
        hcache.set(
            targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER,
            htime.setTimeout(3.5, function(t)
                t.destroy()
                hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
                hcache.set(targetUnit, CONST_CACHE.ATTR_BE_DAMAGING, false)
            end)
        )
        local targetPlayer = hunit.getOwner(targetUnit)
        hplayer.addBeDamage(targetPlayer, lastDamage)
        local isPlayerBeDamagingTimer = hcache.get(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        if (isPlayerBeDamagingTimer ~= nil) then
            isPlayerBeDamagingTimer.destroy()
            hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
        end
        hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING, true)
        hcache.set(
            targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER,
            htime.setTimeout(3.5, function(t)
                t.destroy()
                hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING_TIMER, nil)
                hcache.set(targetPlayer, CONST_CACHE.ATTR_BE_DAMAGING, false)
            end)
        )
        -- 设置单位|玩家正在造成伤害
        if (sourceUnit ~= nil and his.deleted(sourceUnit) == false) then
            local isDamagingTimer = hcache.get(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            if (isDamagingTimer ~= nil) then
                isDamagingTimer.destroy()
                hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            end
            hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING, true)
            hevent.setLastDamage(sourceUnit, targetUnit)
            hcache.set(
                sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER,
                htime.setTimeout(3.5, function(t)
                    t.destroy()
                    hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
                    hcache.set(sourceUnit, CONST_CACHE.ATTR_DAMAGING, false)
                    hevent.setLastDamage(sourceUnit, nil)
                end)
            )
            local sourcePlayer = hunit.getOwner(sourceUnit)
            hplayer.addDamage(sourcePlayer, lastDamage)
            local isPlayerDamagingTimer = hcache.get(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            if (isPlayerDamagingTimer ~= nil) then
                isPlayerDamagingTimer.destroy()
                hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
            end
            hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING, true)
            hcache.set(
                sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER,
                htime.setTimeout(3.5, function(t)
                    t.destroy()
                    hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING_TIMER, nil)
                    hcache.set(sourcePlayer, CONST_CACHE.ATTR_DAMAGING, false)
                end)
            )
        end
        -- 造成伤害及漂浮字
        _damageTtg(targetUnit, lastDamage, damageString, damageRGB, speed)
        --
        hunit.subCurLife(targetUnit, lastDamage)
        if (type(effect) == "string" and string.len(effect) > 0) then
            heffect.toXY(effect, hunit.x(targetUnit), hunit.y(targetUnit), 0)
        end
        -- @触发伤害事件
        if (sourceUnit ~= nil) then
            hevent.triggerEvent(
                sourceUnit,
                CONST_EVENT.damage,
                {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    damage = lastDamage,
                    damageSrc = damageSrc,
                }
            )
        end
        -- @触发被伤害事件
        hevent.triggerEvent(targetUnit, CONST_EVENT.beDamage, {
            triggerUnit = targetUnit,
            sourceUnit = sourceUnit,
            damage = lastDamage,
            damageSrc = damageSrc,
        })
        if (damageSrc == CONST_DAMAGE_SRC.attack) then
            if (sourceUnit ~= nil) then
                -- @触发攻击事件
                hevent.triggerEvent(sourceUnit, CONST_EVENT.attack, {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    damage = lastDamage,
                })
            end
            -- @触发被攻击事件
            hevent.triggerEvent(targetUnit, CONST_EVENT.beAttack, {
                triggerUnit = targetUnit,
                attackUnit = sourceUnit,
                damage = lastDamage,
            })
        end
    end
end

--[[
    多频多段伤害
    特别适用于例如中毒，灼烧等效果
    options = {
        targetUnit = [unit], --受伤单位（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        extraInfluence = [function],
        -- 其他的和伤害函数一致，例如：
        effect = "", --特效（可选）
        damage = 0, --单次伤害（大于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
    }
]]
---@param options pilotDamageStep
hskill.damageStep = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    options.damage = options.damage or 0
    if (options.targetUnit == nil) then
        err("hskill.damageStep:-targetUnit")
        return
    end
    if (times <= 0 or options.damage <= 0) then
        err("hskill.damageStep:-times -damage")
        return
    end
    if (times > 1 and frequency <= 0) then
        err("hskill.damageStep:-frequency")
        return
    end
    if (times <= 1) then
        hskill.damage(options)
        if (type(options.extraInfluence) == "function") then
            options.extraInfluence(options.targetUnit)
        end
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                t.destroy()
                return
            end
            hskill.damage(options)
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(options.targetUnit)
            end
        end)
    end
end

--[[
    范围持续伤害
    options = {
        radius = 0, --半径范围（必须有）
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --特效（可选）
        effectSingle = "", --单体特效（可选）
        filter = [function], --必须有
        whichUnit = [unit], --中心单位的位置（可选）
        x = [point], --目标坐标X（可选）
        y = [point], --目标坐标Y（可选）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
        extraInfluence = [function],
    }
]]
---@param options pilotDamageRange
hskill.damageRange = function(options)
    local radius = options.radius or 0
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (radius <= 0 or times <= 0) then
        err("hskill.damageRange:-radius -times")
        return
    end
    if (times > 1 and frequency <= 0) then
        err("hskill.damageRange:-frequency")
        return
    end
    local x, y
    if (options.x ~= nil or options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    end
    if (x == nil or y == nil) then
        err("hskill.damageRange:-x -y")
        return
    end
    local filter = options.filter
    if (type(filter) ~= "function") then
        err("filter must be function")
        return
    end
    if (options.effect ~= nil) then
        heffect.toXY(options.effect, x, y, 0.25 + (times * frequency))
    end
    if (times <= 1) then
        local g = hgroup.createByXY(x, y, radius, filter)
        if (g == nil) then
            return
        end
        if (hgroup.count(g) <= 0) then
            return
        end
        hgroup.forEach(g, function(eu)
            hskill.damage({
                sourceUnit = options.sourceUnit,
                targetUnit = eu,
                effect = options.effectSingle,
                damage = damage,
                damageSrc = options.damageSrc,
                damageRGB = options.damageRGB,
            })
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(eu)
            end
        end)
        g = nil
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                t.destroy()
                return
            end
            local g = hgroup.createByXY(x, y, radius, filter)
            if (g == nil) then
                return
            end
            if (hgroup.count(g) <= 0) then
                return
            end
            hgroup.forEach(g, function(eu)
                hskill.damage({
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    effect = options.effectSingle,
                    damage = damage,
                    damageSrc = options.damageSrc,
                    damageRGB = options.damageRGB,
                })
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end)
            g = nil
        end)
    end
end

--[[
    单位组持续伤害
    options = {
        frequency = 0, --伤害频率（必须有）
        times = 0, --伤害次数（必须有）
        effect = "", --伤害特效（可选）
        whichGroup = [group], --单位组（必须有）
        damage = 0, --伤害（可选，但是这里可以等于0）
        sourceUnit = [unit], --伤害来源单位（可选）
        damageSrc = CONST_DAMAGE_SRC, --伤害的来源（可选）
        extraInfluence = [function],
    }
]]
hskill.damageGroup = function(options)
    local times = options.times or 0
    local frequency = options.frequency or 0
    local damage = options.damage or 0
    if (options.whichGroup == nil) then
        err("hskill.damageGroup:-whichGroup")
        return
    end
    if (times <= 0 or frequency < 0) then
        err("hskill.damageGroup:-times -frequency")
        return
    end
    if (times <= 1) then
        hgroup.forEach(options.whichGroup, function(eu)
            hskill.damage({
                sourceUnit = options.sourceUnit,
                targetUnit = eu,
                effect = options.effect,
                damage = damage,
                damageSrc = options.damageSrc,
            })
            if (type(options.extraInfluence) == "function") then
                options.extraInfluence(eu)
            end
        end)
    else
        local ti = 0
        htime.setInterval(frequency, function(t)
            ti = ti + 1
            if (ti > times) then
                t.destroy()
                return
            end
            hgroup.forEach(options.whichGroup, function(eu)
                hskill.damage({
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    effect = options.effect,
                    damage = damage,
                    damageSrc = options.damageSrc,
                })
                if (type(options.extraInfluence) == "function") then
                    options.extraInfluence(eu)
                end
            end)
        end)
    end
end
