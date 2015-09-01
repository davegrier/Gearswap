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
    state.Buff.Saboteur = buffactive.saboteur or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.HybridMode:options('Normal', 'PhysicalDef', 'MagicalDef')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'MDT')

    gear.default.obi_waist = "Sekhmet Corset"
    
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Vitivation Tabard"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Atrophy Chapeau",ear1="Roundel Earring",
        body="Lethargy Sayon",hands="Helios Gloves",
        back="Refraction Cape",legs="Hagondes Pants",feet="Hagondes Sabots"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {
	    head="Atrophy Chapeau",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Vitivation Tabard",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Witful Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		head="Taeon Chapeau",neck="Fotia Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Spiral Ring",
        back="Rancorous Mantle",waist="Fotia Belt",legs="Taeon Tights",feet="Taeon Boots"}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring2="Aquasoul Ring"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Erlene's Notebook",
        head="Helios Band",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}

    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Atrophy Chapeau",ear2="Loquacious Earring",
        body="Vitivation Tabard",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Goading Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast.Cure = {main="Tamaxchi",sub="Genbu's Shield",
        head="Vitivation Chapeau",neck="Noetic Torque",ear1="Roundel Earring",ear2="Lifestorm Earring",
        body="Vitivation Tabard",hands="Telchine Gloves",ring1="Ephedra Ring",ring2="Sirona's Ring",
        back="Pahtli Cape",waist="Cognizant Belt",legs="Atrophy Tights",feet="Telchine Pigaches"}
        
    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = {main="Tamaxchi",sub="Genbu's Shield",
        head="Telchine Cap",neck="Noetic Torque",ear1="Roundel Earring",ear2="Lifestorm Earring",
        body="Vitivation Tabard",hands="Buremte Gloves",ring1="Kunaji Ring",ring2="Asklepian Ring",
        back="Pahtli Cape",waist="Cognizant Belt",legs="Atrophy Tights",feet="Telchine Pigaches"}

    sets.midcast['Enhancing Magic'] = {
        head="Atrophy Chapeau",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Lethargy Sayon",hands="Atrophy Gloves",ring1="Aquasoul Ring",ring2="Sirona's Ring",
        back="Estoqueur's Cape",waist="Cognizant Belt",legs="Atrophy Tights",feet="Lethargy Houseaux"}

    sets.midcast.Refresh = {legs="Lethargy Fuseau"}

    sets.midcast.Stoneskin = {waist="Siegel Sash"}
    
    sets.midcast['Enfeebling Magic'] = {main="Marin Staff",sub="Achaq Grip",ranged="Aureole",
        head="Lethargy Chappel",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Lethargy Sayon",hands="Lethargy Gantherots",ring1="Fenrir Ring",ring2="Perception Ring",
        back="Ghostfyre Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Vitivation Chapeau"})

    sets.midcast['Slow II'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Vitivation Chapeau"})
    
    sets.midcast['Elemental Magic'] = {main="Marin Staff",sub="Wizzan Grip",ammo="Dosis Tathlum",
        head="Helios Band",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Helios Boots"}
        
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    sets.midcast['Dark Magic'] = {main="Marin Staff",sub="Wizzan Grip",ammo="Dosis Tathlum",
        head="Hagondes Hat +1",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Hagondes Coat",hands="Helios Gloves",ring1="Omega Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Helios Boots"}

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring1="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.midcast.EnhancingDuration = {hands="Atrophy Gloves",back="Estoqueur's Cape",feet="Lethargy Houseaux"}
        
    sets.buff.ComposureOther = {head="Lethargy Chappel",
        body="Lethargy Sayon",hands="Lethargy Gantherots",
        legs="Lethargy Fuseau",feet="Lethargy Houseaux"}

    sets.buff.Saboteur = {hands="Lethargy Gantherots"}
    

    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main="Pluto's Staff",
        head="Vitivation Chapeau",neck="Wiglen Gorget",
        body="Atrophy Tabard",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt",legs="Nares Trews",feet="Chelona Boots +1"}
    

    -- Idle sets
    sets.idle = {    head="Vitivation Chapeau",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Crimson Cuisses",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.idle.Town = {main="Marin Staff",sub="Achaq Grip",ranged="Aureole",
        head="Vitivation Chapeau",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Councilor's Garb",hands="Lethargy Gantherots",ring1="Dark Ring",ring2="Defending Ring",
        back="Ghostfyre Cape",waist="Flume Belt",legs="Crimson Cuisses",feet="Lethargy Houseaux"}
    
    sets.idle.Weak = {main="Marin Staff",sub="Achaq Grip",
        head="Vitivation Chapeau",neck="Weike Torque",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Lethargy Sayon",hands="Lethargy Gantherots",ring1="Dark Ring",ring2="Defending Ring",
        back="Ghostfyre Cape",waist="Flume Belt",legs="Crimson Cuisses",feet="Lethargy Houseaux"}

    sets.idle.PDT = {    head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.idle.MDT = {    head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}
    
    
    -- Defense sets
    sets.defense.PDT = {    head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}

    sets.defense.MDT = {    head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Engulfer Cape +1",}

    sets.Kiting = {legs="Crimson Cuisses"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Jukukik Feather",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Heed Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.Defense = {    head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet={ name="Hagondes Sabots", augments={'Phys. dmg. taken -4%','"Mag.Atk.Bns."+25',}},
    neck="Twilight Torque",
    waist="Flume Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
        equip(sets.buff.Saboteur)
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.EnhancingDuration)
        if buffactive.composure and spell.target.type == 'PLAYER' then
            equip(sets.buff.ComposureOther)
        end
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 8)
    else
        set_macro_page(1, 8)
    end
end

