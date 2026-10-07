-- you can have shared helper functions
function shakecard(self) --visually shake a card
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end

function return_JokerValues() -- not used, just here to demonstrate how you could return values from a joker
    if context.joker_main and context.cardarea == G.jokers then
        return {
            chips = card.ability.extra.chips,       -- these are the 3 possible scoring effects any joker can return.
            mult = card.ability.extra.mult,         -- adds mult (+)
            x_mult = card.ability.extra.x_mult,     -- multiplies existing mult (*)
            card = self,                            -- under which card to show the message
            colour = G.C.CHIPS,                     -- colour of the message, Balatro has some predefined colours, (Balatro/globals.lua)
            message = localize('k_upgrade_ex'),     -- this is the message that will be shown under the card when it triggers.
            extra = { focus = self, message = localize('k_upgrade_ex') }, -- another way to show messages, not sure what's the difference.
        }
    end
end

function randomTarotName(seed)
    cen_pool = {}
    for k, v in pairs(G.P_CENTER_POOLS.Tarot) do
        cen_pool[#cen_pool+1] = v
    end
    return (pseudorandom_element(cen_pool, pseudoseed(seed))).name
end

-- Mod Icon
SMODS.Atlas {
    key = "modicon",
    path = "modicon.png",
    px = 32,
    py = 32
}

-- 13 of Stars
SMODS.Atlas{
    key = "johnnyspack_13_of_stars",
    path = "johnnyspack_13_of_stars.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_13_of_stars",
    config = { extra = {mod_conv = "m_wild"} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_13_of_stars",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.mod_conv]
        return { vars = { localize { type = 'name_text', set = 'Enhanced', key = card.ability.extra.mod_conv } } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.first_hand_drawn then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local cen_pool = {}
                        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            cen_pool[#cen_pool+1] = v
                        end
                        local _card = create_playing_card({
                            front = pseudorandom_element(G.P_CARDS, pseudoseed('13_of_stars')), 
                            center = pseudorandom_element(cen_pool, pseudoseed('13_of_stars'))}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                        _card:set_ability(card.ability.extra.mod_conv)
                        local seal_type = pseudorandom(pseudoseed('13_of_stars'))
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()
                        if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                        return true
                    end}))

                playing_card_joker_effects({true})
            end
        end
    end, 
}

-- A!
SMODS.Atlas{
    key = "johnnyspack_a",
    path = "johnnyspack_a.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_a",
    config = { extra = { perma_mult = 1} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_a",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 14 then
                    context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) +
                        card.ability.extra.perma_mult
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED
                    }
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.perma_mult } }
    end
}

-- Addict

-- Arecibo
SMODS.Atlas{
    key = "johnnyspack_pioneer_plaque",
    path = "johnnyspack_arecibo.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_pioneer_plaque",
    config = { extra = { odds = 2 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_pioneer_plaque",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.using_consumeable then
                if context.consumeable.ability.set == 'Planet' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    if pseudorandom('pioneer'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/card.ability.extra.odds then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'hal')
                                    card:add_to_deck()
                                    G.consumeables:emplace(card)
                                    G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'pioneer')
        return { vars = { numerator, denominator } }
    end
}

-- Ariels

-- Autographed Copy
SMODS.Atlas{
    key = "johnnyspack_autograph",
    path = "johnnyspack_autograph.png",
    px = 71,
    py = 95,
}
SMODS.Joker{
    key = "johnnyspack_autograph",
    config = { extra = { mult = 0, mult_step = 1} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_autograph",
    pixel_size = { w = 71, h = 95 },
    display_size = { w = 71, h = 95 },

    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            if not context.card == card then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_step
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end
        if context.joker_main and context.cardarea == G.jokers then
            return {
                mult = card.ability.extra.mult,
                colour = G.C.RED
            }
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_step, card.ability.extra.mult } }
    end
}

-- Basilisk
SMODS.Atlas{
    key = "johnnyspack_answer",
    path = "johnnyspack_answer.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_answer",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 8,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_answer",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS["Red"]
        info_queue[#info_queue + 1] = G.P_SEALS["Gold"]
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if card.ability.set == "Joker" and not card.debuff then
                if context.repetition then 
                    if not context.other_card.debuff and (context.other_card:get_seal() == "Gold") then -- Red Behaviour
                       return {
                            repetitions = 1,
                            card = card
                       }
                    end
                elseif context.individual and context.cardarea == G.play then
                    if not context.other_card.debuff and (context.other_card:get_seal() == "Red") then -- Gold Behaviour
                        return {
                            dollars = 3,
                            colour = G.C.MONEY,
                            card = context.other_card
                        }
                    end
                end
            end
        end
    end,
}

-- Bridget
SMODS.Atlas{
    key = "johnnyspack_bridget",
    path = "johnnyspack_bridget2.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_bridget",
    config = { extra = {mult = 0, mult_mod = 1} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 6,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_bridget",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod} }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.cardarea == G.jokers and not context.blueprint then
                if context.before then
                    if G.GAME.hands[context.scoring_name] and not (G.GAME.hands[context.scoring_name].played_this_round > 1) then
                        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    end
                end
            end
            if context.joker_main and context.cardarea == G.jokers then
                return {
                    mult = card.ability.extra.mult,
                    colour = G.C.RED
                }
            end
        end
    end,
}

-- Brutalist
SMODS.Atlas{
    key = "johnnyspack_brutalist",
    path = "johnnyspack_brutalist.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_brutalist",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    enhancement_gate = "m_stone",
    atlas = "johnnyspack_brutalist",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_stone"]
        return { vars = {} }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.cardarea == G.jokers and not context.blueprint then
                if context.after then
                    local stones = {}
                    for k, v in ipairs(context.scoring_hand) do
                        if v.ability.effect == "Stone Card" then 
                            stones[#stones+1] = v
                            G.E_MANAGER:add_event(Event({func = function()
                                seal = SMODS.poll_seal({ guaranteed = true, type_key = 'johnnyspack_brutalist' })
                                v:set_seal(seal, nil, true)
                                v:juice_up()
                                return true end
                            }))
                            
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    v:juice_up()
                                    return true
                                end
                            })) 
                        end
                    end
                    if #stones > 0 then 
                        return {
                            message = "Sealed!",
                            card = card
                        }
                    end
                end
            end
        end
    end,
}

-- Bullet Kin
SMODS.Atlas{
    key = "johnnyspack_bullet_kin",
    path = "johnnyspack_bullet_kin.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_bullet_kin",
    config = { extra = {odds = 6, dollars = 1, cards = 0} },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_bullet_kin",

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bullet_kin')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.setting_blind and not card.getting_sliced and not context.blueprint then
                if card.ability.extra.odds == 5 then
                    card.ability.extra.odds = 6
                else
                    local funny = pseudorandom("bullet_kin")
                    if funny < 0.2 then
                        card.ability.extra.odds = 5
                    end
                end
            end
            if context.destroy_card then
                local cardnum = #context.scoring_hand
                for i=1, cardnum do
                    if SMODS.pseudorandom_probability(context.scoring_hand[i], 'bullet_kin', 1, card.ability.extra.odds)
                    and context.destroy_card == context.scoring_hand[i] then
                        card.ability.extra.cards = card.ability.extra.cards + 1
                        return {
                            remove = true
                        }
                    end
                end
            end

            if context.cards_destroyed and not context.blueprint  then
                if card.ability.extra.cards > 0 then
                    card.ability.extra.cards = 0
                    if pseudorandom("bullet_kin") < 0.5 then
                        return {
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('johnnyspack_magnum1', 1, 0.5);return true end })),
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bang!"})
                        }
                    else
                        return {
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('johnnyspack_magnum2', 1, 0.5);return true end })),
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Pow!"})
                        }
                    end
                end
            end

            if context.remove_playing_cards and not context.blueprint then
                if card.ability.extra.cards > 0 then
                    card.ability.extra.cards = 0
                    if pseudorandom("bullet_kin") < 0.5 then
                        return {
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('johnnyspack_magnum1', 1, 0.5);return true end })),
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bang!"})
                        }
                    else
                        return {
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() play_sound('johnnyspack_magnum2', 1, 0.5);return true end })),
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Pow!"})
                        }
                    end
                end
            end
            --  No econ for you buddy
        end
    end,
}

-- Cavediver
SMODS.Atlas{
    key = "johnnyspack_cavediver",
    path = "johnnyspack_cavediver.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_cavediver",
    config = { extra = { stone_req = 7, stone_tally = 0, reps = 1 } },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    enhancement_gate = "m_stone",
    atlas = "johnnyspack_cavediver",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_stone"]
        return { vars = { card.ability.extra.stone_req, (card.ability.extra.stone_tally or 0) } }
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.stone_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_stone then card.ability.extra.stone_tally = card.ability.extra.stone_tally+1 end
            end
        end
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.repetition then
                if context.cardarea == G.play then
                    if card.ability.extra.stone_tally >= card.ability.extra.stone_req then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.reps,
                            card = card
                        }
                    end
                end
            end
        end
    end,
}

-- Chaos

-- Chiyo
SMODS.Atlas{
    key = "fanny",
    path = "johnnyspack_chiyo.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "fanny",
    config = { extra = {odds = 4} },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "fanny",

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'chiyo')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.pre_discard then
                local hit = false
                for i=1, #G.hand.highlighted do
                    if SMODS.pseudorandom_probability(G.hand.highlighted[i], 'chiyo', 1, card.ability.extra.odds) and G.hand.highlighted[i]:get_id() ~= 2 then
                        hit = true
                        local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                G.hand.highlighted[i]:flip()
                                play_sound('card1', percent)
                                G.hand.highlighted[i]:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                        delay(0.2)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                assert(SMODS.modify_rank(G.hand.highlighted[i], -1))
                                return true
                            end
                        }))
                        local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                G.hand.highlighted[i]:flip()
                                play_sound('tarot2', percent, 0.6)
                                G.hand.highlighted[i]:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                    end
                end
                if hit then
                    delay(1)
                end
            end
        end
    end,
}

-- Clown Car

-- CRT
SMODS.Atlas{
    key = "johnnyspack_crt",
    path = "johnnyspack_crt.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_crt",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_crt",

    loc_vars = function(self, info_queue, card)
    end,

    calculate = function(self, card, context)
    end,
}
local smods_johnnyspack_crt_check = SMODS.smeared_check
function SMODS.smeared_check(card, suit, ...)
    if next(SMODS.find_card("j_johnnyspack_crt")) then
        if card:get_id() == 3 or card:get_id() == 4 then
            return true
        end
    end
    return smods_johnnyspack_crt_check(card, suit, ...)
end

-- Defuse Kit
SMODS.Atlas{
    key = "johnnyspack_defuse_kit",
    path = "johnnyspack_defuse_kit.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_defuse_kit",
    config = { extra = {most_played_hand = nil, defuse = false} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    enhancement_gate = "m_johnnyspack_bomb_enhancement",
    atlas = "johnnyspack_defuse_kit",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_johnnyspack_bomb_enhancement"]
        info_queue[#info_queue + 1] = G.P_CENTERS["m_gold"]
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.discard then
                if SMODS.has_enhancement(context.other_card, "m_johnnyspack_bomb_enhancement") == true then
                    --if context.other_card.ability.extra.destroy then 
                        card.ability.extra.defuse = true
                        local percent = 0.85 
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.other_card:flip();play_sound('tarot2', percent, 0.6);context.other_card:juice_up(0.3, 0.3);return true end }))
                        context.other_card:set_ability(G.P_CENTERS.m_gold, nil, true)
                        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.other_card:flip();play_sound('tarot2', percent, 0.6);context.other_card:juice_up(0.3, 0.3);return true end }))
                    --end
                end
                if context.other_card == context.full_hand[#context.full_hand] then
                    card.ability.extra.defuse = false
                    return {
                        message = "Defused!"
                    }
                end
            end
            if context.joker_main and context.cardarea == G.jokers then
                for i = 1, #context.full_hand do
                    if SMODS.has_enhancement(context.full_hand[i], "m_johnnyspack_bomb_enhancement") == true then
                        --if context.full_hand[i].ability.extra.destroy then
                            card.ability.extra.defuse = true
                            local percent = 0.85 
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[i]:flip();play_sound('tarot2', percent, 0.6);context.full_hand[i]:juice_up(0.3, 0.3);return true end }))
                            context.full_hand[i]:set_ability(G.P_CENTERS.m_gold, nil, true)
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[i]:flip();play_sound('tarot2', percent, 0.6);context.full_hand[i]:juice_up(0.3, 0.3);return true end }))
                        --end
                    end
                end
                if card.ability.extra.defuse then
                    card.ability.extra.defuse = false
                    return {
                        message = "Defused!"
                    }
                end
            end
        end
    end,
}

-- Diploma

-- Erica

-- Error
SMODS.Atlas{
    key = "johnnyspack_error",
    path = "johnnyspack_error.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_error",
    config = { extra = {min = 1, max = 1.6} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_error",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.joker_main and context.cardarea == G.jokers then
                return {
                    x_mult = (card.ability.extra.min + pseudorandom("errorjoker") * (card.ability.extra.max - card.ability.extra.min)),
                    colour = G.C.RED
                }
            end
        end
    end,
}

-- Escher
SMODS.Atlas{
    key = "johnnyspack_escher",
    path = "johnnyspack_escher.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_escher",
    config = { extra = {rep = 1, suit = ''} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_escher",

    loc_vars = function(self, info_queue, card)
        return { vars = {localize(card.ability.extra.suit, 'suits_singular'), colours = {G.C.SUITS[card.ability.extra.suit]}} }
    end,

    set_ability = function(self, card, center, initial, delay_sprites)
        local old_suit = card.ability.extra.suit
        card.ability.extra.suit = nil

        while not card.ability.extra.suit do
            card.ability.extra.suit = pseudorandom_element({ 'Diamonds', 'Spades', 'Hearts', 'Clubs' }, pseudoseed('escher'))
            if card.ability.extra.suit == old_suit then card.ability.extra.suit = nil end
        end
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.repetition then
                if context.cardarea == G.play then
                    if context.other_card:is_suit(card.ability.extra.suit) and not context.other_card.debuff then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.rep,
                            card = card
                        }
                    end
                end
            end
        end
        if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
            card.ability.extra.suit = pseudorandom_element({ 'Diamonds', 'Spades', 'Hearts', 'Clubs' }, pseudoseed('escher'))
        end
    end,
}

-- Gas Station
SMODS.Atlas{
    key = "johnnyspack_petrol_station",
    path = "johnnyspack_gas_station.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_petrol_station",
    config = { extra = {reps = 1} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_petrol_station",

    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.repetition then
                if context.cardarea == G.play then
                    if context.other_card:get_id() == 7 or context.other_card:get_id() == 14 then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.reps,
                            card = card
                        }
                    end 
                end
            end
        end
    end,
}

-- Golden Apple
SMODS.Atlas{
    key = "johnnyspack_golden_apple",
    path = "johnnyspack_golden_apple.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_golden_apple",
    config = { extra = { gold_cards = 3 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=false,
    eternal_compat=false,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_golden_apple",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_gold"]
        return { vars = { card.ability.extra.gold_cards } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.selling_self then
                local temp_hand = {}
                local gold_cards = {}
                for k, v in ipairs(G.hand.cards) do temp_hand[#temp_hand+1] = v end
                table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
                pseudoshuffle(temp_hand, pseudoseed('golden_apple'))

                for i = 1, card.ability.extra.gold_cards do
                    gold_cards[#gold_cards+1] = temp_hand[i]
                end

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function() 
                        for i=#gold_cards, 1, -1 do
                            local percent = 0.85 + (i-0.999)/(#gold_cards-0.998)*0.3
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() gold_cards[i]:flip();play_sound('tarot2', percent, 0.6);gold_cards[i]:juice_up(0.3, 0.3);return true end }))
                            gold_cards[i]:set_ability(G.P_CENTERS.m_gold, nil, true)
                            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() gold_cards[i]:flip();play_sound('tarot2', percent, 0.6);gold_cards[i]:juice_up(0.3, 0.3);return true end }))
                        end
                        return true end }))
            end
        end
    end,
}

-- Graffiti
SMODS.Atlas{
    key = "johnnyspack_graffiti",
    path = "johnnyspack_graffiti.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_graffiti",
    config = { h_size = 2, extra = {max_h_size = 2} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_graffiti",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max_h_size, card.ability.h_size } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.discard then
                if not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then 
                    local prev_size = card.ability.h_size
                    card.ability.h_size = math.max(0, card.ability.h_size - 1)
                    if card.ability.h_size ~= prev_size then 
                        G.hand:change_size(-1)
                        return {
                            message = localize{type='variable',key='a_handsize_minus',vars={1}},
                            colour = G.C.FILTER
                        }
                    end
                end
            elseif context.end_of_round and not context.blueprint  then
                if card.ability.h_size ~= card.ability.extra.max_h_size then
                    G.hand:change_size(card.ability.extra.max_h_size - card.ability.h_size)
                    card.ability.h_size = card.ability.extra.max_h_size
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
            end
        end
    end,
}

-- Joker Trick
SMODS.Atlas{
    key = "johnnyspack_johnnys_joker",
    path = "johnnyspack_johnnys_joker.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = "johnnyspack_johnnys_joker",
    config = { extra = {counter_max = 4, counter_remaining = 4} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_johnnys_joker",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_rare', set = 'Tag' }
        return { vars = { card.ability.extra.counter_max, card.ability.extra.counter_remaining } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.end_of_round and not card.getting_sliced then
                local my_pos = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i; break end
                end
                local i = my_pos + 1
                while i <= #G.jokers.cards do
                    if my_pos and G.jokers.cards[i] and not card.getting_sliced and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
                        local sliced_card = G.jokers.cards[i]
                        sliced_card.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            play_sound('slice1', 0.96+math.random()*0.08)
                        return true end }))

                        card.ability.extra.counter_remaining = card.ability.extra.counter_remaining - 1
                        if card.ability.extra.counter_remaining <= 0 then
                            add_tag(Tag('tag_rare'))
                            card.ability.extra.counter_remaining = card.ability.extra.counter_max
                        end
                    else
                        i = i+1
                    end
                end
            end
        end
    end,
}

-- Ketchup Packet
SMODS.Atlas{
    key = "johnnyspack_ketchup",
    path = "johnnyspack_ketchup.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_ketchup",
    config = { extra = {}},
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 2,
    blueprint_compat=false,
    eternal_compat=false,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_ketchup",
    pixel_size = {x = 60, y = 95},
    display_size = {x = 60, y = 95},

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_mult"]
        return { vars = { } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.cardarea == G.jokers then
                if context.before and G.GAME.current_round.hands_played == 0 then
                    for k, v in ipairs(context.scoring_hand) do
                        v:set_ability(G.P_CENTERS.m_mult, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        })) 
                    end
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
                        play_sound("johnnyspack_splat_DR", 1, 0.7)
                        return true end }))
                    return {
                        message = "Splat!",
                        colour = G.C.RED
                    }
                elseif context.after then
                    SMODS.debuff_card(card, true, "splatsplatsplat")
                end
            end
        end
    end,
}

-- Landlord
SMODS.Atlas{
    key = "johnnyspack_landlord",
    path = "johnnyspack_landlord.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_landlord",
    config = { extra = { payout = 4 } },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_landlord",

    calc_dollar_bonus = function(self, card)
        if card.debuff then return end
        return card.ability.extra.payout
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.joker_main and context.cardarea == G.jokers then
                if next(context.poker_hands['Full House']) then
                    card.ability.extra.payout = card.ability.extra.payout + 1
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MONEY
                    }
                else
                    if card.ability.extra.payout > 0 then
                        card.ability.extra.payout = card.ability.extra.payout - 1
                        return {
                            message = "-"..localize('$').."1",
                            colour = G.C.MONEY
                        }
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.payout} }
    end
}

-- Marriage Certificate
SMODS.Atlas{
    key = "johnnyspack_marriage_certificate",
    path = "johnnyspack_marriage_cert.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_marriage_certificate",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=false,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_marriage_certificate",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.selling_self and not context.blueprint then
                local eligible_marriage_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.set == 'Joker' and (not G.jokers.cards[i].edition) and G.jokers.cards[i].config.center.eternal_compat then
                        table.insert(eligible_marriage_jokers, G.jokers.cards[i])
                    end
                end

                if #eligible_marriage_jokers > 0 then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                                local over = false
                                local eligible_card = pseudorandom_element((true and eligible_marriage_jokers), pseudoseed(true and "marriage"))
                                eligible_card:set_edition({polychrome = true}, true)
                                eligible_card.ability.perishable = nil
                                eligible_card:add_sticker("eternal", true)
                            return true end }))
                    return {
                            message = 'Married!'
                        }
                else
                    return{
                        message = "No Partner!"
                    }
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Other', key = 'eternal', vars = {}}
        return { vars = {} }
    end
}

-- Missing Poster
SMODS.Atlas{
    key = "johnnyspack_missing_poster",
    path = "johnnyspack_missing_poster.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_missing_poster",
    config = { extra = { dollars = 13, tarot = "The Fool"} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=false,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_missing_poster",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.using_consumeable then
                if (context.consumeable.ability.set == "Tarot") then
                    if context.consumeable.ability.name == card.ability.extra.tarot then
                        if not context.blueprint then
                            card.ability.extra.tarot = randomTarotName("missing_poster")
                        end
                        return {
                            dollars = card.ability.extra.dollars,
                            card = card
                        }
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.dollars, card.ability.extra.tarot} }
    end
}

-- Nagoriyuki

-- Neco Arc

-- Nero

-- Petition
SMODS.Atlas{
    key = "johnnyspack_petition",
    path = "johnnyspack_petition.png",
    px = 71,
    py = 100
}
SMODS.Joker{
    key = "johnnyspack_petition",
    config = { extra = {max_hands = 6, hands = 6, chips = 30} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_petition",
    pixel_size = { w = 71, h = 100 },
    display_size = { w = 71, h = 100 },

    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                card.ability.extra.max_hands, 
                card.ability.extra.chips,
                (card.ability.extra.hands == 1 and 'Active!' or tostring(card.ability.extra.hands-1)..' remaining')
            }
        }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.before then 
                card.ability.extra.hands = card.ability.extra.hands - 1
                if card.ability.extra.hands <= 0 then
                    for k, v in ipairs(context.scoring_hand) do
                        v.ability.perma_bonus = (v.ability.perma_bonus or 0) + card.ability.extra.chips
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        })) 
                    end
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS
                    }
                end
            end
            if context.after and card.ability.extra.hands <= 0 then
                card.ability.extra.hands = card.ability.extra.max_hands
            end
            if context.joker_main then
                if card.ability.extra.hands == 1 then
                    local eval = function(card) return card.ability.extra.hands == 1 and not G.RESET_JIGGLES end
                    juice_card_until(card, eval, true)
                end
            end
        end
    end,
}

-- Plaid Joker
SMODS.Atlas{
    key = "johnnyspack_plaid",
    path = "johnnyspack_plaid.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_plaid",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_plaid",

    loc_vars = function(self, info_queue, card)
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            
        end
    end,
}
local smods_johnnyspack_plaid_check = SMODS.smeared_check
function SMODS.smeared_check(card, suit, ...)
    if next(SMODS.find_card("j_johnnyspack_plaid")) then
        if ((card.base.suit == 'Hearts' or card.base.suit == 'Clubs') and (suit == 'Hearts' or suit == 'Clubs')) then
            return true
        elseif (card.base.suit == 'Spades' or card.base.suit == 'Diamonds') and (suit == 'Spades' or suit == 'Diamonds') then
            return true
        end
    end
    return smods_johnnyspack_plaid_check(card, suit, ...)
end

-- Potemkin
SMODS.Atlas{
    key = "johnnyspack_potemkin",
    path = "johnnyspack_potemkin.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_potemkin",
    config = { extra = { extra = {seven_tally = 0, total_chips_bonus = 0} } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_potemkin",

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.seven_tally = 0
            for k, v in pairs(G.playing_cards) do
                if v:get_id() == 7 then card.ability.extra.seven_tally = card.ability.extra.seven_tally+1 end
            end
            card.ability.extra.total_chips_bonus = 7*card.ability.extra.seven_tally
        end
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and context.cardarea == G.play then
            if context.individual and context.other_card:get_id() == 7 then
                return {
                    chips = card.ability.extra.total_chips_bonus
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.total_chips_bonus or 28} }
    end

    --[[if context.pre_discard and G.GAME.current_round.discards_used <= 8 then
                for i=1, #G.hand.highlighted do
                    local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
                end
                for i=1, #G.hand.highlighted do
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                        local card = G.hand.highlighted[i]
                        local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                        local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
                        if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                        elseif rank_suffix == 10 then rank_suffix = 'T'
                        elseif rank_suffix == 11 then rank_suffix = 'J'
                        elseif rank_suffix == 12 then rank_suffix = 'Q'
                        elseif rank_suffix == 13 then rank_suffix = 'K'
                        elseif rank_suffix == 14 then rank_suffix = 'A'
                        end
                        card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                    return true end }))
                end 
                for i=1, #G.hand.highlighted do
                    local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
                end
                delay(0.5)
            end]]--
}

-- Primal Joker
SMODS.Atlas{
    key = "johnnyspack_caveman",
    path = "johnnyspack_caveman.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_caveman",
    config = { extra = { } },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_caveman",

    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
             if context.repetition then
                if context.cardarea == G.play then
                    local cardnum = #context.scoring_hand
                    local club_count = 0
                    for i=1, cardnum do
                        if context.scoring_hand[i]:is_suit("Clubs") and not context.scoring_hand[i].debuff then
                            club_count = club_count + 1
                        end
                    end
                    if club_count >= 1 and (not context.other_card:is_suit("Clubs")) then
                        return{
                            message = localize('k_again_ex'),
                            repetitions = 1,
                            card = card
                        }
                    end
                end
            end
        end
    end,
}

-- Residence
SMODS.Atlas{
    key = "johnnyspack_residence",
    path = "johnnyspack_residence.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_residence",
    config = { extra = {x_mult = 4} },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_residence",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.joker_main and context.cardarea == G.jokers then
                if next(context.poker_hands['Full House']) then
                    return {
                        x_mult = card.ability.extra.x_mult,
                        colour = G.C.RED
                    }
                end
            end
        end
    end,
}

-- Retro
SMODS.Atlas{
    key = "johnnyspack_retrojoker",
    path = "johnnyspack_retrojoker.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_retrojoker",
    config = { extra = {odds = 8} },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_retrojoker",

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'retrojoker')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.individual and context.cardarea == G.play then
                if (context.other_card:get_id() == 8) and SMODS.pseudorandom_probability(context.other_card, 'retrojoker', 1, card.ability.extra.odds) then
                    local tag_pool = get_current_pool('Tag')
                    local selected_tag = pseudorandom_element(tag_pool, 'retrojoker')
                    local it = 1
                    while selected_tag == 'UNAVAILABLE' do
                        it = it + 1
                        selected_tag = pseudorandom_element(tag_pool, 'retrojoker'..it)
                    end
                    return {
                        message = "Tag!",
                        func = function() -- This is for timing purposes, it runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    add_tag(Tag(selected_tag, false, 'Small'))
                                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end,

    
}

-- Robo-Ky

-- Rug

-- Scaredyshroom

-- Spotter
SMODS.Atlas{
    key = "johnnyspack_airplane_spotter",
    path = "johnnyspack_airplane_spotter.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_airplane_spotter",
    config = { extra = { bombs = 1, reset = false } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_airplane_spotter",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["m_johnnyspack_bomb_enhancement"]
        return { vars = { card.ability.extra.bombs, } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.first_hand_drawn then
                for i = 1, card.ability.extra.bombs do
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local _card = create_playing_card({
                            front = pseudorandom_element(G.P_CARDS, pseudoseed('13_of_stars')), 
                            center = pseudorandom_element({}, pseudoseed('13_of_stars'))}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                            _card:set_ability("m_johnnyspack_bomb_enhancement")
                            G.GAME.blind:debuff_card(_card)
                            G.hand:sort()
                            if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                            return true
                        end}))
                end
                playing_card_joker_effects({true})
            end

            if context.remove_playing_cards and not context.blueprint then
                for k, v in pairs(context.removed) do
                    if SMODS.has_enhancement(v, "m_johnnyspack_bomb_enhancement") then
                        if G.GAME.dollars ~= 0 then
                            ease_dollars(-G.GAME.dollars, true)
                        end
                    end
                end
            end

            if context.after and not context.blueprint then 
                if card.ability.extra.reset then
                    card.ability.extra.reset = false
                    if G.GAME.dollars ~= 0 then
                        ease_dollars(-G.GAME.dollars, true)
                    end
                end
            end
        end
    end,
}

-- St. Elmo's Fire

-- Stickerbomb
SMODS.Atlas{
    key = "johnnyspack_stickerbombed",
    path = "johnnyspack_stickerbombed.png",
    px = 71,
    py = 95,
}
SMODS.Joker{
    key = "johnnyspack_stickerbombed",
    config = { extra = { } },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_stickerbombed",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if card.ability.set == "Joker" and not card.debuff then
                if context.discard and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then -- Purple Behaviour
                    if not context.other_card.debuff and (context.other_card:get_seal() == "Blue" or context.other_card:get_seal() == "Gold") then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = function()
                                SMODS.add_card({ set = 'Tarot' })
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
                    end
                elseif context.end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    if context.individual and not context.other_card.debuff and (context.other_card:get_seal() == "Purple" or context.other_card:get_seal() == "Gold") then
                        if context.end_of_round and context.cardarea == G.hand and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = function()
                                    if G.GAME.last_hand_played then
                                        local _planet = nil
                                        for _, planet_center in pairs(G.P_CENTER_POOLS.Planet) do
                                            if planet_center.config.hand_type == G.GAME.last_hand_played then
                                                _planet = planet_center.key
                                            end
                                        end
                                        if _planet then
                                            SMODS.add_card({ key = _planet })
                                        end
                                        G.GAME.consumeable_buffer = 0
                                    end
                                    return true
                                end
                            }))
                            return { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet }
                        end
                    end
                elseif context.individual and context.cardarea == G.play then
                    if not context.other_card.debuff and (context.other_card:get_seal() == "Purple" or context.other_card:get_seal() == "Blue") then -- Gold Behaviour
                        return {
                            dollars = 3,
                            colour = G.C.MONEY,
                            card = context.other_card
                        }
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS["Blue"]
        info_queue[#info_queue + 1] = G.P_SEALS["Purple"]
        info_queue[#info_queue + 1] = G.P_SEALS["Gold"]
        return { vars = { } }
    end
}

-- Strawman
SMODS.Atlas{
    key = "johnnyspack_strawman",
    path = "johnnyspack_strawman.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_strawman",
    config = { extra = { x_mult = 2, hand_type = nil, countdown = 3, max_countdown = 3} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=false,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_strawman",

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.x_mult, localize( card.ability.extra.hand_type, "poker_hands"), card.ability.extra.countdown} }
    end,

    set_ability = function(self, card, center, initial, delay_sprites)
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then _poker_hands[#_poker_hands+1] = k end
        end
        local old_hand = card.ability.extra.hand_type
        card.ability.extra.hand_type = nil

        while not card.ability.extra.hand_type do
            card.ability.extra.hand_type = pseudorandom_element(_poker_hands, pseudoseed('strawman'))
            if card.ability.extra.hand_type == old_hand then card.ability.extra.hand_type = nil end
        end
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint then
            if context.before then 
                if context.scoring_name == card.ability.extra.hand_type then
                     local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then _poker_hands[#_poker_hands+1] = k end
                    end
                    local old_hand = card.ability.extra.hand_type
                    card.ability.extra.hand_type = nil

                    while not card.ability.extra.hand_type do
                        card.ability.extra.hand_type = pseudorandom_element(_poker_hands, pseudoseed('strawman'))
                        if card.ability.extra.hand_type == old_hand then card.ability.extra.hand_type = nil end
                    end
                    card.ability.extra.countdown = card.ability.extra.max_countdown
                    return {
                        message = localize('k_reset')
                    }
                else
                    card.ability.extra.countdown = card.ability.extra.countdown - 1
                    if card.ability.extra.countdown > 0 then
                        return {
                            message = "Tick"
                        }
                    else
                        local var_random = pseudorandom("strawman")
                        if var_random < 0.5 then
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, blockable = false,
                            func = function()
                                return true; end}))
                            play_sound('johnnyspack_strawman_im_going_to', 1, 1)
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 6, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:start_dissolve()
                                    card = nil
                                return true; end}))
                        else
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, blockable = false,
                            func = function()
                                return true; end}))
                            play_sound('johnnyspack_strawman_nobody_loves_me', 1, 1)
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 5, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:start_dissolve()
                                    card = nil
                                return true; end}))
                        end
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 5, blockable = false,
                            func = function()
                                play_sound("johnnyspack_strawman_explode", 1, 1)
                                return true; end}))
                        
                    end
                end
            end
            if context.joker_main and context.cardarea == G.jokers and card.ability.extra.countdown > 0 then
                return {
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
    end,
}

-- Sunken Treasure
SMODS.Atlas{
    key = "johnnyspack_webfisher",
    path = "johnnyspack_webfisher.png",
    px = 71,
    py = 95
}
SMODS.Atlas{
    key = "johnnyspack_webfisher_treasure",
    path = "johnnyspack_webfisher_treasure.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_webfisher",
    config = { extra = { odds = 4, money_step = 3} },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat=false,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    atlas = "johnnyspack_webfisher",
    soul_atlas = "johnnyspack_webfisher_treasure",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 0 },

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and not context.blueprint and context.cardarea == G.play then
            if context.individual and context.other_card:is_suit("Diamonds") and 
            SMODS.pseudorandom_probability(context.full_hand[i], 'treasure', 1, card.ability.extra.odds) then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.money_step
                if card.set_cost then
                    card:set_cost()
                    return {
                        extra = {focus = card, message = localize('k_val_up')},
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'treasure')
        return { vars = { numerator, denominator, card.ability.extra.money_step } }
    end
}

-- Tearoom

-- Telephone Card
SMODS.Atlas{
    key = "johnnyspack_telephone_card",
    path = "johnnyspack_telephone_card.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_telephone_card",
    config = { extra = {dollars = 3, type = "Straight"} },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_telephone_card",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.type } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
            if next(context.poker_hands[card.ability.extra.type]) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return { 
                    dollars = card.ability.extra.dollars,
                    func = function() 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end,
}

-- Timecard
SMODS.Atlas{
    key = "timecard",
    path = "johnnyspack_timecard.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "timecard",
    config = { extra = { mult = 8 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "timecard",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.individual and context.cardarea == G.hand and not context.end_of_round and (context.other_card:get_id() == 5 or context.other_card:get_id() == 9) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    end,
}

-- Usagi

-- Window Math

-- Wordsearch
SMODS.Atlas{
    key = "johnnyspack_wordsearch",
    path = "johnnyspack_wordsearch.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_wordsearch",
    config = { extra = { chips = 0, chips_mod = 2, letters = 0 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 5,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_wordsearch",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.before and not context.blueprint then
                card.ability.extra.letters = 0
                --[[
                local ace = false
                local king = false
                local queen = false
                local jack = false
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() == 14 and not ace then 
                        card.ability.extra.letters = card.ability.extra.letters + 1
                        ace = true
                    elseif v:get_id() == 13 and not king then 
                        card.ability.extra.letters = card.ability.extra.letters + 1
                        king = true
                    elseif v:get_id() == 12 and not queen then 
                        card.ability.extra.letters = card.ability.extra.letters + 1
                        queen = true
                    elseif v:get_id() == 11 and not jack then
                        card.ability.extra.letters = card.ability.extra.letters + 1
                        jack = true
                    end
                end
                ]]--
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() == 14 or
                    v:get_id() == 13 or
                    v:get_id() == 12 or
                    v:get_id() == 11 then
                        if not v.debuff then
                            card.ability.extra.letters = card.ability.extra.letters + 1
                        end
                    end
                end

                if card.ability.extra.letters > 0 then
                    card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chips_mod * card.ability.extra.letters)
                    return {
                        message = localize("k_upgrade_ex"),
                        colour = G.C.CHIPS,
                        card = card
                    }
                end
            end
            if context.joker_main and context.cardarea == G.jokers then
                return {
                    chips = card.ability.extra.chips,
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
    end,
}

-- Zappa
SMODS.Atlas{
    key = "johnnyspack_zappa",
    path = "johnnyspack_zappa.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_zappa",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 9,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    effect=nil,
    soul_pos=nil,
    atlas = "johnnyspack_zappa",

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff then
            if context.setting_blind and not card.getting_sliced then
                local card = create_card('Joker', G.jokers, false, nil, nil, nil, nil, true and "zappa")
                card:set_edition({negative = true}, true)
                card:set_rental(true)
                card:add_to_deck()
                G.jokers:emplace(card)
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end
}

-- Zodiac
SMODS.Atlas{
    key = "johnnyspack_zodiac",
    path = "johnnyspack_zodiac.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "johnnyspack_zodiac",
    config = { extra = { xmult = 1.7, xmult_step = 0.1, max_xmult = 1.7, clicked = false } },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 9,
    blueprint_compat=true,
    eternal_compat=true,
    unlocked=true,
    discovered=true,
    atlas = "johnnyspack_zodiac",
    pos = { x = 0, y = 0 },

    calculate = function(self, card, context)
        if card.ability.set == "Joker" and not card.debuff and context.cardarea == G.play then
            if context.individual and not context.other_card.debuff then 
                if context.other_card:get_id() == 6 then
                    if not context.blueprint then
                        card.ability.extra.xmult = card.ability.extra.max_xmult
                        card.ability.extra.clicked = false
                        return {
                            message = "Reloaded!",
                            card = card
                        }
                    end
                else
                    if card.ability.extra.xmult > 1.1 then
                        if not context.blueprint then
                            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_step
                            return {
                                xmult = card.ability.extra.xmult,
                                card = card
                            }
                        else
                            return {
                                xmult = card.ability.extra.xmult-0.1,
                                card = card
                            }
                        end
                    elseif not card.ability.extra.clicked and not context.blueprint then
                        card.ability.extra.clicked = true
                        return {
                            message = "Click...",
                            card = card
                        }
                    end
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { (card.ability.extra.xmult - 0.1), card.ability.extra.xmult_step } }
    end
}
