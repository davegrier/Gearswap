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

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant', 'Proc')
    state.IdleMode:options('Normal', 'PDT')
    
    state.MagicBurst = M(false, 'Magic Burst')

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder',
        'Stone II', 'Water II', 'Aero II', 'Fire II', 'Blizzard II', 'Thunder II',
        'Stone III', 'Water III', 'Aero III', 'Fire III', 'Blizzard III', 'Thunder III',
        'Stonega', 'Waterga', 'Aeroga', 'Firaga', 'Blizzaga', 'Thundaga',
        'Stonega II', 'Waterga II', 'Aeroga II', 'Firaga II', 'Blizzaga II', 'Thundaga II'}

    gear.macc_hagondes = {name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22'}}
    
    -- Additional local binds
    send_command('bind ^` input /ma Stun <t>')
    send_command('bind @` gs c activate MagicBurst')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind @`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    ---- Precast Sets ----
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {feet="Goetia Sabots +2"}

    sets.precast.JA.Manafont = {body="Sorcerer's Coat +2"}
    
    -- equip to maximize HP (for Tarus) and minimize MP loss before using convert
    sets.precast.JA.Convert = {}


    -- Fast cast sets for spells

    sets.precast.FC = {
		head="Helios Band",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Luhlaza Jubbah +1",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Witful Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {neck="Stoicheion Medal"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {body="Heka's Kalasiris", back="Pahtli Cape"})

    sets.precast.FC.Curaga = sets.precast.FC.Cure

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Hagondes Hat +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Hagondes Coat",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="Icesoul Ring",
        back="Refraction Cape",waist="Cognition Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Vidohunir'] = {ammo="Dosis Tathlum",
        head="Hagondes Hat +1",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Barkarole Earring",
        body="Hagondes Coat",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Thunder Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}
    
    
    ---- Midcast Sets ----

    sets.midcast.FastRecast = {
        head="Helios Band",ear2="Loquacious Earring",
        body="Luhlaza Jubbah +1",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Goading Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast.Cure = {
        head="Telchine Cap",ear1="Roundel Earring",ear2="Loquacious Earring",
        body="Telchine Chasuble",hands="Telchine Gloves",ring1="Aquasoul Ring",ring2="Kunaji Ring",
        back="Oretania's Cape",waist="Witful Belt",legs="Telchine Braconi",feet="Telchine Pigaches"}

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast['Enhancing Magic'] = {
        neck="Colossus's Torque",
        body="Manasa Chasuble",hands="Ayao's Gages",
        legs="Portent Pants"}
    
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast['Enfeebling Magic'] = {
        head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Bane Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}
        
    sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']

    sets.midcast['Dark Magic'] = {
        head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Bane Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast.Drain = {ammo="Erlene's Notebook",
        head="Helios Band",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Barkarole Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}
    
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = {
        head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Bane Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast.BardSong = {
        head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Bane Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}


    -- Elemental Magic sets
    
    sets.midcast['Elemental Magic'] = {ammo="Erlene's Notebook",
        head="Hagondes Hat",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Barkarole Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Toro Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Helios Boots"}

    sets.midcast['Elemental Magic'].Resistant = {
        head="Helios Band",neck="Noetic Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
		hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
		ring1="Fenrir Ring",ring2="Sangoma Ring",
        back="Bane Cape",waist="Salire Belt",legs="Helios Spats",feet="Helios Boots"}

    sets.midcast['Elemental Magic'].HighTierNuke = set_combine(sets.midcast['Elemental Magic'], {sub="Wizzan Grip"})
    sets.midcast['Elemental Magic'].HighTierNuke.Resistant = set_combine(sets.midcast['Elemental Magic'], {sub="Wizzan Grip"})


    -- Minimal damage gear for procs.
    sets.midcast['Elemental Magic'].Proc = {main="Earth Staff", sub="Mephitis Grip",ammo="Impatiens",
        head="Nahtirah Hat",neck="Twilight Torque",ear1="Bloodgem Earring",ear2="Loquacious Earring",
        body="Manasa Chasuble",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Nares Trews",feet="Chelona Boots +1"}


    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main="Chatoyant Staff",ammo="Clarus Stone",
        head="Nefer Khat +1",neck="Grandiose Chain",
        body="Heka's Kalasiris",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt",legs="Nares Trews",feet="Serpentes Sabots"}
    

    -- Idle sets
    
    -- Normal refresh idle set
    sets.idle = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Assiduity Pants +1",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}

    -- Idle mode that keeps PDT gear on, but doesn't prevent normal gear swaps for precast/etc.
    sets.idle.PDT = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Assiduity Pants +1",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}

    -- Idle mode scopes:
    -- Idle mode when weak.
    sets.idle.Weak = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Assiduity Pants +1",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}
    
    -- Town gear.
    sets.idle.Town = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Assiduity Pants +1",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}
        
    -- Defense sets

    sets.defense.PDT = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}

    sets.defense.MDT = {
	head="Hagondes Hat +1",
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Salire Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle",}

    sets.Kiting = {feet="Herald's Gaiters"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    
    sets.buff['Mana Wall'] = {feet="Goetia Sabots +2"}

    sets.magic_burst = {neck="Mizukage-no-Kubikazari"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
        head={ name="Hagondes Hat +1", augments={'Phys. dmg. taken -4%','"Fast Cast"+3',}},
    body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','Mag. Acc.+25',}},
    hands={ name="Hagondes Cuffs", augments={'Phys. dmg. taken -4%','Mag. Acc.+22',}},
    legs="Hagondes Pants",
    feet="Herald's Gaiters",
    neck="Twilight Torque",
    waist="Goading Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Repulse Mantle",}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' or spellMap == 'Curaga' then
        gear.default.obi_waist = "Goading Belt"
    elseif spell.skill == 'Elemental Magic' then
        gear.default.obi_waist = "Sekhmet Corset"
        if state.CastingMode.value == 'Proc' then
            classes.CustomClass = 'Proc'
        end
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
        equip(sets.magic_burst)
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    -- Lock feet after using Mana Wall.
    if not spell.interrupted then
        if spell.english == 'Mana Wall' then
            enable('feet')
            equip(sets.buff['Mana Wall'])
            disable('feet')
        elseif spell.skill == 'Elemental Magic' then
            state.MagicBurst:reset()
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Unlock feet when Mana Wall buff is lost.
    if buff == "Mana Wall" and not gain then
        enable('feet')
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
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

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        --[[ No real need to differentiate with current gear.
        if lowTierNukes:contains(spell.english) then
            return 'LowTierNuke'
        else
            return 'HighTierNuke'
        end
        --]]
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
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
    set_macro_page(1, 15)
end
