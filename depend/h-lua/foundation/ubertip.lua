---@class ubertip
ubertip = {}

---@type table 百分比key集合
ubertip_KeysPercent = { "attack_speed", "gold_ratio", "lumber_ratio", "exp_ratio", "sell_ratio" }

--- 配置百分比键值
---@param keys string[]
---@return void
function ubertip.setPercentKey(keys)
    for _, k in ipairs(keys) do
        if (table.includes(ubertip_KeysPercent, k) == false) then
            table.insert(ubertip_KeysPercent, k)
        end
    end
end

--- 键值是否百分比数据
---@param key string
---@return boolean
function ubertip.isPercent(key)
    if (table.includes(ubertip_KeysPercent, key)) then
        return true
    end
    local s = string.find(key, "_oppose")
    if (s ~= nil) then
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
            v = v .. CONST_UBERTIP_TEXTS.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_TEXTS.perSec
        end
        if (ubertip.isPercent(k) == true) then
            v = v .. "%"
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
            v = v .. CONST_UBERTIP_TEXTS.sec
        end
        if (table.includes({ "life_back", "mana_back" }, k)) then
            v = v .. CONST_UBERTIP_TEXTS.perSec
        end
        if (ubertip.isPercent(k) == true) then
            v = v .. "%"
        end
        table.insert(str, v .. (CONST_ATTR_LABEL[k] or ""))
    end
    return string.implode(",", table.merge(str, strTable))
end