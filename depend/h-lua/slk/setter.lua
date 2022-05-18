function F6V_A(_v)
    _v._class = "ability"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    return _v
end

function F6V_U(_v)
    _v._class = "unit"
    _v._type = _v._type or "common"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    return _v
end

function F6V_I_CD(_v)
    if (_v._cooldown < 0) then
        _v._cooldown = 0
    end
    local cdID
    local ad = {}
    if (_v._cooldownTarget == CONST_ABILITY_TARGET.location.value) then
        -- 对点（模版：照明弹）
        ad._parent = "Afla"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v.cooldownTarget == CONST_ABILITY_TARGET.range.value) then
        -- 对点范围（模版：暴风雪）
        ad._parent = "ACbz"
        local av = hslk_ability(ad)
        cdID = av._id
    elseif (_v._cooldownTarget == CONST_ABILITY_TARGET.unit.value) then
        -- 对单位（模版：霹雳闪电）
        ad._parent = "ACfb"
        local av = hslk_ability(ad)
        cdID = av._id
    else
        -- 立刻（模版：金箱子）
        ad._parent = "AIgo"
        local av = hslk_ability(ad)
        cdID = av._id
    end
    return cdID
end

function F6V_I(_v)
    _v._class = "item"
    _v._type = _v._type or "common"
    if (_v._cooldown ~= nil) then
        F6V_I_CD(_v)
    end
    if (_v._parent == nil) then
        if (_v.class == "Charged") then
            _v._parent = "hlst"
        elseif (_v.class == "PowerUp") then
            _v._parent = "gold"
        else
            _v._parent = "rat9"
        end
    end
    return _v
end

function F6V_B(_v)
    _v._class = "buff"
    _v._type = _v._type or "common"
    return _v
end

function F6V_UP(_v)
    _v._class = "upgrade"
    _v._type = _v._type or "common"
    return _v
end
