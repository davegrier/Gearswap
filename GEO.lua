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
    indi_timer = ''
    indi_duration = 180
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    gear.default.weaponskill_waist = "Windbuffet Belt"

    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic"}
    sets.precast.JA['Life cycle'] = {body="Geomancy Tunic"}

    -- Fast cast sets for spells

    sets.precast.FC = {ammo="Impatiens",
        head="Helios Band",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Vanir Cotehardie",ring1="Prolix Ring",ring2="Weatherspoon Ring"
        back="Lifestream Cape",waist="Witful Belt",legs="Geomancy Pants",feet="Helios Boots"}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {back="Pahtli Cape"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, 
	{hands="Bagua Mitaines",neck="Stoicheion Medal"})

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, 
	{waist="Siegel Sash"})
    
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		head="Espial Cap",neck=gear.ElementalGorget,ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Espial Gambison",hands="Espial Bracers",ring1="Rajas Ring",ring2="Spiral Ring",
        back="Potentia Cape",waist=gear.ElementalBelt,legs="Espial Hose",feet="Espial Socks"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Flash Nova'] = {ammo="Dosis Tathlum",
        head="Helios Band",body="Bagua Tunic",hands="Quauhpilli Gloves",
		legs="Azimuth Tights",feet="Hagondes Sabots",neck="Atzintli Necklace",
		waist="Salire Belt",left_ear="Friomisi Earring",right_ear="Hecate's Earring",
		left_ring="Acumen Ring",right_ring="Fenrir Ring",back="Toro Cape",}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Base fast recast for spells
   -- sets.midcast.FastRecast = {
   --     head="Espial Cap",ear2="Loquacious Earring",
   --     body="Wayfarer Robe",hands="Espial Bracers",ring1="Prolix Ring",
   --     back="Swith Cape",waist="Goading Belt",legs="Helios Spats",feet="Hagondes Sabots"}

    sets.midcast.Geomancy = {
		head="Azimuth Hood",body="Bagua Tunic",hands="Geomancy Mitaines",
        legs="Bagua Pants",feet="Azimuth Gaiters"}
		
    sets.midcast.Geomancy.Indi = {
		head="Azimuth Hood",body="Bagua Tunic",hands="Geomancy Mitaines",
        legs="Bagua Pants",feet="Azimuth Gaiters"}

	sets.midcast['Enfeebling Magic'] = {main="Marin Staff",sub="Wizzan Grip",	
		head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Refraction Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}
		
	sets.midcast['Elemental Magic'] = {main="Marin Staff",sub="Wizzan Grip",
		head="Helios Band",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Barkarole Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}
		
	sets.midcast['Dark Magic'] = {main="Marin Staff",sub="Wizzan Grip",
		head="Bagua Galero",body="Geomancy Tunic",hands="Quauhpilli Gloves",
		legs="Azimuth Tights",feet="Hagondes Sabots",neck="Atzintli Necklace",
		waist="Salire Belt",left_ear="Friomisi Earring",right_ear="Hecate's Earring",
		left_ring="Acumen Ring",right_ring="Fenrir Ring",back="Toro Cape"}
	
	
	sets.midcast['Enhancing Magic'] = {
		head="Helios Band",body="Wayfarer Robe",hands="Helios Gloves",legs="Helios Spats",
		feet="Hagondes Sabots",neck="Noetic Torque",waist="Siegel Sash",left_ear="Merman's Earring",
		right_ear="Merman's Earring",left_ring="Aquasoul Ring",back="Chela Cape"}
	
	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})
	
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring1="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = sets.midcast.Drain
	
    sets.midcast.Cure = {main="Tamaxchi",sub="Genbu's Shield",
	    head="Telchine Cap",ear1="Roundel Earring",ear2="Loquacious Earring",
        body="Telchine Chasuble",hands="Telchine Gloves",ring1="Aquasoul Ring",ring2="Kunaji Ring",
        back="Oretania's Cape",waist="Witful Belt",legs="Telchine Braconi",feet="Telchine Pigaches"}
    
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Protectra = {ring1="Sheltered Ring"}

    sets.midcast.Shellra = {ring1="Sheltered Ring"}


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
    sets.resting = {main="Bolelabunga",sub="Genbu's Shield",
	    head="Nefer Khat +1",neck="Wiglen Gorget",
        body="Azimuth Coat",hands="Bagua Mitaines",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt",legs="Assiduity Pants +1",feet="Chelona Boots"}


    -- Idle sets

    sets.idle = {main="Bolelabunga",sub="Genbu's Shield",
        head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands="Geomancy Mitaines",
    legs="Assiduity Pants +1",
    feet="Bagua Sandals",
    neck="Twilight Torque",
    waist="Witful Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.idle.PDT = {main="Terra's Staff",sub="Wizzan Grip",
		head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands="Geomancy Mitaines",
    legs="Assiduity Pants +1",
    feet="Bagua Sandals",
    neck="Twilight Torque",
    waist="Witful Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = {main="Bolelabunga",sub="Genbu's Shield",
        head="Azimuth Hood",body="Azimuth Coat",hands="Geomancy Mitaines",
		legs="Assiduity Pants +1",feet="Bagua Sandals",neck="Twilight Torque",
		waist="Isa Belt",left_ear="Merman's Earring",right_ear="Merman's Earring",
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
		right_ring="Defending Ring",
		back="Repulse Mantle"}

    sets.idle.PDT.Pet = {main="Bolelabunga",sub="Genbu's Shield",
        head="Azimuth Hood",
		body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		legs="Assiduity Pants +1",
		feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
		neck="Twilight Torque",
		waist="Salire Belt",left_ear="Merman's Earring",right_ear="Merman's Earring",
		left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
		right_ring="Defending Ring",
		back="Repulse Mantle"}

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants"})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants"})
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {legs="Bagua Pants"})
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {legs="Bagua Pants"})

    sets.idle.Town = {main="Bolelabunga",sub="Genbu's Shield",
	    head="Geomancy Galero",body="Councilor's Garb",hands="Bagua Mitaines",
		legs="Assiduity Pants +1",feet="Geomancy Sandals",neck="Twilight Torque",
		waist="Salire Belt",left_ear="Merman's Earring",right_ear="Merman's Earring",
		left_ring="Warp Ring",
		right_ring="Defending Ring",
		back="Repulse Mantle"}

    sets.idle.Weak = {head="Geomancy Galero",body="Azimuth Coat",hands="Bagua Mitaines",
		legs="Assiduity Pants +1",feet="Geomancy Sandals",neck="Twilight Torque",
		waist="Salire Belt",left_ear="Merman's Earring",right_ear="Merman's Earring",
		left_ring="Warp Ring",
		right_ring={ name="Dark Ring", augments={'Magic dmg. taken -5%','Phys. dmg. taken -3%','Spell interruption rate down -3%',}},
		back="Repulse Mantle"}

    -- Defense sets

    sets.defense.PDT = {main="Terra's Staff",sub="Wizzan Grip",
		head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands="Geomancy Mitaines",
    legs="Assiduity Pants +1",
    feet="Bagua Sandals",
    neck="Twilight Torque",
    waist="Witful Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.defense.MDT = {main="Terra's Staff",sub="Wizzan Grip",
		head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands="Geomancy Mitaines",
    legs="Assiduity Pants +1",
    feet="Bagua Sandals",
    neck="Twilight Torque",
    waist="Witful Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.Kiting = {feet="Geomancy Sandals"}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
		head="Espial Cap",neck="Peacock Amulet",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Espial Gambison",hands="Espial Bracers",ring1="Rajas Ring",ring2="Heed Ring",
        back="Potentia Cape",waist="Goading Belt",legs="Espial Hose",feet="Espial Socks"}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 4)
end
