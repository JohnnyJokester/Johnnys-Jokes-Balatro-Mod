-- Sulfur
SMODS.Atlas { 
    key = "johnnyspack_sulfur", 
    path = "johnnyspack_sulfur.png", 
    px = 71, 
    py = 95 
}
SMODS.Consumable {
    key = 'johnnyspack_sulfur',
    set = 'Tarot',
    pos = { x = 0, y = 0 },
    atlas = "johnnyspack_sulfur",
    name = "Sulfur",
    cost = 3,
    config = { max_highlighted = 2, mod_conv = 'm_johnnyspack_bomb_enhancement' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}


-- Impurity
SMODS.Atlas { 
    key = "johnnyspack_impurity", 
    path = "johnnyspack_impurity.png", 
    px = 71, 
    py = 95 
}
SMODS.Consumable {
    key = 'johnnyspack_impurity',
    set = 'Spectral',
    cost = 4,
    pos = { x = 0, y = 0 },
    atlas = "johnnyspack_impurity",
    config = { extra = { max_highlighted = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.johnnyspack_white
        return { vars = { card.ability.extra.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal("johnnyspack_white", nil, true)
                return true
            end
        }))
        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted <= card.ability.extra.max_highlighted and #G.hand.highlighted > 0
    end
}