-- 默认不支持pairs

--- 生成整数段
---@param n1 number integer
---@param n2 number integer
---@return table
table.section = function(n1, n2)
    n1 = math.floor(n1)
    n2 = math.floor(n2 or n1)
    local s = {}
    if (n1 == n2) then
        n2 = nil
    end
    if (n2 == nil) then
        for i = 1, n1 do
            table.insert(s, i)
        end
    else
        if (n1 < n2) then
            for i = n1, n2, 1 do
                table.insert(s, i)
            end
        else
            for i = n1, n2, -1 do
                table.insert(s, i)
            end
        end
    end
    return s
end

--- 随机在数组内取N个
--- 如果 n == 1, 则返回某值
--- 如果 n > 1, 则返回table
---@param arr table
---@return nil|any|any[]
function table.random(arr, n)
    if (type(arr) ~= "table") then
        return
    end
    n = n or 1
    if (n < 1) then
        return
    end
    if (n == 1) then
        return arr[math.random(1, #arr)]
    end
    local res = {}
    local l = #arr
    while (#res < n) do
        local rge = {}
        for i = 1, l do
            rge[i] = arr[i]
        end
        for i = 1, l do
            local j = math.random(i, #rge)
            table.insert(res, rge[j])
            if (#res >= n) then
                break
            end
            rge[i], rge[j] = rge[j], rge[i]
        end
    end
    return res
end

--- 洗牌
---@param arr table
---@return table
table.shuffle = function(arr)
    local shuffle = table.clone(arr)
    local length = #shuffle
    local temp
    local random
    while (length > 1) do
        random = math.random(1, length)
        temp = shuffle[length]
        shuffle[length] = shuffle[random]
        shuffle[random] = temp
        length = length - 1
    end
    return shuffle
end

--- 倒序
---@param arr table
---@return table
table.reverse = function(arr)
    local r = {}
    for i = #arr, 1, -1 do
        if (type(arr[i]) == "table") then
            table.insert(r, table.reverse(arr[i]))
        else
            table.insert(r, arr[i])
        end
    end
    return r
end

--- 重复table
---@param params any
---@param qty number integer
---@return table
table.repeater = function(params, qty)
    qty = math.floor(qty or 1)
    local r = {}
    for _ = 1, qty do
        table.insert(r, params)
    end
    return r
end

--- 克隆table
---@param org table
---@return table
table.clone = function(org)
    local function copy(org1, res)
        for _, v in ipairs(org1) do
            if type(v) ~= "table" then
                table.insert(res, v)
            else
                local rl = #res + 1
                res[rl] = {}
                copy(v, res[rl])
            end
        end
    end
    local res = {}
    copy(org, res)
    return res
end

--- 合并table
---@vararg table
---@return table
table.merge = function(...)
    local tempTable = {}
    local tables = { ... }
    if (tables == nil) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            for _, v in ipairs(tn) do
                table.insert(tempTable, v)
            end
        end
    end
    return tempTable
end

--- 在数组内
---@param arr table
---@param val any
---@return boolean
table.includes = function(arr, val)
    local isIn = false
    if (val == nil or #arr <= 0) then
        return isIn
    end
    for _, v in ipairs(arr) do
        if (v == val) then
            isIn = true
            break
        end
    end
    return isIn
end

--- 删除数组一次某个值(qty次,默认删除全部)
---@param arr table
---@param val any
---@param qty number
table.delete = function(arr, val, qty)
    qty = qty or -1
    local q = 0
    for k, v in ipairs(arr) do
        if (v == val) then
            q = q + 1
            table.remove(arr, k)
            k = k - 1
            if (qty ~= -1 and q >= qty) then
                break
            end
        end
    end
end

--- 根据key从数组table返回一个对应值的数组
---@param arr table
---@param key string
---@return table
table.value = function(arr, key)
    local values = {}
    if (arr ~= nil and key ~= nil and #arr > 0) then
        for _, v in ipairs(arr) do
            if (v[key] ~= nil) then
                table.insert(values, v[key])
            end
        end
    end
    return values
end

--- 将obj形式的attr数据转为有序数组{key=[key],value=[value]}
---@param obj table
---@param keyMap table
---@return table
table.obj2arr = function(obj, keyMap)
    if (keyMap == nil or type(keyMap) ~= "table" or #keyMap <= 0) then
        return {}
    end
    local arr = {}
    for _, a in ipairs(keyMap) do
        if (obj[a] ~= nil) then
            table.insert(arr, { key = a, value = obj[a] })
        end
    end
    return arr
end