-- Bomb Enhancement
function johnnyspack_bomb_tick_increment(card)
    card.ability.extra.tick = card.ability.extra.tick + 1
    if card.ability.extra.tick >= card.ability.extra.tick_max-1 then
        card.ability.extra.shake = card.ability.extra.shake + 1
        if card.ability.extra.tick >= card.ability.extra.tick_max then
            card.ability.extra.destroy = true
        end
    end
end
function johnnyspack_bomb_shake_check(card)
    if card.ability.extra.shake == 1 or card.ability.extra.destroy then
        local eval = function(card) return card.ability.extra.tick == card.ability.extra.tick_max-1 and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
    end
end
local johnnyspack_bomb_remove_check = Card.start_dissolve
function Card.start_dissolve(card, ...)
    if SMODS.has_enhancement(card, "m_johnnyspack_bomb_enhancement") then
        local percent = 0.85 + pseudorandom("johnnys_pack_bomb_sound") * 0.3
        play_sound("johnnyspack_strawman_explode", percent, 0.25)
    end
    return johnnyspack_bomb_remove_check(card,  ...)
end
SMODS.Atlas { 
    key = "johnnyspack_bomb_enhancement", 
    path = "johnnyspack_bomb_enhancement.png", 
    px = 71, 
    py = 95 
}
SMODS.Enhancement {
	key = 'johnnyspack_bomb_enhancement',
	atlas = 'johnnyspack_bomb_enhancement',
	config = { extra = { x_mult = 1.5, destroy = false, tick_max = 3, tick = 0, play_tick = false, shake = 0} },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult, card.ability.extra.tick_max, card.ability.extra.tick } }
	end,

    calculate = function(self, card, context)
        if not card.debuff then
            if context.main_scoring and context.cardarea == G.play then
               return {
                    x_mult = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
            if context.hand_drawn or context.other_drawn then
                for i = 0, #context.hand_drawn do
                    if context.hand_drawn[i] == card then
                        johnnyspack_bomb_shake_check(card)
                    end
                end
            end
            if context.before then
                if context.cardarea == G.play then
                    johnnyspack_bomb_tick_increment(card)
                    johnnyspack_bomb_shake_check(card)
                end
            end
            if context.discard and context.other_card == card then
                johnnyspack_bomb_tick_increment(card)
                if card.ability.extra.destroy then
                    return {
                        remove = true
                    }
                else
                    return {
                        message = "Tick"
                    }
                end
            end
            if context.after then
                if context.cardarea == G.play then
                    johnnyspack_bomb_shake_check(card)
                    return {
                        message = "Tick"
                    }
                end
            end 
            if context.destroy_card and context.destroy_card == card then
                if card.ability.extra.destroy then
                    card.ability.extra.destroy = false
                    card.ability.extra.tick = 0
                    return {
                        remove = true
                    }
                end
            end
        end
    end
}


-- Impure Seal
SMODS.Atlas {
    key = "johnnyspack_white_seal",
    path = "johnnyspack_white_seal.png", 
    px = 71, 
    py = 95 
}
SMODS.Seal {
    key = "johnnyspack_white",
    atlas = "johnnyspack_white_seal",
    config = { extra = { copies = 1 } },
    badge_colour = G.C.WHITE,
    discovered = true,
    badge_colour = HEX('4f6367'),

    calculate = function(self, card, context)
        if context.remove_playing_cards and context.cardarea ~= G.play then
            for i = 1, #context.removed do
                if context.removed[i] == card then
                    return { 
                        func = function() -- This is for timing purposes, it runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local _first_dissolve = nil
                                    local new_cards = {}
                                    for i = 1, self.config.extra.copies do
                                        local _card = SMODS.copy_card(card)
                                        _card:start_materialize(nil, _first_dissolve)
                                        _first_dissolve = true
                                        new_cards[#new_cards + 1] = _card
                                    end
                                    SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end

        if context.remove_playing_cards and context.cardarea == G.play then
            for i = 1, #context.removed do
                if context.removed[i] == card then
                    local card_copied = SMODS.copy_card(card, { area = G.hand })
                    card_copied.states.visible = nil

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_copied:start_materialize()
                            return true
                        end
                    }))
                    return {
                        func = function() -- This is for timing purposes, it runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.copies } }
    end
}