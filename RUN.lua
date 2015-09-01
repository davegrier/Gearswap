-- NOTE: I do not play run, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.
function job_setup()
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'DD', 'Acc', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Regen', 'Refresh')

	select_default_macro_book()
end


function init_gear_sets()
    sets.enmity = {ammo="Aqreqaq Bomblet",
        head="Futhark Bandeau", neck="Twilight Torque", ear1="Friomisi Earring", ear2="Steelflash Earring",
        body="Futhark Coat", hands="Futhark Mitons", ring1="Dark Ring", ring2="Defending Ring",
        back="Evasionist's Cape", waist="Warwolf Belt", legs="Erilaz Leg Guards", feet="Rager Ledelsens +1"}


	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = {body="Runeist coat", legs="Futhark trousers"}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist bottes"}
    sets.precast.JA['Battuta'] = {head="Futhark Bandeau"}
    sets.precast.JA['Liement'] = {body="Futhark Coat"}
    sets.precast.JA['Lunge'] = {ammo="Erlene's Notebook",
        head="Highwing Helm", neck="Stoicheion Medal", ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Rawhide Vest", ring1="Acumen Ring", ring2="Fenrir Ring",
        back="Argochampsa Mantle", waist="Salire Belt", legs="Shneddick Tights +1", feet="Weatherspoon Souliers +1"}
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist Mitons"}
    sets.precast.JA['Rayke'] = {feet="Futhark Bottes"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons"}
    sets.precast.JA['Embolden'] = {}
    sets.precast.JA['Vivacious Pulse'] = {head="Erilaz Galea"}
    sets.precast.JA['One For All'] = {}
    sets.precast.JA['Provoke'] = sets.enmity


	-- Fast cast sets for spells
    sets.precast.FC = {
        head="Runeist bandeau",neck="Orunmila's Torque",ear1="Loquacious Earring",
        body="Taeon Tabard", hands="Thaumas gloves", ring1="Prolix Ring",ring2="Weatherspoon Ring",
        legs="Orvail Pants +1"}
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {head="Erilaz Galea",hands="Runeist Mitons",waist="Siegel Sash", legs="Futhark Trousers"})
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads', back="Mujin Mantle"})
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})


	-- Weaponskill sets
    sets.precast.WS['Resolution'] = {ammo="Aqreqaq Bomblet",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}}, 
		neck="Fotia Gorget", ear1="Bladeborn Earring", ear2="Steelflash Earring",
        body="Taeon Tabard", 
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Epona's Ring", ring2="Rajas Ring",
        back="Buquwik Cape", waist="Fotia Belt", legs="Taeon Tights", feet="Taeon Boots"}
    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'].Normal, 
        {ammo="Honed Tathlum", body="Dread Jupon", hands="Umuthi Gloves", back="Evasionist's Cape", legs="Manibozho Legs"})
    sets.precast.WS['Dimidiation'] = {ammo="Jukukik Feather",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}}, 
		neck="Fotia Gorget", ear1="Bladeborn Earring", ear2="Steelflash Earring",
        body="Taeon Tabard", 
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Epona's Ring", ring2="Rajas Ring",
        back="Bleating Mantle", waist="Windbuffet Belt", legs="Manibozho Brais", feet="Taeon Boots"}
    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'].Normal, 
        {ammo="Honed Tathlum", head="Whirlpool Mask", hands="Buremte Gloves", back="Evasionist's Cape", waist="Thunder Belt"})
    sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {hands="Umuthi Gloves"})
    sets.precast.WS['Herculean Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})


	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
    sets.midcast.FastRecast = {}
    sets.midcast['Enhancing Magic'] = {neck="Colossus's torque", ear1="Andoaa Earring", hands="Runeist mitons", waist="Olympus Sash", legs="Futhark Trousers"}
    sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {head="Futhark Bandeau"})
    sets.midcast['Regen'] = {head="Runeist Bandeau", legs="Futhark Trousers"}
    sets.midcast['Refresh'] = {head="Erilaz Galea"}
    sets.midcast['Stoneskin'] = {waist="Siegel Sash"}
    sets.midcast.Cure = {neck="Colossus's Torque", hands="Buremte Gloves", ring1="Ephedra Ring", feet="Futhark Boots"}

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.idle = {ammo='Inlamvuyeso',
        head="Futhark Bandeau", neck="Twilight Torque", ear1="Ethereal Earring",ear2="Brutal Earring",
        body="Futhark Coat", hands="Runeist Mitons", ring1="Dark Ring", ring2="Defending ring",
        back="Evasionist's Cape", waist="Flume Belt", legs="Crimson Cuisses", feet="Erilaz Greaves"}
    sets.idle.Refresh = set_combine(sets.idle, {body="Runeist Coat", waist="Fucho-no-obi"})
           
	sets.defense.PDT = {}

	sets.defense.MDT = {ammo='Inlamvuyeso',
        head="Erilaz Galea", neck="Twilight Torque", left_ear="Merman's Earring", right_ear="Merman's Earring",
        body="Runeist Coat", hands="Futhark Mitons", ring1="Dark Ring", ring2="Defending ring",
        back="Engulfer Cape +1", waist="Flume Belt", legs="Erilaz Leg Guards", feet="Erilaz Greaves"}

	sets.Kiting = {legs="Crimson Cuisses"}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

    sets.engaged = {ammo='Inlamvuyeso',
        head="Futhark Bandeau", neck="Twilight Torque", ear1="Ethereal Earring",ear2="Brutal Earring",
        body="Futhark Coat", hands="Runeist Mitons", ring1="Dark Ring", ring2="Defending ring",
        back="Evasionist's Cape", waist="Flume Belt", legs="Erilaz Leg Guards", feet="Erilaz Greaves"}
			
    sets.engaged.DD = {ammo="Honed Tathlum",
        head={ name="Taeon Chapeau", augments={'Accuracy+7','"Triple Atk."+2','STR+5 AGI+5',}},
		neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",
		hands={ name="Taeon Gloves", augments={'Accuracy+23','"Triple Atk."+2','Sklchn.dmg.+4%',}},
		ring1="Dark Ring", ring2="Defending ring",
        back="Evasionist's Cape",waist="Flume Belt",legs="Taeon Tights",feet="Taeon Boots"}
		
    sets.engaged.Acc = set_combine(sets.engaged.DD, {ammo="Honed Tathlum", head="Whirlpool Mask",
        neck="Iqabi Necklace", hands="Buremte Gloves", waist="Anguinus Belt",})

	sets.engaged.PDT = {ammo='Inlamvuyeso',
        head="Futhark Bandeau", neck="Twilight Torque", ear1="Ethereal Earring",ear2="Brutal Earring",
        body="Futhark Coat", hands="Runeist Mitons", ring1="Dark Ring", ring2="Defending ring",
        back="Evasionist's Cape", waist="Flume Belt", legs="Erilaz Leg Guards", feet="Erilaz Greaves"}

	sets.engaged.MDT = {ammo='Inlamvuyeso',
        head="Erilaz Galea", neck="Twilight Torque", left_ear="Merman's Earring", right_ear="Merman's Earring",
        body="Runeist Coat", hands="Futhark Mitons", ring1="Dark Ring", ring2="Defending ring",
        back="Engulfer Cape +1", waist="Flume Belt", legs="Erilaz Leg Guards", feet="Erilaz Greaves"}

	sets.engaged.repulse = {back="Repulse Mantle"}

end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({waist=obi})
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 9)
	else
		set_macro_page(1, 9)
	end
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end


------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)





