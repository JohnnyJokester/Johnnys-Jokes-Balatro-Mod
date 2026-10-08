return {
    descriptions = {
        johnnyspack_runes = {
             c_johnnyspack_algiz = {
                name = "Algiz",
                text = {
                    "Fills all {C:attention}empty",
                    "Joker slots with",
                    "{C:attention}random{} Jokers"
                }
            },

            c_johnnyspack_ansuz = {
                name = "Ansuz",
                text = {
                    "Gives a",
                    "{C:attention}#1#" -- Chicot Tag disables next Boss Blind
                }
            },

            c_johnnyspack_berkano = {
                name = "Berkano",
                text = {
                    "Gives {C:attention}random enhancements",
                    "to {C:attention}all{} cards held in hand"
                }
            },

            c_johnnyspack_dagaz = {
                name = "Dagaz",
                text = {
                    "Removes {C:attention}all enhancements",
                    "from cards held in hand",
                    "and gives {C:money}$4{} for each",
                    "enhancement removed"
                }
            },

            c_johnnyspack_ehwaz = {
                name = "Ehwaz",
                text = {
                    "Gives a",
                    "{C:attention}#1#"
                }
            },

            c_johnnyspack_hagalaz = {
                name = "Hagalaz",
                text = {
                    "Destroys {C:attention}every card",
                    "held in hand",
                }
            },

            c_johnnyspack_jera = {
                name = "Jera",
                text = {
                    "Gives 2 {C:dark_edition}Negative",
                    "copies of {C:attention}random",
                    "held consumables",
                    "{s:0.8}Jera excluded"
                }
            },

            c_johnnyspack_perthro = {
                name = "Perthro",
                text = {
                    "Destroys and replaces",
                    "{C:attention}all{} Jokers with random",
                    "{C:green}Uncommon{} or {C:mult}Rare{} Jokers",
                }
            },
        },

        Tarot = {
            c_johnnyspack_sulfur = {
                name = "Sulfur",
                text = {
                    "Enhances up to {C:attention}2",
                    "selected cards into",
                    "{C:attention}Bomb Cards"
                }
            },
        },

        Other = {
            johnnyspack_white_seal = {
                name = "White Seal",
                text = {
                    "Creates a {C:attention}copy",
                    "of this card",
                    "when {C:attention}destroyed{}"
                },
            },
        },

        Spectral = {
            c_johnnyspack_impurity = {
                name = "Purity",
                text = {
                    "Add a {C:dark_edition}White Seal",
                    "to {C:attention}#1#{} selected",
                    "card in your hand"
                }
            }
        },
        
        Enhanced = {
            m_johnnyspack_bomb_enhancement = {
                name = 'Bomb Card',
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:attention}Destroyed{} when",
                    "played in a hand",
                    "or discarded",
                    "{C:attention}#2#{C:inactive} [#3#]{} times"
                }
            },

            m_johnnyspack_spectre_enhancement = {
                name = 'Spectre Card',
                text = {
                    "{C:green}#2# in #3#{} chance",
                    "to {C:attention}retrigger{}"
                }
            }
        },

        Tag = {
            tag_johnnyspack_chicot_tag = {
                name = "Chicot Tag",
                text = {
                    "Disables the next",
                    "{C:attention}Boss Blind{}",
                }
            }
        },

        Joker = {
            j_johnnyspack_timecard = {
                name = "Timecard",
                text = {
                    "{C:attention}9s{} and {C:attention}5s{}",
                    "held in hand",
                    "give {C:mult}+#1#{} Mult"
                }
            },

            j_johnnyspack_airplane_spotter = {
                name = "Spotter",
                text = {
                    "On select blind,",
                    "turn a {C:attention}random card{}",
                    "held in hand",
                    "into a {C:attention}Bomb Card{}", 
                    --[[
                    "and set",
                    "money to {C:money}$0{} if a",
                    "Bomb Card is {C:attention}destroyed{}",
                    ]]--
                }
            },

            j_johnnyspack_crt = {
                name = "CRT",
                text = {
                    "All {C:attention}3s{} and {C:attention}4s",
                    "can be used",
                    "as {C:attention}any suit{}"
                }
            },

            j_johnnyspack_a = {
                name = "A!",
                text = {
                    "Played {C:attention}Aces{} gain",
                    "{C:mult}+#1#{} permanent Mult",
                    "when scored"
                }
            },

            j_johnnyspack_telephone_card = {
                name = "Telephone Card",
                text = {
                    "{C:hearts}Hearts{} give {C:money}$3{} when",
                    "played in a hand",
                    "containing a {C:attention}Straight{}"
                }
            },

            j_johnnyspack_petition = {
                name = "Petition",
                text = {
                    "Gives scored cards",
                    "{C:chips}+#2#{} permanent Chips",
                    "every {C:attention}#1#{} hands played",
                    "{C:inactive}#3#"
                }
            },

            j_johnnyspack_missing_poster = {
                name = "Missing Poster",
                text = {
                    "Gives {C:money}$#1#{} the next",
                    "time {C:tarot}#2#{}",
                    "is used and changes Tarot",
                }
            },

            j_johnnyspack_stickerbombed = {
                name = "Stickerbomb",
                text = {
                    "{C:blue}Blue{}, {C:purple}Purple{} and",
                    "{C:attention}Gold{} seals share",
                    "{C:attention}baseline{} effects"
                }
            },

            j_johnnyspack_autograph = {
                name = "Autographed Copy",
                text = {
                    "This Joker gains {C:red}+#1#{} Mult",
                    "for each card {C:attention}sold{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                }
            },

            j_johnnyspack_webfisher = {
                name = "Sunken Treasure",
                text = {
                    "Has a {C:green}#1# in #2#{} chance to",
                    "gain {C:money}$#3#{} of {C:attention}sell value{}",
                    "when a {C:diamonds}Diamond{} is scored"
                }
            },

            j_johnnyspack_pioneer_plaque = {
                name = "Arecibo Joker",
                text = {
                    "{C:green}#1# in #2#{} chance to create",
                    "a {C:tarot}Tarot{} card when any",
                    "{C:planet}Planet{} card is used",
                    "{C:inactive}(Must have room)",
                }
            },

            j_johnnyspack_landlord = {
                name = "Landlord",
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$1{} if",
                    "played hand contains a {C:attention}Full House{}",
                    "but otherwise decreases by {C:money}$1{}"
                }
            },

            j_johnnyspack_error = {
                name = "ERROR",
                text = {
                    "This Joker {C:attention}randomly{}",
                    "gives between",
                    "{X:mult,C:white}X#1#{} and {X:mult,C:white}X#2#{} Mult"
                }
            },


            j_johnnyspack_residence = {
                name = "The Residence",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if played",
                    "hand contains",
                    "a {C:attention}Full House",
                }
            },

            j_johnnyspack_retrojoker = {
                name = "Retro Joker",
                text = {
                    "Played {C:attention}8s{} have a",
                    "{C:green}#1# in #2#{} chance of giving",
                    "a random {C:attention}Skip Tag{}",
                }
            },

            j_johnnyspack_brutalist = {
                name = "Brutalist",
                text = {
                    "Applies {C:attention}random seals{}",
                    "to played {C:attention}Stone Cards{}",
                    "at the end of the hand"
                }
            },

            j_johnnyspack_soahc = {
                name = "!SOAHC",
                text = {
                    "!soahc ecarbmE",
                }
            },

            j_johnnyspack_13_of_stars = {
                name = "13 of Stars",
                text = {
                    "When round begins,",
                    "add a random {C:attention}#1#",
                    "to your hand",
                }
            },

            j_johnnyspack_caveman = {
                name = "Primal Joker",
                text = {
                    "If {C:attention}played hand{} has a",
                    "scoring {C:clubs}Club{}, retrigger",
                    "all played {C:attention}non-Clubs"
                }
            },

            j_johnnyspack_nero = {
                name = "Nero",
                text = {
                    "Played {C:spades}Spades{} give",
                    "{X:mult,C:white}X#1#{} Mult when scored",
                    "and have a {C:green}#2# in #3#{} chance",
                    "of being destroyed"
                }
            },

            j_johnnyspack_scaredyshroom = {
                name = "Scaredy-shroom",
                text = {
                    "Currently {C:red}+#1#{} Mult",
                    "{C:red}-#2#{} Mult per {C:attention}discard",
                    "used this round"
                }
            },

            j_johnnyspack_graffiti = {
                name = "Graffiti",
                text = {
                    "Currently {C:attention}+#2#{} hand size",
                    "{C:attention}-1{} hand size per {C:attention}discard",
                    "used this round"
                }
            },

            j_johnnyspack_ketchup = {
                name = "Ketchup Packet",
                text = {
                    "Turns all {C:attention}scored{} cards",
                    "in next hand into {C:attention}Mult Cards{}",
                    "and becomes debuffed"
                }
            },

            j_johnnyspack_golden_apple = {
                name = "Golden Apple",
                text = {
                    "Sell this card to turn",
                    "{C:attention}#1#{} random cards held",
                    "in hand into {C:attention}Gold Cards"
                }
            },

            j_johnnyspack_zodiac = {
                name = "Zodiac",
                text = {
                    "Played cards give {X:mult,C:white}X#1#{} Mult",
                    "{X:mult,C:white}-X#2#{} Mult per trigger",
                    "Resets {C:attention}instead{} when",
                    "a {C:attention}6{} is scored"
                }
            },

            j_johnnyspack_bullet_kin = {
                name = "Bullet Kin",
                text = {
                    "{C:attention}Scored{} cards have a",
                    "{C:green}#1# in #2#{} chance",
                    "to be {C:attention}destroyed{}"
                }
            },

            j_johnnyspack_petrol_station = {
                name = "Gas Station",
                text = {
                    "Retrigger each",
                    "played {C:attention}7{} or {C:attention}Ace{}",
                }
            },

            j_johnnyspack_defuse_kit = {
                name = "Defuse Kit",
                text = {
                    "Scored or discarded",
                    "{C:attention}Bomb Cards{} turn",
                    "into {C:attention}Gold Cards{}"
                }
            },

            j_johnnyspack_strawman = {
                name = "Strawman",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{C:red,E:2}Self-destructs{} if a",
                    "{C:attention}#2#{} is not",
                    "played within {C:attention}#3#{} hands",
                    "{C:inactive}(Hand changes when reset)"
                }
            },


            j_johnnyspack_stelmo = {
                name = "St. Elmo's Fire",
                text = {
                    "{C:attention}Destroys{} every {C:attention}13th{}",
                    "{C:attention}discarded{} card",
                    "{C:inactive}(#2# remaining{})"
                }
            },

            j_johnnyspack_neco_arc = {
                name = "Neco Arc",
                text = {
                    "This Joker gives {X:mult,C:white}X#1#{} Mult",
                    "for each {C:attention}level{} between the",
                    "{C:attention}played{} poker hand and your",
                    "{C:attention}highest{} level poker hand"
                    
                }
            },

            j_johnnyspack_conclave = {
                name = "The Tearoom",
                text = {
                    "{C:attention}#1#s{} give {X:mult,C:white}X#5#{} Mult when scored",
                    "{C:attention}#2#s{} give {C:red}+#6#{} Mult when scored",
                    "{C:attention}#3#s{} give {C:chips}+#7#{} Chips when scored",
                    "{C:attention}#4#s{} give {C:money}$#8#{} when scored",
                    "{s:0.8}Effects are shuffled between",
                    "{s:0.8}ranks every round"
                }
            },

            j_johnnyspack_usagi = {
                name = "Usagi",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "create the last",
                    "{C:tarot}Tarot{} or {C:planet}Planet{} card",
                    "used during this run",
                    "at the end of the round"
                }
            },

            j_johnnyspack_magehound = {
                name = "Mage Hound",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "create the {C:planet}Planet{}",
                    "card for final played",
                    "{C:attention}poker hand{} of round",
                    "{C:inactive}(Must have room)",
                }
            },

            j_johnnyspack_fanny = {
                name = "Chiyo",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "{C:attention}decrease{} the rank",
                    "of discarded cards",
                    "{s:0.8}Does not affect 2s"
                }
            },

            j_johnnyspack_that_man = {
                name = "That Man",
                text = {
                    "Gives {C:attention}certain consumables",
                    "depending on the {C:attention}last played",
                    "hand of the round"
                }
            },

            j_johnnyspack_escher = {
                name = "Escher",
                text = {
                    "{C:attention}Retriggers{} each played",
                    "card with {V:1}#1#{} suit",
                    --"{C:attention}2{} additional times",
                    "{s:0.8}Suit changes at end of round",
                }
            },

            j_johnnyspack_bridget = {
                name = "Bridget",
                text = {
                    "This Joker gains {C:red}+#2#{} Mult",
                    "per {C:attention}unique hand{}",
                    "played each {C:attention}Blind{}",
                    "{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)"
                }
            },

            j_johnnyspack_answer = {
                name = "Basilisk",
                text = {
                    "{C:red}Red{} and {C:attention}Gold{} seals",
                    "share {C:attention}baseline{} effects"
                }
            },

            j_johnnyspack_cavediver = {
                name = "Cave Diver",
                text = {
                    "{C:attention}Retrigger{} all played cards if",
                    "you have at least {C:attention}#1#{} Stone",
                    "cards in your full deck",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive})"
                }
            },

            j_johnnyspack_plaid = {
                name = "Plaid Joker",
                text = {
                    "{C:hearts}Hearts{} and {C:clubs}Clubs",
                    "count as the same suit,",
                    "{C:spades}Spades{} and {C:diamonds}Diamonds",
                    "count as the same suit",
                }
            },

            j_johnnyspack_wordsearch = {
                name = "Wordsearch",
                text = {
                    "Gains {C:chips}+#1#{} Chips for",
                    "each {C:attention}letter{} card",
                    "in played hand",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
                }
            },

            j_johnnyspack_dr_faust = {
                name = "Dr. Faust",
                text = {
                    "Creates a random",
                    "{C:dark_edition} Negative{} {C:attention}consumable{} ",
                    "at the {C:attention}end{} of the {C:attention}round{}"
                }
            },

            j_johnnyspack_johnnys_joker = {
                name = "Joker Trick",
                text = {
                    "Destroys {C:attention}all Jokers{} to the right",
                    "of this Joker at the end of round",
                    "Gain a {C:mult}Rare Tag{} after {C:attention}#1# {C:inactive}[#2#]",
                    "Jokers are destroyed this way"
                }
            },

            j_johnnyspack_potemkin = {
                name = "Potemkin",
                text = {
                    "Played {C:attention}7s{} give {C:chips}+7{} Chips",
                    "for each 7 in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                }
            },

            j_johnnyspack_may_ship = {
                name = "May Ship II",
                text = {
                    "{C:attention}Gold Cards{} give {X:mult,C:white}X#1#{} Mult",
                    "while held in hand",
                    "{C:attention}Steel Cards{} give {C:money}$#2#{}",
                    "if held in hand at",
                    "the end of the round"
                }
            },

            j_johnnyspack_nagoriyuki = {
                name = "Nagoriyuki",
                text = {
                    "Decreases level of played",
                    "{C:attention}poker hand{} and gains {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            },

            j_johnnyspack_marriage_certificate = {
                name = "Marriage Certificate",
                text = {
                    "Sell to add {C:dark_edition}Polychrome{}",
                    "and {C:attention}Eternal{} to a {C:attention}valid",
                    "random editionless Joker",
                }
            },

            j_johnnyspack_zappa = {
                name = "Zappa",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "create a random",
                    "{C:dark_edition}Negative{C:attention} Rental{} Joker"
                }
            },

            j_johnnyspack_goldlewis = {
                name = "Goldlewis",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult for",
                    "every {C:money}$#2#{} you have",
                    "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
                }
            },
        }   
    },
    misc = {

            -- do note that when using messages such as: 
            -- message = localize{type='variable',key='a_xmult',vars={current_xmult}},
            -- that the key 'a_xmult' will use provided values from vars={} in that order to replace #1#, #2# etc... in the localization file.
        labels = {
            johnnyspack_white_seal = "White Seal"
        },

        dictionary = {
            b_johnnyspack_runes_cards = "Rune Cards",
            k_johnnyspack_runes = "Rune",
            k_johnnyspack_runes_group = "Runic Pack",

            a_chips="+#1#",
            a_chips_minus="-#1#",
            a_hands="+#1# Hands",
            a_handsize="+#1# Hand Size",
            a_handsize_minus="-#1# Hand Size",
            a_mult="+#1# Mult",
            a_mult_minus="-#1# Mult",
            a_remaining="#1# Remaining",
            a_sold_tally="#1#/#2# Sold",
            a_xmult="X#1# Mult",
            a_xmult_minus="-X#1# Mult",
        }
    }
}