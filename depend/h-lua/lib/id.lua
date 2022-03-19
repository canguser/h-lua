HL_ID = {}
HL_ID_INIT = function()
    HL_ID = {
        buff_swim = string.char2id("BPSE"), -- 默认眩晕状态
        unit_token = string.char2id(hslk.n2i("H_LUA_UNIT_TOKEN")),
        unit_token_leap = string.char2id(hslk.n2i("H_LUA_UNIT_TOKEN_LEAP")), --leap的token模式，需导入模型：SDK/hLua/token.mdx
        unit_token_ttg = string.char2id(hslk.n2i("H_LUA_UNIT_TOKEN_TTG")), --leap的token模式，需导入模型：SDK/hLua/token.mdx
        ability_invulnerable = string.char2id("Avul"), -- 默认无敌技能
        ability_item_slot = string.char2id("AInv"), -- 默认物品栏技能（英雄6格那个）默认全部认定这个技能为物品栏，如有需要自行更改
        ability_locust = string.char2id("Aloc"), -- 蝗虫技能
        ability_break = {}, --眩晕[0.05~0.5]
        ability_swim_un_limit = string.char2id(hslk.n2i("H_LUA_ABILITY_SWIM_UN_LIMIT")),
        ability_invisible = string.char2id(hslk.n2i("H_LUA_ABILITY_INVISIBLE")),
        ability_select_hero = string.char2id(hslk.n2i("H_LUA_ABILITY_SELECT_HERO")),
        texture_alert_circle_exclamation = string.char2id(hslk.n2i("H_LUA_TEXTURE_ALERT_CIRCLE_EXCLAMATION")), --- 警示圈模型!
        texture_alert_circle_x = string.char2id(hslk.n2i("H_LUA_TEXTURE_ALERT_CIRCLE_X")), --- 警示圈模型X
        hero_view_token = string.char2id(hslk.n2i("H_LUA_HERO_VIEW_TOKEN")),
        hero_tavern_token = string.char2id(hslk.n2i("　英雄酒馆　")),
        hero_death_token = string.char2id(hslk.n2i("H_LUA_HERO_DEATH_TOKEN")),
        japi_delay = string.char2id(hslk.n2i("H_LUA_JAPI_DELAY")),
        --
        str_green = {
            add = {},
            sub = {}
        },
        agi_green = {
            add = {},
            sub = {}
        },
        int_green = {
            add = {},
            sub = {}
        },
        attack_green = {
            add = {},
            sub = {}
        },
        defend = {
            add = {},
            sub = {}
        },
        avoid = {
            add = 0,
            sub = 0
        },
        ablis_gradient = {},
    }

    -- 眩晕[0.05-0.5]
    for during = 1, 10, 1 do
        local swDur = during * 0.05
        HL_ID.ability_break[swDur] = string.char2id(hslk.n2i("H_LUA_ABILITY_BREAK_" .. swDur))
    end
    -- 属性系统
    for i = 1, 9 do
        local v = math.floor(10 ^ (i - 1))
        table.insert(HL_ID.ablis_gradient, v)
        HL_ID.str_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_ADD_" .. v))
        HL_ID.str_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_STR_G_SUB_" .. v))
        HL_ID.agi_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_ADD_" .. v))
        HL_ID.agi_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_AGI_G_SUB_" .. v))
        HL_ID.int_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_ADD_" .. v))
        HL_ID.int_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_INT_G_SUB_" .. v))
        HL_ID.attack_green.add[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_ADD_" .. v))
        HL_ID.attack_green.sub[v] = string.char2id(hslk.n2i("H_LUA_A_ACK_G_SUB_" .. v))
        HL_ID.defend.add[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_ADD_" .. v))
        HL_ID.defend.sub[v] = string.char2id(hslk.n2i("H_LUA_A_DEF_SUB_" .. v))
    end
    -- 属性系统 回避
    HL_ID.avoid.add = string.char2id(hslk.n2i("H_LUA_A_AVOID_ADD"))
    HL_ID.avoid.sub = string.char2id(hslk.n2i("H_LUA_A_AVOID_SUB"))
end