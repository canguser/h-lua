hskill = {}

--- 获取属性加成,需要注册
---@param abilityId string|number
---@return table|nil
hskill.getAttribute = function(abilityId)
    if (type(abilityId) == "number") then
        abilityId = i2c(abilityId)
    end
    return hslk.i2v(abilityId, "_attr")
end

--- 附加单位获得技能后的属性
---@protected
hskill.addProperty = function(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr ~= nil) then
        if (#attr > 0) then
            level = level or 1
            attr = attr[level]
        end
        hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, true, whichUnit, attr, 1)
    end
end
--- 削减单位获得技能后的属性
---@protected
hskill.subProperty = function(whichUnit, abilityId, level)
    local attr = hskill.getAttribute(abilityId)
    if (attr ~= nil) then
        if (#attr > 0) then
            level = level or 1
            attr = attr[level]
        end
        hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, false, whichUnit, attr, 1)
    end
end

--- 获取技能名称
---@param abilityId number|string
---@return string
hskill.getName = function(abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    return cj.GetObjectName(id)
end

--- 添加技能
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
hskill.add = function(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    level = level or 1
    if (during == nil or during <= 0) then
        cj.UnitAddAbility(whichUnit, id)
        cj.UnitMakeAbilityPermanent(whichUnit, true, id)
        if (level > 1) then
            cj.SetUnitAbilityLevel(whichUnit, id, level)
        end
        hskill.addProperty(whichUnit, id, level)
    else
        cj.UnitAddAbility(whichUnit, id)
        if (level > 1) then
            cj.SetUnitAbilityLevel(whichUnit, id, level)
        end
        hskill.addProperty(whichUnit, id, level)
        htime.setTimeout(during, function(t)
            t.destroy()
            hskill.del(whichUnit, id)
        end)
    end
end

--- 设置技能等级
---@param whichUnit userdata
---@param abilityId string|number
---@param level number
---@param during number
hskill.set = function(whichUnit, abilityId, level, during)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    local prevLv = cj.GetUnitAbilityLevel(whichUnit, id)
    if (level == nil or level == prevLv) then
        return
    end
    if (prevLv < 1) then
        hskill.add(whichUnit, abilityId, level, during)
    else
        if (during == nil or during <= 0) then
            hskill.subProperty(whichUnit, id, prevLv)
            cj.SetUnitAbilityLevel(whichUnit, id, level)
            hskill.addProperty(whichUnit, id, level)
        else
            htime.setTimeout(during, function(t)
                t.destroy()
                hskill.set(whichUnit, abilityId, prevLv, nil)
            end)
        end
    end
end

--- 删除技能
---@param whichUnit userdata
---@param abilityId string|number
---@param delay number
hskill.del = function(whichUnit, abilityId, delay)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    local lv = cj.GetUnitAbilityLevel(whichUnit, id)
    if (lv < 1) then
        return
    end
    if (delay == nil or delay <= 0) then
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id, lv)
    else
        cj.UnitRemoveAbility(whichUnit, id)
        hskill.subProperty(whichUnit, id, lv)
        htime.setTimeout(delay, function(t)
            t.destroy()
            hskill.add(whichUnit, id, lv)
        end)
    end
end

--- 设置技能的永久使用性
---@param whichUnit userdata
---@param abilityId string|number
hskill.forever = function(whichUnit, abilityId)
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    cj.UnitMakeAbilityPermanent(whichUnit, true, id)
end

--- 是否拥有技能
---@param whichUnit userdata
---@param abilityId string|number
hskill.has = function(whichUnit, abilityId)
    if (whichUnit == nil or abilityId == nil) then
        return false
    end
    local id = abilityId
    if (type(abilityId) == "string") then
        id = c2i(id)
    end
    if (cj.GetUnitAbilityLevel(whichUnit, id) >= 1) then
        return true
    end
    return false
end

--- [JAPI]设置单位某个技能的冷却时间
---@param whichUnit userdata
---@param abilityId string|number
---@param coolDown number
hskill.setCoolDown = function(whichUnit, abilityId, coolDown)
    if (coolDown >= 9999) then
        coolDown = 9999
    elseif (coolDown < 0) then
        coolDown = 0
    end
    hjapi.EXSetAbilityState(hjapi.EXGetUnitAbility(whichUnit, abilityId), 1, coolDown)
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
    local damageSrc = options.damageSrc or CONST_DAMAGE_SRC.unknown
    -- 最终伤害
    local lastDamage = 0
    local lastDamagePercent = 0.0
    -- 文本显示
    local effect = options.effect
    -- 计算单位是否无敌
    if (his.invincible(targetUnit) == true) then
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
        -- 扣血
        hunit.subCurLife(targetUnit, lastDamage)
        if (type(effect) == "string" and string.len(effect) > 0) then
            heffect.xyz(effect, hunit.x(targetUnit), hunit.y(targetUnit), hunit.z(targetUnit), 0)
        end
        -- @触发伤害事件
        if (sourceUnit ~= nil) then
            hevent.trigger(
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
        hevent.trigger(targetUnit, CONST_EVENT.beDamage, {
            triggerUnit = targetUnit,
            sourceUnit = sourceUnit,
            damage = lastDamage,
            damageSrc = damageSrc,
        })
        if (damageSrc == CONST_DAMAGE_SRC.attack) then
            if (sourceUnit ~= nil) then
                -- @触发攻击事件
                hevent.trigger(sourceUnit, CONST_EVENT.attack, {
                    triggerUnit = sourceUnit,
                    targetUnit = targetUnit,
                    damage = lastDamage,
                })
            end
            -- @触发被攻击事件
            hevent.trigger(targetUnit, CONST_EVENT.beAttack, {
                triggerUnit = targetUnit,
                attackUnit = sourceUnit,
                damage = lastDamage,
            })
        end
    end
end

--- 无敌
---@param whichUnit userdata
---@param during number
---@param effect string
hskill.invulnerable = function(whichUnit, during, effect)
    if (whichUnit == nil) then
        return
    end
    if (during < 0) then
        during = 0.00 -- 如果设置持续时间错误，则0秒无敌
    end
    cj.UnitAddAbility(whichUnit, HL_ID.ability_invulnerable)
    if (during > 0 and effect ~= nil) then
        heffect.attach(effect, whichUnit, "origin", during)
    end
    htime.setTimeout(during, function(t)
        t.destroy()
        cj.UnitRemoveAbility(whichUnit, HL_ID.ability_invulnerable)
    end)
end