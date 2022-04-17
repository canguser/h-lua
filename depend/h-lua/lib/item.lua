---@class hitem 物品
hitem = {}

--- 获取物品X坐标
---@param it userdata
---@return number
hitem.x = function(it)
    return cj.GetItemX(it)
end

--- 获取物品Y坐标
---@param it userdata
---@return number
hitem.y = function(it)
    return cj.GetItemY(it)
end

--- 获取物品Z坐标
---@param it userdata
---@return number
hitem.z = function(it)
    return hjapi.GetZ(cj.GetItemX(it), cj.GetItemY(it))
end

-- 单位嵌入到物品到框架系统
---@protected
hitem.embed = function(u)
    if (false == hcache.exist(u)) then
        -- 没有注册的单位直接跳过
        return
    end
    -- 如果单位的玩家是真人
    if (his.computer(hunit.getOwner(u)) == false) then
        -- 拾取
        hevent.pool(u, hevent_default_actions.item.pickup, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PICKUP_ITEM)
        end)
        -- 丢弃
        hevent.pool(u, hevent_default_actions.item.drop, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_DROP_ITEM)
        end)
        -- 抵押
        hevent.pool(u, hevent_default_actions.item.pawn, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_PAWN_ITEM)
        end)
        -- 使用
        hevent.pool(u, hevent_default_actions.item.use, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_USE_ITEM)
        end)
        hevent.pool(u, hevent_default_actions.item.use_s, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_SPELL_EFFECT)
        end)
    end
end

-- 清理物品缓存数据
---@protected
hitem.free = function(whichItem)
    hitemPool.free(whichItem)
    hevent.free(whichItem)
    hcache.free(whichItem)
end

--- match done
---@param whichUnit userdata
---@param whichItem userdata
---@param triggerData table
hitem.used = function(whichUnit, whichItem, triggerData)
    triggerData = triggerData or {}
    triggerData.triggerUnit = whichUnit
    triggerData.triggerItem = whichItem
    hevent.triggerEvent(whichUnit, CONST_EVENT.itemUsed, triggerData)
end

--- 删除物品，可延时
---@param it userdata
---@param delay number
hitem.del = function(it, delay)
    if (his.destroy(it)) then
        return
    end
    delay = delay or 0
    if (delay <= 0 and it ~= nil) then
        hitem.free(it)
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
    else
        htime.setTimeout(delay, function(t)
            t.destroy()
            if (his.destroy(it)) then
                return
            end
            hitem.free(it)
            cj.SetWidgetLife(it, 1.00)
            cj.RemoveItem(it)
        end)
    end
end

---@protected
hitem.delFromUnit = function(whichUnit)
    if (whichUnit ~= nil) then
        hitem.forEach(whichUnit, function(enumItem)
            if (enumItem ~= nil) then
                hitem.del(enumItem)
            end
        end)
    end
end

--- 获取物品ID字符串
---@param itOrId userdata|number|string
---@return string|nil
hitem.getId = function(itOrId)
    local id
    if (type(itOrId) == "userdata") then
        id = cj.GetItemTypeId(itOrId)
        if (id == 0) then
            return
        end
        id = i2c(id)
    elseif (type(itOrId) == "number") then
        id = i2c(itOrId)
    elseif (type(itOrId) == "string") then
        id = itOrId
    end
    return id
end

--- 获取物品名称
---@param itOrId userdata|string|number
---@return string
hitem.getName = function(itOrId)
    local n = ""
    if (type(itOrId) == "userdata") then
        n = cj.GetItemName(itOrId)
    elseif (type(itOrId) == "string" or type(itOrId) == "number") then
        n = hslk.i2v(itOrId, "slk", "Name")
    end
    return n
end

-- 获取物品的图标路径
---@param itOrId userdata|string|number
---@return string
hitem.getArt = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "Art")
end

--- 获取物品的模型路径
---@param itOrId userdata|string|number
---@return string
hitem.getFile = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "file")
end

--- 获取物品的分类
---@param itOrId userdata|string|number
---@return string
hitem.getClass = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "slk", "class")
end

--- 获取物品所需的金币
---@param itOrId userdata|string|number
---@return number
hitem.getGoldCost = function(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "goldcost") or 0)
end

--- 获取物品所需的木头
---@param itOrId userdata|string|number
---@return number
hitem.getLumberCost = function(itOrId)
    return math.floor(hslk.i2v(hitem.getId(itOrId), "slk", "lumbercost") or 0)
end

--- 获取物品是否可以使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsUsable = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "usable")
end

--- 获取物品是否自动使用
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPowerUp = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "powerup")
end

--- 获取物品是否使用后自动消失
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsPerishable = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "perishable")
end

--- 获取物品是否可卖
---@param itOrId userdata|string|number
---@return boolean
hitem.getIsSellAble = function(itOrId)
    return "1" == hslk.i2v(hitem.getId(itOrId), "slk", "sellable")
end

--- 获取物品的属性加成
---@param itOrId userdata|string|number
---@return table
hitem.getAttribute = function(itOrId)
    return hslk.i2v(hitem.getId(itOrId), "_attr") or {}
end

--- 获取物品的等级
---@param it userdata
---@return number
hitem.getLevel = function(it)
    if (it ~= nil) then
        return cj.GetItemLevel(it)
    end
    return 0
end

--- 获取物品的件数（以物品右下标的使用次数作为“件”）
--- 框架会自动强制最低件数为1
---@param it userdata
---@return number
hitem.getCharges = function(it)
    if (it == nil) then
        return 0
    end
    return cj.GetItemCharges(it)
end

--- 设置物品的使用次数
---@param it userdata
---@param charges number
hitem.setCharges = function(it, charges)
    if (it ~= nil and charges >= 0) then
        cj.SetItemCharges(it, charges)
    end
end

--- 获取某单位身上空格物品栏数量
---@param whichUnit userdata
---@return number
hitem.getEmptySlot = function(whichUnit)
    local qty = cj.UnitInventorySize(whichUnit)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        if (it ~= nil) then
            qty = qty - 1
        end
    end
    return qty
end

--- 循环获取某单位6格物品
---@alias SlotForEach fun(enumItem: userdata,slotIndex: number):void
---@param whichUnit userdata
---@param action SlotForEach | "function(enumItem, slotIndex) end"
---@return number
hitem.forEach = function(whichUnit, action)
    local it
    for i = 0, 5, 1 do
        it = cj.UnitItemInSlot(whichUnit, i)
        local res = action(it, i)
        if (type(res) == "boolean" and res == false) then
            break
        end
    end
end

--- 附加单位获得物品后的属性
---@protected
hitem.addProperty = function(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil) then
        return
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, true, whichUnit, hitem.getAttribute(itId), charges)
end

--- 削减单位获得物品后的属性
---@protected
hitem.subProperty = function(whichUnit, itId, charges)
    if (whichUnit == nil or itId == nil) then
        return
    end
    hattribute.caleAttribute(CONST_DAMAGE_SRC.item, false, whichUnit, hitem.getAttribute(itId), charges)
end

--[[
    创建物品
    options = {
        id = "I001", --物品ID
        charges = 1, --物品可使用次数（可选，默认为1）
        whichUnit = nil, --哪个单位（可选）
        x = nil, --哪个坐标X（可选）
        y = nil, --哪个坐标Y（可选）
        during = -1, --持续时间（可选，小于0无限制，如果有whichUnit，此项无效）
    }
]]
---@param options pilotItemCreate
---@return userdata|nil
hitem.create = function(options)
    if (options.id == nil) then
        err("hitem create -it-id")
        return
    end
    if (options.charges == nil) then
        local slkCharges = hslk.i2v(options.id, "slk", "uses")
        if (slkCharges == "") then
            slkCharges = nil
        else
            slkCharges = math.floor(slkCharges)
        end
        options.charges = slkCharges or 1
    end
    if (options.charges < 0) then
        return
    end
    local charges = options.charges
    local during = options.during or -1
    -- 优先级 坐标 > 单位
    local x, y
    local id = options.id
    if (options.x ~= nil and options.y ~= nil) then
        x = options.x
        y = options.y
    elseif (options.whichUnit ~= nil) then
        x = hunit.x(options.whichUnit)
        y = hunit.y(options.whichUnit)
    else
        err("hitem create -position")
        return
    end
    if (type(id) == "string") then
        id = c2i(id)
    end
    local it
    -- 如果不是创建给单位，又或者单位已经不存在了，直接返回
    if (options.whichUnit == nil or his.deleted(options.whichUnit) or his.dead(options.whichUnit)) then
        -- 掉在地上
        it = cj.CreateItem(id, x, y)
        cj.SetItemCharges(it, charges)
        hitemPool.insert(CONST_CACHE.ITEM_POOL_PICK, it)
        if (options.whichUnit ~= nil and during > 0) then
            htime.setTimeout(during, function(t)
                t.destroy()
                hitem.del(it, 0)
            end)
        end
    else
        -- 单位流程
        it = cj.CreateItem(id, x, y)
        cj.UnitAddItem(options.whichUnit, it)
    end
    return it
end

--- 使一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.give = function(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create({
                id = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target
            })
        end
        hitem.del(it, 0)
    end
end

--- 操作物品给一个单位
---@param it userdata
---@param targetUnit userdata
hitem.pick = function(it, targetUnit)
    if (it == nil or targetUnit == nil) then
        return
    end
    cj.UnitAddItem(targetUnit, it)
end

--- 复制一个单位的所有物品给另一个单位
---@param origin userdata
---@param target userdata
hitem.copy = function(origin, target)
    if (origin == nil or target == nil) then
        return
    end
    for i = 0, 5, 1 do
        local it = cj.UnitItemInSlot(origin, i)
        if (it ~= nil) then
            hitem.create({
                id = hitem.getId(it),
                charges = hitem.getCharges(it),
                whichUnit = target,
            })
        end
    end
end

--- 令一个单位把物品扔在地上
---@param origin userdata
---@param slot nil|number 物品位置
hitem.drop = function(origin, slot)
    if (origin == nil or his.deleted(origin) or his.dead(origin)) then
        return
    end
    if (slot == nil) then
        for i = 0, 5, 1 do
            local it = cj.UnitItemInSlot(origin, i)
            if (it ~= nil) then
                cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
            end
        end
    else
        local it = cj.UnitItemInSlot(origin, slot)
        if (it ~= nil) then
            cj.UnitDropItemPoint(origin, it, hunit.x(origin), hunit.y(origin))
        end
    end
end

--- 一键拾取区域(x,y)长宽(w,h)
---@param u userdata
---@param x number
---@param y number
---@param w number
---@param h number
hitem.pickRect = function(u, x, y, w, h)
    if (u == nil or his.deleted(u) or his.dead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        local xi = cj.GetItemX(enumItem)
        local yi = cj.GetItemY(enumItem)
        local d = math.getDistanceBetweenXY(x, y, xi, yi)
        local deg = math.getDegBetweenXY(x, y, xi, yi)
        local distance = math.getMaxDistanceInRect(w, h, deg)
        if (d <= distance) then
            table.insert(items, enumItem)
        end
    end)
end

-- 一键拾取圆(x,y)半径(r)
---@param u userdata
---@param x number
---@param y number
---@param r number
hitem.pickRound = function(u, x, y, r)
    if (u == nil or his.deleted(u) or his.dead(u)) then
        return
    end
    local items = {}
    hitemPool.forEach(CONST_CACHE.ITEM_POOL_PICK, function(enumItem)
        local xi = cj.GetItemX(enumItem)
        local yi = cj.GetItemY(enumItem)
        local d = math.getDistanceBetweenXY(x, y, xi, yi)
        if (d <= r) then
            table.insert(items, enumItem)
        end
    end)
end