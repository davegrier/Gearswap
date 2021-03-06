-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    gs c step
        Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.
    gs c step t
        Uses the currently configured step on the target, but forces use of <t>.
    
    
    Configuration commands:
    
    gs c cycle mainstep
        Cycles through the available steps to use as the primary step when using one of the above commands.
        
    gs c cycle altstep
        Cycles through the available steps to use for alternating with the configured main step.
        
    gs c toggle usealtstep
        Toggles whether or not to use an alternate step.
        
    gs c toggle selectsteptarget
        Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
    state.SkillchainPending = M(false, 'Skillchain Pending')

    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "Caudata Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}

    sets.precast.JA['Trance'] = {head="Horos Tiara"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Etoile Tiara",ear1="Roundel Earring",
        body="Maxixi Casaque",hands="Buremte Gloves",ring1="Valseur's Ring",ring2="Kunaji Ring",ear1="Roundel Earring",
        back="Toetapper Mantle",waist="Chuq'aba Belt",legs="Nahtirah Trousers",feet="Maxixi Toe Shoes"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Samba = {head="Dancer's Tiara"}

    sets.precast.Jig = {legs="Etoile Tights", feet="Maxixi Toe Shoes"}

    sets.precast.Step = {hands="Dancer's Bangles",feet="Horos Toe Shoes +1",waist="Chaac Belt"}
    sets.precast.Step['Feather Step'] = {feet="Charis Shoes +2"}

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {ear1="Psystorm Earring",ear2="Lifestorm Earring",
        body="Etoile Casaque",hands="Buremte Gloves",ring2="Sangoma Ring",
        waist="Chaac Belt",legs="Iuitl Tights",feet="Iuitl Gaiters +1"} -- magic accuracy
    sets.precast.Flourish1['Desperate Flourish'] = {ammo="Charis Feather",
        head="Whirlpool Mask",neck="Peacock Amulet",
        body="Etoile Casaque",hands="Charis Bangles +2",ear1="Kemas Earring",ring1="Valseur's Ring",
        back="Toetapper Mantle",waist="Hurch'lan Sash",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"} -- acc gear

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {hands="Charis Bangles +2"}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {body="Maculele Casaque"}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Impatiens",head="Haruspex Hat",neck="Orunmila's Torque",ear2="Loquacious Earring",hands="Thaumas Gloves",ring1="Prolix Ring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Qirmiz Tathlum",
        head="Espial Cap",neck="Fotia Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Espial Gambison",hands="Espial Bracers",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Fotia Belt",legs="Espial Hose",feet="Espial Socks"}
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {ammo="Honed Tathlum", back="Toetapper Mantle"})
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {neck="Houyi's Gorget",
        hands="Iuitl Wristbands",ring1="Stormsoul Ring",
        waist="Caudata Belt",legs="Nahtirah Trousers"})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {ammo="Honed Tathlum", back="Toetapper Mantle"})
    sets.precast.WS['Exenterator'].Fodder = set_combine(sets.precast.WS['Exenterator'], {waist=gear.ElementalBelt})

    sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {hands="Iuitl Wristbands"})
    sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS.Acc, {hands="Iuitl Wristbands"})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {ammo="Charis Feather",head="Uk'uxkaj Cap",neck="Rancor Collar"})
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {ammo="Honed Tathlum", back="Toetapper Mantle"})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {ammo="Charis Feather"})
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {ammo="Honed Tathlum", back="Toetapper Mantle"})

    sets.precast.WS['Aeolian Edge'] = {    
		head="Wayfarer Circlet",body="Wayfarer Robe",hands="Wayfarer Cuffs",legs="Shned. Tights +1",
		feet="Wayfarer Clogs",neck="Stoicheion Medal",waist="Salire Belt",left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",left_ring="Fenrir Ring",right_ring="Acumen Ring",back="Toro Cape",}
    
    sets.precast.Skillchain = {hands="Charis Bangles +2"}
    
    
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Felistris Mask",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",
        legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}
        
    -- Specific spells
    sets.midcast.Utsusemi = {
        head="Felistris Mask",neck="Ej Necklace",ear2="Loquacious Earring",
        body="Iuitl Vest",hands="Iuitl Wristbands",ring1="Beeline Ring",
        back="Toetapper Mantle",legs="Kaabnax Trousers",feet="Iuitl Gaiters +1"}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    sets.ExtraRegen = {head="Ocelomeh Headpiece +1"}
    

    -- Idle sets

    sets.idle = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Warp Ring",ring2="Echad Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Tandava Crackows"}

    sets.idle.Town = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Warp Ring",ring2="Echad Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Tandava Crackows"}
    
    sets.idle.Weak = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Warp Ring",ring2="Echad Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Tandava Crackows"}
    
    -- Defense sets

    sets.defense.Evasion = {ammo="Honed Tathlum",
    head="Shned. Chapeau +1",
    body="Espial Gambison",
    hands="Taeon Gloves",
    legs="Taeon Tights",
    feet="Espial Socks",
    neck="Twilight Torque",
    waist="Twilight Belt",
    left_ear="Musical Earring",
    right_ear="Velocity Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle"
}

    sets.defense.PDT = {ammo="Honed Tathlum",
    head="Shned. Chapeau +1",
    body="Espial Gambison",
    hands="Melaco Mittens",
    legs="Espial Hose",
    feet="Espial Socks",
    neck="Twilight Torque",
    waist="Twilight Belt",
    left_ear="Musical Earring",
    right_ear="Velocity Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
    back="Repulse Mantle"
}

    sets.defense.MDT = {ammo="Honed Tathlum",
    head="Wayfarer Circlet",
    body="Wayfarer Robe",
    hands="Wayfarer Cuffs",
    legs="Wayfarer Slops",
    feet="Wayfarer Clogs",
    neck="Twilight Torque",
    waist="Twilight Belt",
    left_ear="Merman's Earring",
    right_ear="Merman's Earring",
    left_ring={ name="Dark Ring", augments={'Magic dmg. taken -6%','Breath dmg. taken -3%','Phys. dmg. taken -5%',}},
    right_ring="Defending Ring",
	back="Lamia Mantle +1",
}

    sets.Kiting = {feet="Tandava Crackows"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}

    sets.engaged.Fodder = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Fodder.Evasion = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Taeon Tights",feet="Horos Toe Shoes +1"}

    sets.engaged.Acc = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Evasion = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.PDT = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.Evasion = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.PDT = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}

    -- Custom melee group: High Haste (2x March or Haste)
    sets.engaged.HighHaste = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Patentia Sash",legs="Maculele Tights",feet="Horos Toe Shoes +1"}

    sets.engaged.Fodder.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Fodder.Evasion.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}

    sets.engaged.Acc.HighHaste = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Evasion.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.Evasion.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.PDT.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.PDT.HighHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}


    -- Custom melee group: Max Haste (2x March + Haste)
    sets.engaged.MaxHaste = {ammo="Honed Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}

    -- Getting Marches+Haste from Trust NPCs, doesn't cap delay.
    sets.engaged.Fodder.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Fodder.Evasion.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}

    sets.engaged.Acc.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Evasion.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.Evasion.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.PDT.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}
    sets.engaged.Acc.PDT.MaxHaste = {ammo="Qirmiz Tathlum",
        head="Maculele Tiara",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Maculele Casaque",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Toetapper Mantle",waist="Windbuffet Belt",legs="Maculele Tights",feet="Horos Toe Shoes +1"}



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Saber Dance'] = {legs="Horos Tights"}
    sets.buff['Climactic Flourish'] = {head="Maculele Tiara"}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
        if state.SkillchainPending.value == true then
            equip(sets.precast.Skillchain)
        end
    end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Wild Flourish" then
            state.SkillchainPending:set()
            send_command('wait 5;gs c unset SkillchainPending')
        elseif spell.type:lower() == "weaponskill" then
            state.SkillchainPending:toggle()
            send_command('wait 6;gs c unset SkillchainPending')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)    
    if player.equipment.back == 'Mecisto. Mantle' or player.equipment.back == 'Aptitude Mantle' or player.equipment.back == 'Aptitude Mantle +1' or player.equipment.back == 'Nexus Cape' then
        disable('back')
    else
        enable('back')
    end
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end


function customize_idle_set(idleSet)
    if player.hpp < 80 and not areas.Cities:contains(world.area) then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
    
    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end
        
        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end
    
    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end        
        
        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

    -- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
    -- High haste buffs:
    -- 2x Marches + Haste
    -- 2x Marches + Haste Samba
    -- 1x March + Haste + Haste Samba
    -- Embrava + any other haste buff
    
    -- For max haste, we probably need to consider dropping all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste/March + Haste Samba
    -- 2x March + Haste + Haste Samba

    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function auto_presto(spell)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
        
        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('@input /ja "Presto" <me>')
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 2)
    else
        set_macro_page(1, 2)
    end
end
