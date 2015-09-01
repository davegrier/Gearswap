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
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false
    
    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false

	determine_haste_group()

    blue_magic_maps = {}
    
    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.
    
    -- Physical Spells --
    
    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{
        'Bilgestorm','Saurian Slide'
    }

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{
        'Heavy Strike',
    }

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{
        'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Sinker Drill','Spinal Cleave',
        'Uppercut','Vertical Cleave'
    }
        
    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{
        'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone','Disseverment',
        'Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault',
        'Vanity Dive'
    }
        
    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{
        'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'
    }
        
    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{
        'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'
    }

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{
        'Mandibular Bite','Queasyshroom'
    }

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{
        'Ram Charge','Screwdriver','Tourbillion'
    }

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{
        'Bludgeon'
    }

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{
        'Final Sting'
    }

    -- Magical Spells --

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{
        'Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere','Dark Orb','Death Ray',
        'Diffusion Ray','Droning Whirlwind','Embalming Earth','Firespit','Foul Waters',
        'Ice Break','Leafstorm','Maelstrom','Regurgitation','Rending Deluge',
        'Subduction','Tem. Upheaval','Water Bomb','Tenebral Crush','Spectral Floe',
		'Searing Tempest','Palling Salvo'
    }

    blue_magic_maps.MagicalLight = S{
        'Rail Cannon','Retinal Glare','Magic Hammer','Blinding Fulgore'
    }

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{
        'Acrid Stream','Evryone. Grudge','Mind Blast','Scouring Spate'
    }

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{
        'Eyes On Me','Mysterious Light'
    }

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{
        'Thermal Pulse','Entomb'
    }

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{
        'Charged Whisker','Gates of Hades','Anvil Lightning'
    }
            
    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{
        '1000 Needles','Absolute Terror','Actinic Burst','Auroral Drape','Awful Eye',
        'Blank Gaze','Blistering Roar','Blood Drain','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest',
        'Dream Flower','Enervation','Feather Tickle','Filamented Hold','Frightful Roar',
        'Geist Wall','Hecatomb Wave','Infrasonics','Jettatura','Light of Penance',
        'Lowing','Mind Blast','Mortal Ray','MP Drainkiss','Osmosis','Reaving Wind',
        'Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast','Stinking Gas',
        'Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn','Silent Storm'
    }
        
    -- Breath-based spells
    blue_magic_maps.Breath = S{
        'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath',
        'Hecatomb Wave','Magnetite Cloud','Poison Breath','Radiant Breath','Self-Destruct',
        'Thunder Breath','Vapor Spray','Wind Breath'
    }

    -- Stun spells
    blue_magic_maps.Stun = S{
        'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
        'Thunderbolt','Whirl of Rage'
    }
        
    -- Healing spells
    blue_magic_maps.Healing = S{
        'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral','White Wind',
        'Wild Carrot'
    }
    
    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{
        'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body','Plasma Charge',
        'Pyric Bulwark','Reactor Cool',
    }

    -- Other general buffs
    blue_magic_maps.Buff = S{
        'Amplification','Animating Wail','Battery Charge','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell',
        'Memento Mori','Nat. Meditation','Occultation','Orcish Counterstance','Refueling',
        'Regeneration','Saline Coat','Triumphant Roar','Warm-Up','Winds of Promyvion',
        'Zephyr Mantle'
    }
    
    
    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{
        'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve',
        'Crashing Thunder','Droning Whirlwind','Gates of Hades','Harden Shell','Polar Roar',
        'Pyric Bulwark','Thunderbolt','Tourbillion','Uproot'
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Refresh', 'Learning')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Learning')

    gear.macc_hagondes = {name="Hagondes Cuffs", augments={'Phys. dmg. taken -3%','Mag. Acc.+29'}}

    -- Additional local binds
    send_command('bind ^` input /ja "Chain Affinity" <me>')
    send_command('bind !` input /ja "Efflux" <me>')
    send_command('bind @` input /ja "Burst Affinity" <me>')

    update_combat_form()
    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
end


-- Set up gear sets.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    sets.buff['Burst Affinity'] = {feet="Mavi Basmak +2"}
    sets.buff['Chain Affinity'] = {head="Hashishin Kavuk", feet="Assimilator's Charuqs"}
    sets.buff.Convergence = {head="Luhlaza Keffiyeh"}
    sets.buff.Diffusion = {feet="Luhlaza Charuqs"}
    sets.buff.Enchainment = {body="Luhlaza Jubbah +1"}
    sets.buff.Efflux = {legs="Mavi Tayt +2"}

    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = {hands="Mirage Bazubands +2"}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Helios Band",
        body="Hangondes Coat",hands="Helios Gloves",ring1="Spiral Ring",ring2="Valseur's Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Helios Spats",feet="Hagondes Sabots"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
        head="Helios Band",neck="Orunmila's Torque",ear2="Loquacious Earring",
        body="Luhlaza Jubbah +1",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Witful Belt",legs="Helios Spats",feet="Helios Boots"}
        
    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Mavi Mintan +2"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Jukukik Feather",
        head="Taeon Chapeau",neck="Fotia Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Spiral Ring",
        back="Rancorous Mantle",waist="Fotia Belt",legs="Taeon Tights",feet="Taeon Boots"}
    
    sets.precast.WS.acc = set_combine(sets.precast.WS, {hands="Buremte Gloves"})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring1="Aquasoul Ring",feet="Luhlaza Charuqs"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Erlene's Notebook",
        head="Helios Band",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Cornflower Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Helios Band",ear2="Loquacious Earring",
        body="Luhlaza Jubbah +1",hands="Helios Gloves",ring1="Prolix Ring",ring2="Weatherspoon Ring",
        back="Swith Cape",waist="Witful Belt",legs="Helios Spats",feet="Helios Boots"}
        
    sets.midcast['Blue Magic'] = {}
    
    -- Physical Spells --
    
    sets.midcast['Blue Magic'].Physical = {ammo="Jukukik Feather",
        head="Taeon Chapeau",neck="Peacock Amulet",ear1="Steelflash Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Spiral Ring",
        back="Cornflower Cape",waist="Warwolf Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.midcast['Blue Magic'].PhysicalAcc = {ammo="Jukukik Feather",
        head="Taeon Chapeau",neck="Peacock Amulet",ear1="Heartseeker Earring",ear2="Steelflash Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Heed Ring",
        back="Cornflower Cape",waist="Hurch'lan Sash",legs="Mavi Tayt +2",feet="Taeon Boots"}

    sets.midcast['Blue Magic'].PhysicalStr = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Iuitl Vest",hands="Assimilator's Bazubands +1"})

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical,
        {ammo="Jukukik Feather",body="Iuitl Vest",hands="Assimilator's Bazubands +1",
         waist="Chaac Belt",legs="Manibozho Brais"})

    sets.midcast['Blue Magic'].PhysicalVit = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",back="Iximulew Cape"})

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Iuitl Wristbands",ring2="Stormsoul Ring",
         waist="Chaac Belt",feet="Iuitl Gaiters +1"})

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical,
        {ear1="Psystorm Earring",body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",
         ring2="Diamond Ring",back="Toro Cape",feet="Hagondes Sabots"})

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical,
        {ear1="Lifestorm Earring",body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",
         ring2="Aquasoul Ring",back="Refraction Cape"})

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical,
        {body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",back="Refraction Cape",
         waist="Chaac Belt"})

    sets.midcast['Blue Magic'].PhysicalHP = set_combine(sets.midcast['Blue Magic'].Physical)


    -- Magical Spells --
    
    sets.midcast['Blue Magic'].Magical = {ammo="Dosis Tathlum",
        head="Hagondes Hat +1",neck="Stoicheion Medal",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body={ name="Hagondes Coat", augments={'Phys. dmg. taken -3%','"Mag.Atk.Bns."+25',}},
		hands="Helios Gloves",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Cornflower Cape",waist="Salire Belt",legs="Hagondes Pants",feet="Helios Boots"}

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical,
        {body="Vanir Cotehardie",ring1="Sangoma Ring",legs="Iuitl Tights",feet="Mavi Basmak +2"})
    
    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical,
        {ring1="Weatherspoon Ring"})

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical,
        {ring1="Aquasoul Ring"})

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical,
        {ring1="Spiral Ring"})

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical)

    sets.midcast['Blue Magic'].MagicAccuracy = {ammo="Mavi Tathlum",
        head="Helios Band",neck="Mavi Scarf",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Hagondes Coat",hands="Hagondes Cuffs",ring1="Fenrir Ring",ring2="Acumen Ring",
        back="Cornflower Cape",waist="Salire Belt",legs="Mavi Tayt +2",feet="Helios Boots"}

    -- Breath Spells --
    
    sets.midcast['Blue Magic'].Breath = {ammo="Mavi Tathlum",
        head="Luhlaza Keffiyeh",neck="Ej Necklace",ear1="Lifestorm Earring",ear2="Psystorm Earring",
        body="Vanir Cotehardie",hands="Assimilator's Bazubands +1",ring1="K'ayres Ring",ring2="Beeline Ring",
        back="Refraction Cape",legs="Enif Cosciales",feet="Iuitl Gaiters +1"}

    -- Other Types --
    
    sets.midcast['Blue Magic'].Stun = set_combine(sets.midcast['Blue Magic'].MagicAccuracy,
        {waist="Chaac Belt"})
        
    sets.midcast['Blue Magic']['White Wind'] = {
        head="Whirlpool Mask",neck="Lavalier +1",ear1="Bloodgem Earring",ear2="Loquacious Earring",
        body="Chelona Blazer",hands="Weatherspoon Cuffs +1",ring1="Bomb Queen Ring",ring2="Meridian Ring",
        back="Oretania's Cape",waist="Steppe Sash",legs="Praeco Slacks",feet="Serpentes Sabots"}

    sets.midcast['Blue Magic'].Healing = {
        head="Telchine Cap",ear1="Lifestorm Earring",ear2="Loquacious Earring",
        body="Telchine Chasuble",hands="Telchine Gloves",ring1="Aquasoul Ring",ring2="Kunaji Ring",
        back="Oretania's Cape",waist="Chuq'aba Belt",legs="Telchine Braconi",feet="Telchine Pigaches"}

    sets.midcast['Blue Magic'].SkillBasedBuff = {ammo="Mavi Tathlum",
        head="Mirage Keffiyeh",
        body="Magus Jubbah +1",back="Cornflower Cape",
        neck="Mavi Scarf",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}

    sets.midcast['Blue Magic'].Buff = {}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Protectra = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    sets.midcast.Shellra = {ring1="Sheltered Ring"}
    

    
    
    -- Sets to return to when not performing an action.

    -- Gear for learning spells: +skill and AF hands.
    sets.Learning = {ammo="Mavi Tathlum",hands="Magus Bazubands "}
        --head="Luhlaza Keffiyeh",  
        --body="Magus Jubbah +1",hands="Mavi Bazubands",
        --back="Cornflower Cape",legs="Mavi Tayt +2",feet="Luhlaza Charuqs"}


    sets.latent_refresh = {waist="Fucho-no-obi"}

    -- Resting sets
    sets.resting = {
        head="Ocelomeh Headpiece +1",neck="Wiglen Gorget",
        body="Hagondes Coat",hands="Serpentes Cuffs",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt",feet="Chelona Boots +1"}
    
    -- Idle sets
    sets.idle = {    head="Hagondes Hat +1",
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

    sets.idle.PDT = {    head="Hagondes Hat +1",
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

    sets.idle.Town = {ammo="Honed Tathlum",
		head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Councilor's Garb",hands="Taeon Gloves",ring1="Warp Ring",ring2="Defending Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Crimson Cuisses",feet="Taeon Boots"}

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    
    -- Defense sets
    sets.defense.PDT = {    head="Hagondes Hat +1",
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

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.Acc = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.Refresh = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.DW = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.DW.Acc = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.DW.Refresh = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
	
	-- Custom melee group: High Haste (2x March or Haste)
    sets.engaged.DW.HighHaste = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}
	
	sets.engaged.DW.MaxHaste = {ammo="Honed Tathlum",
        head="Taeon Chapeau",neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
        body="Luhlaza Jubbah +1",hands="Taeon Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Bleating Mantle",waist="Windbuffet Belt",legs="Taeon Tights",feet="Taeon Boots"}

    sets.engaged.Learning = set_combine(sets.engaged, sets.Learning)
    sets.engaged.DW.Learning = set_combine(sets.engaged.DW, sets.Learning)


    sets.self_healing = {ring1="Kunaji Ring",ring2="Asklepian Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' and sets.self_healing then
            equip(sets.self_healing)
        end
    end

    -- If in learning mode, keep on gear intended to help with that, regardless of action.
    if state.OffenseMode.value == 'Learning' then
        equip(sets.Learning)
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
    elseif state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
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
--function job_handle_equipping_gear(playerStatus, eventArgs)    
--   if player.equipment.back == 'Mecisto. Mantle' or player.equipment.back == 'Aptitude Mantle' or player.equipment.back == 'Aptitude Mantle +1' or player.equipment.back == 'Nexus Cape' then
--        disable('back')
--    else
--        enable('back')
--    end
--end

function job_update(cmdParams, eventArgs)
    determine_haste_group()
end
-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        set_combine(idleSet, sets.latent_refresh)
    end
    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    -- Check for H2H or single-wielding
    if player.equipment.sub == "Genbu's Shield" or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end
end

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
        classes.CustomMeleeGroups:append('MaxHaste')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
end


