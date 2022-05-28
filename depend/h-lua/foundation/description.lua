---@class description
description = {}

---@type table 百分比key集合
description_KeysPercent = { "attack_speed", "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" }

---@type number integer
description_nameIdx = 0

--- 配置百分比键值
---@param keys string[]
---@return void
function description.setPercentKey(keys)
    for _, k in ipairs(keys) do
        if (table.includes(description_KeysPercent, k) == false) then
            table.insert(description_KeysPercent, k)
        end
    end
end

--- 键值是否百分比数据
---@param key string
---@return boolean
function description.isPercent(key)
    if (table.includes(description_KeysPercent, key)) then
        return true
    end
    local s = string.find(key, "_oppose")
    if (s ~= nil) then
        return true
    end
    return false
end

--- 无名氏
---@param key string
---@return boolean
function description.noName(name)
    description_nameIdx = description_nameIdx + 1
    return name .. "-" .. description_nameIdx
end

--- 属性 文本构建
---@param attr table<string,any>
---@param sep string 换行符|分隔符
---@param indent string 缩进
---@return string
function description.attribute(attr, sep, indent)
    sep = sep or "|n"
    indent = indent or ""
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. "秒"
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. "点/秒"
        end
        if (description.isPercent(k) == true) then
            v = v .. "%"
        end
        table.insert(str, indent .. (CONST_ATTR_LABEL[k] or "") .. "：" .. v)
    end
    return string.implode(sep, table.merge(str, strTable))
end

--- 属性学习时 文本构建
---@param attr table<string,any>
---@return string
function description.attributeResearch(attr)
    local str = {}
    local strTable = {}
    for _, arr in ipairs(table.obj2arr(attr, CONST_ATTR_KEYS)) do
        local k = arr.key
        local v = arr.value
        -- 附加单位
        if (k == "attack_space" or k == "reborn") then
            v = v .. "秒"
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. "点/秒"
        end
        if (description.isPercent(k) == true) then
            v = v .. "%"
        end
        table.insert(str, v .. (CONST_ATTR_LABEL[k] or ""))
    end
    return string.implode(",", table.merge(str, strTable))
end

--- 单位名称 文本构建
---@param value table slk 设定数据
---@return string
function description.unitName(value)
    return value.Name or description.noName("不知名单位")
end

--- 单位 文本构建
---@param value table slk 设定数据
---@return string
function description.unit(value)
    local strs
    if (value.Ubertip == nil or value.Ubertip == "") then
        strs = ""
    else
        strs = value.Ubertip .. "|n"
    end
    strs = strs .. hcolor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[value.weapTp1].label .. "(" .. value.cool1 .. "秒/击)", "ff3939")
    strs = strs .. "|n" .. hcolor.mixed("基本攻击：" .. value.dmgplus1, "ff8080")
    strs = strs .. "|n" .. hcolor.mixed("攻击范围：" .. value.rangeN1, "99ccff")
    strs = strs .. "|n" .. hcolor.mixed("移速：" .. value.spd .. " " .. CONST_MOVE_TYPE[value.movetp].label, "ccffcc")
    return strs
end

--- 单位·英雄名称 文本构建
---@param value table slk 设定数据
---@return string
function description.unitHeroName(value)
    return value.Name or description.noName("不知名英雄")
end

--- 单位·英雄 文本构建
---@param value table slk 设定数据
---@return string
function description.unitHero(value)
    local strs
    if (value.Ubertip == nil or value.Ubertip == "") then
        strs = ""
    else
        strs = value.Ubertip .. "|n"
    end
    strs = strs .. hcolor.mixed("攻击类型：" .. CONST_WEAPON_TYPE[value.weapTp1].label .. "(" .. value.cool1 .. "秒/击)", "ff3939")
    strs = strs .. "|n" .. hcolor.mixed("基本攻击：" .. value.dmgplus1, "ff8080")
    strs = strs .. "|n" .. hcolor.mixed("攻击范围：" .. value.rangeN1, "99ccff")
    if (value.Primary == "STR") then
        strs = strs .. "|n" .. hcolor.mixed("力量：" .. value.STR .. "(+" .. value.STRplus .. ")", "ffff00")
    else
        strs = strs .. "|n" .. hcolor.mixed("力量：" .. value.STR .. "(+" .. value.STRplus .. ")", "ffffcc")
    end
    if (value.Primary == "AGI") then
        strs = strs .. "|n" .. hcolor.mixed("敏捷：" .. value.AGI .. "(+" .. value.AGIplus .. ")", "ffff00")
    else
        strs = strs .. "|n" .. hcolor.mixed("敏捷：" .. value.AGI .. "(+" .. value.AGIplus .. ")", "ffffcc")
    end
    if (value.Primary == "INT") then
        strs = strs .. "|n" .. hcolor.mixed("智力：" .. value.INT .. "(+" .. value.INTplus .. ")", "ffff00")
    else
        strs = strs .. "|n" .. hcolor.mixed("智力：" .. value.INT .. "(+" .. value.INTplus .. ")", "ffffcc")
    end
    strs = strs .. "|n" .. hcolor.mixed("移速：" .. value.spd .. " " .. CONST_MOVE_TYPE[value.movetp].label, "ccffcc")
    return strs
end