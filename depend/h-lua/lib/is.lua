---@deprecated
---@class his 判断
his = {}

local deprecated = function(new)
    print(" * [deprecated] his." .. debug.getinfo(2).name .. " 将于后续删除，请尽快使用 " .. new .. " 代替 ")
end

--- 是否电脑(如果位置为电脑玩家或无玩家，则为true)
--- 常用来判断电脑AI是否开启
---@param whichPlayer userdata
---@return boolean
function his.computer(whichPlayer)
    deprecated("hplayer.isComputer")
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER or cj.GetPlayerSlotState(whichPlayer) ~= PLAYER_SLOT_STATE_PLAYING
end

--- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)
--- 常用来判断该是否玩家可填补位置
---@param whichPlayer userdata
---@return boolean
function his.playerSite(whichPlayer)
    deprecated("hplayer.isUser")
    return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER
end

--- 是否正在游戏
---@param whichPlayer userdata
---@return boolean
function his.playing(whichPlayer)
    deprecated("hplayer.isPlaying")
    return cj.GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING
end

--- 是否中立玩家（包括中立敌对 中立被动 中立受害 中立特殊）
---@param whichPlayer userdata
---@return boolean
function his.neutral(whichPlayer)
    deprecated("hplayer.isNeutral")
    local flag = false
    if (whichPlayer == nil) then
        flag = false
    elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
        flag = true
    elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_VICTIM)) then
        flag = true
    elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_EXTRA)) then
        flag = true
    elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
        flag = true
    end
    return flag
end

--- 是否在某玩家真实视野内
---@param whichUnit userdata
---@return boolean
function his.detected(whichUnit, whichPlayer)
    deprecated("hunit.isDetected")
    if (whichUnit == nil or whichPlayer == nil) then
        return false
    end
    return cj.IsUnitDetected(whichUnit, whichPlayer) == true
end

--- 是否拥有物品栏
--- 经测试(1.27a)单位物品栏（各族）等价物英雄物品栏，等级为1，即使没有科技
--- RPG应去除多余的物品栏，确保判定的准确性
---@param whichUnit userdata
---@param slotId number
---@return boolean
function his.hasSlot(whichUnit, slotId)
    deprecated("hunit.hasSlot")
    if (slotId == nil) then
        slotId = HL_ID.ability_item_slot
    end
    return cj.GetUnitAbilityLevel(whichUnit, slotId) >= 1
end

--- 单位是否可攻击
---@param whichUnit userdata
---@return boolean
function his.canAttack(whichUnit)
    deprecated("hunit.isAttackAble")
    return "0" ~= (hslk.i2v(hunit.getId(whichUnit), "slk", "weapsOn") or "0")
end

--- 是否死亡
---@param whichUnit userdata
---@return boolean
function his.dead(whichUnit)
    deprecated("hunit.isDead")
    return (true == hcache.get(whichUnit, CONST_CACHE.UNIT_DEAD)) or cj.IsUnitType(whichUnit, UNIT_TYPE_DEAD) or (cj.GetUnitState(whichUnit, UNIT_STATE_LIFE) <= 0)
end

--- 是否生存
---@param whichUnit userdata
---@return boolean
function his.alive(whichUnit)
    deprecated("hunit.isAlive")
    return false == hunit.isDead(whichUnit)
end

--- 单位是否已被删除
---@param whichUnit userdata
---@return boolean
function his.unitDestroyed(whichUnit)
    deprecated("hunit.isDestroyed")
    return cj.GetUnitTypeId(whichUnit) == 0 or (hunit.isDead(whichUnit) and false == hcache.exist(whichUnit))
end

--- 是否无敌
---@param whichUnit userdata
---@return boolean
function his.invincible(whichUnit)
    deprecated("hunit.isInvincible")
    return cj.GetUnitAbilityLevel(whichUnit, HL_ID.ability_invulnerable) > 0
end

--- 是否英雄
--- UNIT_TYPE_HERO是对应平衡常数的英雄列表
--- hero对应hslk._type，是本框架固有用法
---@param whichUnit userdata
---@return boolean
function his.hero(whichUnit)
    deprecated("hunit.isHero")
    local uid = hunit.getId(whichUnit)
    if (uid == nil) then
        return false
    end
    return "hero" == (hslk.i2v(uid, "_type") or "common") or cj.IsUnitType(whichUnit, UNIT_TYPE_HERO)
end

--- 是否建筑
---@param whichUnit userdata
---@return boolean
function his.structure(whichUnit)
    deprecated("hunit.isStructure")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)
end

--- 是否镜像
---@param whichUnit userdata
---@return boolean
function his.illusion(whichUnit)
    deprecated("hunit.isIllusion")
    return cj.IsUnitIllusion(whichUnit)
end

--- 是否地面单位
---@param whichUnit userdata
---@return boolean
function his.ground(whichUnit)
    deprecated("hunit.isGround")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_GROUND)
end

--- 是否空中单位
---@param whichUnit userdata
---@return boolean
function his.air(whichUnit)
    deprecated("hunit.isAir")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_FLYING)
end

--- 是否近战
---@param whichUnit userdata
---@return boolean
function his.melee(whichUnit)
    deprecated("hunit.isMelee")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end

--- 是否远程
---@param whichUnit userdata
---@return boolean
function his.ranged(whichUnit)
    deprecated("hunit.isRanged")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
end

--- 是否召唤
---@param whichUnit userdata
---@return boolean
function his.summoned(whichUnit)
    deprecated("hunit.isSummoned")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)
end

--- 是否机械
---@param whichUnit userdata
---@return boolean
function his.mechanical(whichUnit)
    deprecated("hunit.isMechanical")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)
end

--- 是否古树
---@param whichUnit userdata
---@return boolean
function his.ancient(whichUnit)
    deprecated("hunit.isAncient")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)
end

--- 是否自爆工兵
---@param whichUnit userdata
---@return boolean
function his.sapper(whichUnit)
    deprecated("hunit.isSapper")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_SAPPER)
end

--- 是否虚无状态
---@param whichUnit userdata
---@return boolean
function his.ethereal(whichUnit)
    deprecated("hunit.isEthereal")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_ETHEREAL)
end

--- 是否魔法免疫
---@param whichUnit userdata
---@return boolean
function his.immune(whichUnit)
    deprecated("hunit.isImmune")
    return cj.IsUnitType(whichUnit, UNIT_TYPE_MAGIC_IMMUNE)
end

--- 是否某个种族
---@param whichUnit userdata
---@param whichRace userdata 参考 blizzard:^RACE
---@return boolean
function his.race(whichUnit, whichRace)
    deprecated("hunit.isRace")
    return cj.IsUnitRace(whichUnit, whichRace)
end

--- 是否蝗虫
---@param whichUnit userdata
---@return boolean
function his.locust(whichUnit)
    deprecated("hunit.isLocust")
    return cj.GetUnitAbilityLevel(whichUnit, HL_ID.ability_locust) > 0
end

--- 是否正在受伤
---@param whichUnit userdata
---@return boolean
function his.beDamaging(whichUnit)
    deprecated("hunit.isBeDamaging")
    return hcache.get(whichUnit, CONST_CACHE.ATTR_BE_DAMAGING, false)
end

--- 是否正在造成伤害
---@param whichUnit userdata
---@return boolean
function his.damaging(whichUnit)
    deprecated("hunit.isDamaging")
    return hcache.get(whichUnit, CONST_CACHE.ATTR_DAMAGING, false)
end

--- 玩家是否正在受伤
---@param whichPlayer userdata
---@return boolean
function his.playerBeDamaging(whichPlayer)
    deprecated("hplayer.isBeDamaging")
    return hcache.get(whichPlayer, CONST_CACHE.ATTR_BE_DAMAGING, false)
end

--- 玩家是否正在造成伤害
---@param whichPlayer userdata
---@return boolean
function his.playerDamaging(whichPlayer)
    deprecated("hplayer.isDamaging")
    return hcache.get(whichPlayer, CONST_CACHE.ATTR_DAMAGING, false)
end

--- 是否处在水面
---@param whichUnit userdata
---@return boolean
function his.water(whichUnit)
    deprecated("hunit.isWater")
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == false
end

--- 是否处于地面
---@param whichUnit userdata
---@return boolean
function his.floor(whichUnit)
    deprecated("hunit.isFloor")
    return cj.IsTerrainPathable(hunit.x(whichUnit), hunit.y(whichUnit), PATHING_TYPE_FLOATABILITY) == true
end

--- 是否某个特定单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function his.unit(whichUnit, otherUnit)
    deprecated("hunit.isUnit")
    return cj.IsUnit(whichUnit, otherUnit)
end

--- 是否敌人单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function his.enemy(whichUnit, otherUnit)
    deprecated("hunit.isEnemy")
    return cj.IsUnitEnemy(whichUnit, hunit.getOwner(otherUnit))
end

--- 是否友军单位
---@param whichUnit userdata
---@param otherUnit userdata
---@return boolean
function his.ally(whichUnit, otherUnit)
    deprecated("hunit.isAlly")
    return cj.IsUnitAlly(whichUnit, hunit.getOwner(otherUnit))
end

--- 是否敌人玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
function his.enemyPlayer(whichUnit, whichPlayer)
    deprecated("hunit.isEnemyPlayer")
    return cj.IsUnitEnemy(whichUnit, whichPlayer)
end

--- 是否友军玩家
---@param whichUnit userdata
---@param whichPlayer userdata
---@return boolean
function his.allyPlayer(whichUnit, whichPlayer)
    deprecated("hunit.isAllyPlayer")
    return cj.IsUnitAlly(whichUnit, whichPlayer)
end

--- 玩家是否有贴图在展示
---@param whichPlayer userdata
---@return boolean
function his.marking(whichPlayer)
    deprecated("hunit.isMarking")
    return hcache.get(whichPlayer, CONST_CACHE.PLAYER_MARKING) == true
end

--- 是否在区域内
function his.inRect(whichRect, x, y)
    deprecated("hrect.isInner")
    return (x < hrect.getMaxX(whichRect) and x > hrect.getMinX(whichRect) and y < hrect.getMaxY(whichRect) and y > hrect.getMinY(whichRect))
end

--- 是否超出区域边界
---@param whichRect userdata
---@param x number
---@param y number
---@return boolean
function his.borderRect(whichRect, x, y)
    deprecated("hrect.isBorder")
    local flag = false
    if (x >= hrect.getMaxX(whichRect) or x <= hrect.getMinX(whichRect)) then
        flag = true
    end
    if (y >= hrect.getMaxY(whichRect) or y <= hrect.getMinY(whichRect)) then
        return true
    end
    return flag
end

--- 是否超出地图边界
---@param x number
---@param y number
---@return boolean
function his.borderMap(x, y)
    deprecated("hrect.isBorderPlayable")
    return his.borderRect(hrect.playable(), x, y)
end

--- 是否超出镜头边界
---@param x number
---@param y number
---@return boolean
function his.borderCamera(x, y)
    deprecated("hrect.isBorderCamera")
    return his.borderRect(hrect.camera(), x, y)
end

--- 物品是否已被销毁
---@param whichItem userdata
---@return boolean
function his.itemDestroyed(whichItem)
    deprecated("hitem.isDestroyed")
    return cj.GetItemTypeId(whichItem) == 0
end

--- 是否身上有某种物品
---@param whichUnit userdata
---@param whichItemId number|string
---@return boolean
function his.hasItem(whichUnit, whichItemId)
    deprecated("hunit.hasItem")
    local f = false
    if (type(whichItemId) == "string") then
        whichItemId = c2i(whichItemId)
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil and cj.GetItemTypeId(it) == whichItemId) then
            f = true
            break
        end
    end
    return f
end
