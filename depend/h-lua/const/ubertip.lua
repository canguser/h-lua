CONST_UBERTIP_I18N = {
    colon = "：",
    def_passive = "未命名空被动",
    def_skill = "未命名技能",
    def_hero = "未命名英雄",
    def_unit = "未命名单位",
    def_item = "未命名物品",
    def_buff = "未命名魔法效果",
    def_upgrade = "未命名科技",
    lv = "等级",
    learn = "学习",
    choose = "选择",
    get = "获得",
    cd = "冷却",
    sec = "秒",
    perSec = "每秒",
    layer = "层",
    weapTp1 = "攻击类型",
    cool1 = "秒/击",
    dmgplus1 = "基础攻击",
    rangeN1 = "攻击范围",
    STR = "力量",
    AGI = "敏捷",
    INT = "智力",
    spd = "移动",
    ally = "友军",
    enemies = "敌军",
    enemy = "敌人",
    self = "自己",
}

--- 属性系统目标文本修正
CONST_UBERTIP_TARGET_LABEL = function(target, actionType, actionField, isValue)
    if (actionType == 'spec' and isValue ~= true and table.includes({ 'split', 'bomb', 'lightning_chain' }, actionField)) then
        if (target == '己') then
            target = CONST_UBERTIP_I18N.ally
        else
            target = CONST_UBERTIP_I18N.enemies
        end
    else
        if (target == '己') then
            target = CONST_UBERTIP_I18N.self
        else
            target = CONST_UBERTIP_I18N.enemy
        end
    end
    return target
end

--- 键值是否百分比数据
CONST_UBERTIP_IS_PERCENT = function(key)
    if (table.includes({
        "attack_speed", "avoid", "aim",
        "hemophagia", "hemophagia_skill",
        "siphon", "siphon_skill",
        "invincible",
        "knocking_odds", "knocking_extent",
        "damage_extent", "damage_decrease", "damage_rebound",
        "cure",
        "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio",
        "knocking", "split",
    }, key)) then
        return true
    end
    local s = string.find(key, "_oppose")
    local n = string.find(key, "e_")
    local a = string.find(key, "_attack")
    local p = string.find(key, "_append")
    if (a ~= nil or p ~= nil) then
        return false
    end
    if (s ~= nil or n == 1) then
        return true
    end
    return false
end

--- 键值是否层级数据
CONST_UBERTIP_IS_LEVEL = function(key)
    local a = string.find(key, "_attack")
    local p = string.find(key, "_append")
    local n = string.find(key, "e_")
    if ((a ~= nil or p ~= nil) and n == 1) then
        return true
    end
    return false
end

--- _attr文本构建
CONST_UBERTIP_ATTR = function(attr, sep, indent)
    sep = sep or "|n"
    indent = indent or ""
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. CONST_UBERTIP_I18N.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_I18N.perSec
        end
        if (CONST_UBERTIP_IS_PERCENT(k) == true) then
            v = v .. "%"
        end
        if (CONST_UBERTIP_IS_LEVEL(k) == true) then
            v = v .. CONST_UBERTIP_I18N.layer
        end
        table.insert(str, indent .. (CONST_ATTR_LABEL[k] or "") .. "：" .. v)
    end
    return string.implode(sep, table.merge(str, strTable))
end

--- _attr学习文本构建
CONST_UBERTIP_RESEARCH_ATTR = function(attr)
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. CONST_UBERTIP_I18N.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_I18N.perSec
        end
        if (CONST_UBERTIP_IS_PERCENT(k) == true) then
            v = v .. "%"
        end
        if (CONST_UBERTIP_IS_LEVEL(k) == true) then
            v = v .. CONST_UBERTIP_I18N.layer
        end
        table.insert(str, v .. (CONST_ATTR_LABEL[k] or ""))
    end
    return string.implode(",", table.merge(str, strTable))
end