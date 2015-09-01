-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false

    state.FootworkWS = M(false, 'Footwork on WS')

    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'SomeAcc', 'Acc', 'Fodder')
    state.WeaponskillMode:options('Normal', 'SomeAcc', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'PDT', 'Counter')
    state.PhysicalDefenseMode:options('PDT', 'HP')

    update_combat_form()
    update_melee_groups()

    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Hesychast's Hose +1"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1"}
    sets.precast.JA['Dodge'] = {feet="Temple Gaiters +1"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown +1"}
    sets.precast.JA['Counterstance'] = {feet="Melee Gaiters"}
    sets.precast.JA['Footwork'] = {feet="Tantra Gaiters +2"}
    sets.precast.JA['Formless Strikes'] = {body="Hesychast's Cyclas"}
    sets.precast.JA['Mantra'] = {feet="Hesychast's Gaiters +1"}

    sets.precast.JA['Chi Blast'] = {
        head="Melee Crown +2",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",
        back="Tuilha Cape",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}

    sets.precast.JA['Chakra'] = {ammo="Iron Gobbet",
        head="Felistris Mask",
        body="Anchorite's Cyclas +1",hands="Melee Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Qaaxo Tights",feet="Thurandaut Boots +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Felistris Mask",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",ring1="Spiral Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Qaaxo Tights",feet="Otronif Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}


    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",neck="Orunmila's Torque",head="Haruspex hat",ear2="Loquacious Earring",
	ring1="Prolix Ring",ring2="Weatherspoon Ring",hands="Thaumas Gloves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Tantra Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Fotia Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Rancorous Mantle",waist="Fotia Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.precast.WSAcc = {ammo="Honed Tathlum",body="Manibozho Jerkin",back="Letalis Mantle",feet="Qaaxo Leggings"}
    sets.precast.WSMod = {ammo="Tantra Tathlum",head="Felistris Mask",legs="Hesychast's Hose +1",feet="Daihanshi Habaki"}
    sets.precast.MaxTP = {ear1="Bladeborn Earring",ear2="Steelflash Earring"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, sets.precast.WSAcc)
    sets.precast.WS.Mod = set_combine(sets.precast.WS, sets.precast.WSMod)

    -- Specific weaponskill sets.
    
    -- legs={name="Quiahuiz Trousers", augments={'Phys. dmg. taken -2%','Magic dmg. taken -2%','STR+8'}}}

    sets.precast.WS['Raging Fists']    = set_combine(sets.precast.WS, {})
    sets.precast.WS['Howling Fist']    = set_combine(sets.precast.WS, {legs="Manibozho Brais",feet="Daihanshi Habaki"})
    sets.precast.WS['Asuran Fists']    = set_combine(sets.precast.WS, {
        ear1="Bladeborn Earring",ear2="Moonshade Earring",ring2="Spiral Ring",back="Buquwik Cape"})
    sets.precast.WS["Ascetic's Fury"]  = set_combine(sets.precast.WS, {
        ammo="Tantra Tathlum",ring1="Spiral Ring",back="Buquwik Cape",feet="Qaaxo Leggings"})
    sets.precast.WS["Victory Smite"]   = set_combine(sets.precast.WS, {})
    sets.precast.WS['Shijin Spiral']   = set_combine(sets.precast.WS, {ear1="Bladeborn Earring",ear2="Steelflash Earring",
        legs="Manibozho Brais",feet="Daihanshi Habaki"})
    sets.precast.WS['Dragon Kick']     = set_combine(sets.precast.WS, {feet="Daihanshi Habaki"})
    sets.precast.WS['Tornado Kick']    = set_combine(sets.precast.WS, {ammo="Tantra Tathlum",ring1="Spiral Ring"})
    sets.precast.WS['Spinning Attack'] = set_combine(sets.precast.WS, {
        head="Felistris Mask",ear1="Bladeborn Earring",ear2="Steelflash Earring"})

    sets.precast.WS["Raging Fists"].Acc = set_combine(sets.precast.WS["Raging Fists"], sets.precast.WSAcc)
    sets.precast.WS["Howling Fist"].Acc = set_combine(sets.precast.WS["Howling Fist"], sets.precast.WSAcc)
    sets.precast.WS["Asuran Fists"].Acc = set_combine(sets.precast.WS["Asuran Fists"], sets.precast.WSAcc)
    sets.precast.WS["Ascetic's Fury"].Acc = set_combine(sets.precast.WS["Ascetic's Fury"], sets.precast.WSAcc)
    sets.precast.WS["Victory Smite"].Acc = set_combine(sets.precast.WS["Victory Smite"], sets.precast.WSAcc)
    sets.precast.WS["Shijin Spiral"].Acc = set_combine(sets.precast.WS["Shijin Spiral"], sets.precast.WSAcc)
    sets.precast.WS["Dragon Kick"].Acc = set_combine(sets.precast.WS["Dragon Kick"], sets.precast.WSAcc)
    sets.precast.WS["Tornado Kick"].Acc = set_combine(sets.precast.WS["Tornado Kick"], sets.precast.WSAcc)

    sets.precast.WS["Raging Fists"].Mod = set_combine(sets.precast.WS["Raging Fists"], sets.precast.WSMod)
    sets.precast.WS["Howling Fist"].Mod = set_combine(sets.precast.WS["Howling Fist"], sets.precast.WSMod)
    sets.precast.WS["Asuran Fists"].Mod = set_combine(sets.precast.WS["Asuran Fists"], sets.precast.WSMod)
    sets.precast.WS["Ascetic's Fury"].Mod = set_combine(sets.precast.WS["Ascetic's Fury"], sets.precast.WSMod)
    sets.precast.WS["Victory Smite"].Mod = set_combine(sets.precast.WS["Victory Smite"], sets.precast.WSMod)
    sets.precast.WS["Shijin Spiral"].Mod = set_combine(sets.precast.WS["Shijin Spiral"], sets.precast.WSMod)
    sets.precast.WS["Dragon Kick"].Mod = set_combine(sets.precast.WS["Dragon Kick"], sets.precast.WSMod)
    sets.precast.WS["Tornado Kick"].Mod = set_combine(sets.precast.WS["Tornado Kick"], sets.precast.WSMod)


    sets.precast.WS['Cataclysm'] = {
        head="Wayfarer Circlet",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Wayfarer Robe",hands="Otronif Gloves",ring1="Acumen Ring",ring2="Fenrir's Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Nahtirah Trousers",feet="Qaaxo Leggings"}
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Whirlpool Mask",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Thaumas Gloves",
        waist="Black Belt",feet="Otronif Boots +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Whirlpool Mask",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Thaumas Gloves",
        waist="Black Belt",legs="Qaaxo Tights",feet="Otronif Boots +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        body="Hesychast's Cyclas",ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets
    sets.idle = {ammo="Tantra Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",left_ear="Merman's Earring",right_ear="Merman's Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Herald's Gaiters"}

    sets.idle.Town = {ammo="Tantra Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",left_ear="Merman's Earring",right_ear="Merman's Earring",
        body="Councilor's Garb",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Herald's Gaiters"}
    
    sets.idle.Weak = {ammo="Tantra Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",left_ear="Merman's Earring",right_ear="Merman's Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Herald's Gaiters"}
    
    -- Defense sets
    sets.defense.PDT = {
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.defense.HP = {ammo="Iron Gobbet",
        head="Uk'uxkaj Cap",neck="Lavalier +1",ear1="Brutal Earring",ear2="Bloodgem Earring",
        body="Hesychast's Cyclas",hands="Hesychast's Gloves +1",ring1="K'ayres Ring",ring2="Meridian Ring",
        back="Shadow Mantle",waist="Black Belt",legs="Hesychast's Hose +1",feet="Hesychast's Gaiters +1"}

    sets.defense.MDT = {
	    head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee sets
    sets.engaged = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.SomeAcc = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Acc = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Mod = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    -- Defensive melee hybrid sets
    sets.engaged.PDT = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.SomeAcc.PDT = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Acc.PDT = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Counter = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Acc.Counter = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
        right_ring="Defending Ring",
        back="Repulse Mantle",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}


    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged)
    sets.engaged.HF.Impetus = set_combine(sets.engaged, {body="Tantra Cyclas +2"})
    sets.engaged.Acc.HF = set_combine(sets.engaged.Acc)
    sets.engaged.Acc.HF.Impetus = set_combine(sets.engaged.Acc, {body="Tantra Cyclas +2"})
    sets.engaged.Counter.HF = set_combine(sets.engaged.Counter)
    sets.engaged.Counter.HF.Impetus = set_combine(sets.engaged.Counter, {body="Tantra Cyclas +2"})
    sets.engaged.Acc.Counter.HF = set_combine(sets.engaged.Acc.Counter)
    sets.engaged.Acc.Counter.HF.Impetus = set_combine(sets.engaged.Acc.Counter, {body="Tantra Cyclas +2"})


    -- Footwork combat form
    sets.engaged.Footwork = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
    sets.engaged.Footwork.Acc = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Rajas Ring",ring2="Epona's Ring",
        back="Anchoret Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
        
    -- Quick sets for post-precast adjustments, listed here so that the gear can be Validated.
    sets.impetus_body = {body="Tantra Cyclas +2"}
    sets.footwork_kick_feet = {feet="Anchorite's Gaiters +1"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Tantra to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
        
        -- Replace Moonshade Earring if we're at cap TP
        if player.tp == 3000 then
            equip(sets.precast.MaxTP)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
        send_command('cancel Footwork')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    
    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if player.hpp < 75 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    update_melee_groups()
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end
    
    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 10)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 10)
    else
        set_macro_page(1, 10)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _,target in pairs(action.targets) do
                if target.id == player.id then
                    for _,action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end
        
        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
    
end

