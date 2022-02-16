return 
{
	ACTIONFAIL =
	{
		REPAIR =
        {
            WRONGPIECE = "That is clearly the incorrect piece.",
        },
        BUILD =
        {
            MOUNTED = "In this elevated position, I can't reach the ground.",
            HASPET = "One domestic creature is enough for me.",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "I don't want to annoy him.",
			GENERIC = "I can't shave that!",
			NOBITS = "Poor naked one..",
		},
		STORE =
		{
			GENERIC = "Not enough stores left.",
			NOTALLOWED = "This is not for here.",
			INUSE = "Someone's using.",
            NOTMASTERCHEF = "Someone really good at cooking would use this.",
		},
		CONSTRUCT =
        {
            INUSE = "Someone's already using this.",
            NOTALLOWED = "That was erroneous.",
            EMPTY = "I need something to build with first.",
            MISMATCH = "Those are the wrong plans.",
        },
		RUMMAGE =
        {   
            GENERIC = "I've other things on my mind currently.",
            INUSE = "Be sure to sort by color and weight.",   
			NOTMASTERCHEF = "Someone really good at cooking would use this.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "Does this mean something guilty?",
        	KLAUS = "I don't think it's safe to open this.",
			QUAGMIRE_WRONGKEY = "I'll just have to find another key.",
        },
		ACTIVATE = 
		{
			LOCKED_GATE = "The gate has sealed.",
		},
		COOK =
        {
            GENERIC = "I don't think I can't cook right now.",
            INUSE = "It makes me more hungry!",
            TOOFAR = "It is not within my reach.",
        },
		GIVE =
        {
            GENERIC = "What am I doing right now",
            DEAD = "Oh, it's dead.",
            SLEEPING = "It appears to be sleeping.",
            BUSY = "Seems busy.",
            ABIGAILHEART = "The spirit is already bound.",
            GHOSTHEART = "I'll not be meddling in that business.",
            NOTGEM = "Don't be silly.",
            WRONGGEM = "This gemstone's properties are incorrect for my purposes.",
            NOTSTAFF = "This is not the staff I seek.",
            MUSHROOMFARM_NEEDSSHROOM = "It needs a fresh mushroom.",
            MUSHROOMFARM_NEEDSLOG = "It needs a log, imbued with magical properties.",
            SLOTFULL = "You don't have any inventory slots left.",
            FOODFULL = "I'll be around when you're ready for seconds.",
            NOTDISH = "Oh sure you don't eat this.",
            DUPLICATE = "You've already taken note of this recipe.",
            NOTSCULPTABLE = "No one ever sculpt like that.",
			NOTATRIUMKEY = "It doesn't even look like.",
            CANTSHADOWREVIVE = "Conditions are not right.",
            WRONGSHADOWFORM = "The skeletal anatomy is incorrect.",
            NOMOON = "It needs a lunar influence.",
			PIGKINGGAME_MESSY = "I need to clean up first.",
			PIGKINGGAME_DANGER = "It's too dangerous for that right now.",
			PIGKINGGAME_TOOLATE = "It's too late for that now.",
        },
        GIVETOPLAYER = 
        {
            FULL = "You don't have any inventory slots left.",
            DEAD = "Oh, it's dead.",
            SLEEPING = "It has entered the deep sleep.",
            BUSY = "They're busy.",
        },
        GIVEALLTOPLAYER = 
        {
            FULL = "They're already heavily burdened.",
            DEAD = "Oh, it's dead.",
            SLEEPING = "They've entered the deep sleep.",
            BUSY = "They're busy.",
        },
        WRITE =
        {
            GENERIC = "I'd rather write in my own books.",
            INUSE = "I have to wait",
        },
        DRAW =
        {
            NOIMAGE = "An example of what I should diagram would be helpful.",
        },
		CHANGEIN =
        {
            GENERIC = "How many skins do you have?",
            BURNING = "I don't think it's time for dress-up?",
            INUSE = "I can't use this right now.",
        },
		ATTUNE =
        {
            NOHEALTH = "I'm feeling too ill for that.",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "It's fighting. I can't do that.",
			INUSE = "I must be patient. I can ride this beefalo later.",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "It's fighting. I can't do that.",
        },
        TEACH =
        {
			--Recipes/Teacher
            KNOWN = "Please. That knowledge is child's play.",
            CANTLEARN = "Is this a kind of forbidden knowledge or something?",
			
			--MapRecorder/MapExplorer
            WRONGWORLD = "This map is not for this dimension, I mean world.",
        },
        WRAPBUNDLE =
        {
            EMPTY = "What am I doing, it's empty.",
        },
        PICKUP =
        {
            RESTRICTION = "That's not my area of expertise.",
            INUSE = "? Where is it?",
        },
		SLAUGHTER =
        {
            TOOFAR = "It got away.",
        },
        REPLATE =
        {
            MISMATCH = "It needs another type of dish.", 
            SAMEDISH = "I only need to use one dish.", 
        },
		SAIL =
        {
            REPAIR = "It's already in ideal condition.",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "That's too early!",
            BAD_TIMING1 = "Am I really focusing?",
            BAD_TIMING2 = "That was terrible timing!",
        },
        LOWER_SAIL_FAIL =
        {
            "Why it doesn't lower?",
            "Is there something stuck?",
            "I, can't lower?",
        },
        BATHBOMB =
        {
            GLASSED = "It was not mine that the surface has crystallized.",
            ALREADY_BOMBED = "It's already bombed",
        },
	},
	ACTIONFAIL_GENERIC = "I can't do that.",
	ANNOUNCE_BOAT_LEAK = "I don't feel so good...",
	ANNOUNCE_BOAT_SINK = "I don't want to drown!",
	ANNOUNCE_ADVENTUREFAIL = "Something is disturbing that I go to another dimension. I'll have to try again.",
	ANNOUNCE_BEES = "Bee careful!",
	ANNOUNCE_BOOMERANG = {
		"Ouch! Is that your physical limit?",
		"Please press the Spacebar before it hits me!",
	},
	ANNOUNCE_CHARLIE = "Where? where is it?!",
	ANNOUNCE_CHARLIE_ATTACK = "IT FORCES ME OUT OF THIS WORLD!!",
	ANNOUNCE_COLD = {
		"It's too cold!",
		"Damn you Chirno!",
		"Yuyuko..I'm cold.."
	},
	ANNOUNCE_HOT = "I can't resist anymore!",
	ANNOUNCE_CRAFTING_FAIL = "I can't make it.",
	ANNOUNCE_DEERCLOPS = {
		"We better to leave the base!",
		"I feel something huge is coming!",
	},
	ANNOUNCE_DUSK = {
		"I'm getting sleepy.",
		"The sun's going down.",
		"Getting dark here.",
	},
	ANNOUNCE_EAT =
	{
		GENERIC = "What is...",
		PAINFUL = "That was a painful food...",
		SPOILED = "It passed its expiration date.",
		STALE = "That was not actually food.",
		INVALID = "I can eat humans but this is not!",
	},
	ANNOUNCE_ENCUMBERED =
    {
        "This...is...heavy...",
        "......",
        "Why did I come here?",
        "This is really heavy.",
        "I'm more spry than I look!",
        "This is not what I supposed to do...",
        "Ran! .....help!",
        "How.. invigorating!",
    },
	ANNOUNCE_ATRIUM_DESTABILIZING = 
    {
        "Well.. It's time to RUN!",
        "It's dangerous to be here.",
        "Oops.",
    },
	ANNOUNCE_ENTER_DARK = "It's BLACK!",
	ANNOUNCE_ENTER_LIGHT = "Now I can see a color.",
	ANNOUNCE_FREEDOM = "Finally, I can rest in my home!",
	ANNOUNCE_HIGHRESEARCH = "Leaning is.. unlimited",
	ANNOUNCE_HOUNDS = "Hounds are coming!",
	ANNOUNCE_SHARX = "Jaws!",
	ANNOUNCE_HUNGRY = {
		"I'm really hungry.",
		"Time to eat some food.",
		"Ran! I'm hungry!",
		"Need to eat something.",
		"(rumble)",
	},
	ANNOUNCE_HUNT_BEAST_NEARBY = "I smelled a beast nearby.",
	ANNOUNCE_HUNT_LOST_TRAIL = "The trail is away.",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "The wet ground won't hold a footprint.",
	ANNOUNCE_INV_FULL = "I can't carry anymore",
	ANNOUNCE_KNOCKEDOUT = {
		"Ouch, my head!",
		"Hey! Can't you control better?",
		"Ah! You let me hit that thing?",
	},
	ANNOUNCE_LOWRESEARCH = "I didn't learn very much from that.",
	ANNOUNCE_MOSQUITOS = "I hate that noise!",
	ANNOUNCE_NODANGERSLEEP = "They might have noticed me. I can't sleep now.",
	ANNOUNCE_NODAYSLEEP = "I can be more constructive right now?",
	ANNOUNCE_NODAYSLEEP_CAVE = "Well, I'm not sleepy.",
	ANNOUNCE_NOHUNGERSLEEP = "I'm too hungry to sleep.",
	ANNOUNCE_NOSLEEPONFIRE = "I don't think it's good to sleep",
	ANNOUNCE_NODANGERSIESTA = "They might notice me. I can't sleep right now.",
	ANNOUNCE_NONIGHTSIESTA = "The night is for sleeping. not for Siesta.",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "I don't think I could really relax down here.",
	ANNOUNCE_NOHUNGERSIESTA = "I'm too hungry to sleep.",
	ANNOUNCE_NO_TRAP = "Well, that was easy.",
	ANNOUNCE_PECKED = "Ouch! you pecked me?!",
	ANNOUNCE_QUAKE = {
		"I'm gonna watch my head.",
		"Don't let me hit.",
		"You better not to let me hit.",
		"How dare I can be hit by those rocks?",
		"I believe you. Player. You.",
		"I believe you.",
	},
	ANNOUNCE_RESEARCH = "Never stop learning!",
	ANNOUNCE_SHELTER = {
		"Shade is much better.",
		"+180 Insulation under the shade",
	},
	ANNOUNCE_THORNS = "Ow! My hands!",
	ANNOUNCE_BURNT = "AW! LIGHT OFF! That was crazy!",
	ANNOUNCE_TORCH_OUT = "My torch is burnt!",
	ANNOUNCE_TRAP_WENT_OFF = "Oops,",
	ANNOUNCE_UNIMPLEMENTED = "I don't think it's ready yet.",
	ANNOUNCE_WORMHOLE = "What a creepy gate! Mine was better!",
	ANNOUNCE_TOWNPORTALTELEPORT = "That's one way to travel.",
	ANNOUNCE_CANFIX = "\nI can fix this.",
	ANNOUNCE_ACCOMPLISHMENT = "Do I acheive or something?",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "Well, It's done.",	
	ANNOUNCE_INSUFFICIENTFERTILIZER = "This plant is going to be withered. I need some fertilizer.",
	ANNOUNCE_TOOL_SLIP = "Aw! That was dangerous!",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "What! Is this a fully-shockproof?",
	ANNOUNCE_TOADESCAPING = "It will need to burrow soon to rehydrate its skin.",
    ANNOUNCE_TOADESCAPED = "It has burrowed away.",

	ANNOUNCE_DIG_DISEASE_WARNING = "Caught it just in time. The roots were nearly rotten.",
    ANNOUNCE_PICK_DISEASE_WARNING = "This plant is exhibiting concerning signs.",
    ANNOUNCE_MOUNT_LOWHEALTH = "My mount has low health.",
    ANNOUNCE_ANTLION_SINKHOLE = 
    {
        "The ground will soon give way.",
        "Not the work of tectonic plates.",
        "A six on the Richter scale.",
    },
    ANNOUNCE_ANTLION_TRIBUTE = "......",
    ANNOUNCE_SACREDCHEST_YES = "That did the trick.",
    ANNOUNCE_SACREDCHEST_NO = "Shoot. I thought I had it.",
    ANNOUNCE_NODANGERAFK = "That trick won't work I think.",
    ANNOUNCE_NODANGERGIFT = "This is not supposed to do.",
    ANNOUNCE_NOMOUNTEDGIFT = "I do believe I should dismount first.",
    ANNOUNCE_NOWARDROBEONFIRE = "As you can plainly see, it is ablaze.",
    ANNOUNCE_WORMS = "Something nasty is crawling through here!",

    ANNOUNCE_KLAUS_ENRAGE = "Oh, you now enraged?",
    ANNOUNCE_KLAUS_UNCHAINED = "Whatever enchantment restrained it has been undone.",
    ANNOUNCE_KLAUS_CALLFORHELP = "Careful! It has summoned its minion.",

    --hallowed nights
    ANNOUNCE_SPOOKED = {
		"I hate this.",
		"What is this?",
	},
    ANNOUNCE_BRAVERY_POTION = "It feel like a drug!",

	ANNOUNCE_DAMP = {
		"Oh, I'm wet!.",
		"I should use my umbrealla."
	},
	ANNOUNCE_WET = "My whole clothes are wet!",
	ANNOUNCE_WETTER = "I'm so drenched!",
	ANNOUNCE_SOAKED = "My body is now heavy as heck!",
	
	ANNOUNCE_TREASURE = "Now I'm one of the treasure hunts.",
	ANNOUNCE_MORETREASURE = "Must be another treasure somewhere.",
	ANNOUNCE_OTHER_WORLD_TREASURE = "I think this is wrong map.",
	ANNOUNCE_OTHER_WORLD_PLANT = "This plant won't grow in here.",
	
	ANNOUNCE_MESSAGEBOTTLE =
	{
		"The message is faded. I can't read it.",
	},
	ANNOUNCE_VOLCANO_ERUPT = "That's a real eruption!",
	ANNOUNCE_MAPWRAP_WARN = "Here there be monsters.",
	ANNOUNCE_MAPWRAP_LOSECONTROL = "It's so foggy...",
	ANNOUNCE_MAPWRAP_RETURN = "I wasn't that much dangerous.",
	ANNOUNCE_CRAB_ESCAPE = "It disappears!",
	ANNOUNCE_TRAWL_FULL = "So many fishes!",
	ANNOUNCE_BOAT_DAMAGED = "Look at that boat matter, man.",
	ANNOUNCE_BOAT_SINKING = "Oops, This is not good.",
	ANNOUNCE_BOAT_SINKING_IMMINENT = "It gonna be broken!",
	ANNOUNCE_WAVE_BOOST = "Surfing time!",

	ANNOUNCE_WHALE_HUNT_BEAST_NEARBY = "I smell salty-freshy beast..!",
	ANNOUNCE_WHALE_HUNT_LOST_TRAIL = "I can't find trail anymore.",
	ANNOUNCE_WHALE_HUNT_LOST_TRAIL_SPRING = "My eyes can't follow the trail.",
	
	BATTLECRY =
	{
		GENERIC = "I'll let you a death!",
		SPIDER = "I'll let your guts out!",
		SPIDER_WARRIOR = "I'll let your guts out!",
	},
	COMBAT_QUIT =
	{
		GENERIC = "Now you have murdered by me.",
		SPIDER_WARRIOR = "How weak were you!",
	},
	DESCRIBE =
	{
        GLOMMER = "Hey! can you see UV rays?",
        GLOMMERFLOWER = 
        {
        	GENERIC = "Rafflesia!",
        	DEAD = "That's weird it doesn't smell at all.",
        },
        GLOMMERWINGS = "Did It floated with this wings?",
        GLOMMERFUEL = "Is this the..",
        BELL = "Maybe I should not set this on my main door?",
        STATUEGLOMMER = 
        {	
        	GENERIC = "It symbolizes something special.",
        	EMPTY = "Still I can feel a magical power on it.",
    	},

		WEBBERSKULL = "Poor little guy. He deserves a proper funeral.",
		WORMLIGHT = "Is this digestible?",
		WORM =
		{
		    PLANT = "It lures me.",
		    DIRT = "The worm inside of it.",
		    WORM = "What a huge worm!",
		},
		MOLE =
		{
			HELD = "Don't worry, I won't put you into a Mole Game.",
			UNDERGROUND = "The realistic version of Mole Game, huh?",
			ABOVEGROUND = "Hit it! Hit it!",
		},
		MOLEHILL = "The storage of minerals",
		MOLEHAT = "Let's see with Mole's vision.",

		EEL = "It's much migher then it see.",
		EEL_COOKED = "smells yummy!",
		UNAGI = "Sushi?",
		EYETURRET = "What a wierd turret!",
		EYETURRET_ITEM = "I think I should place it carefully.",
		MINOTAURHORN = "Not so hard as rock. Maybe, I can eat this.",
		MINOTAURCHEST = "Typical Dungeon Boss Reward, huh?",
		THULECITE_PIECES = "The pile of something magical material.",
		POND_ALGAE = "A natural algea pond.",
		GREENSTAFF = "This may disassemble structures without loose physical items.",
		POTTEDFERN = "A flowerless plant that reproduces by spores.",

		THULECITE = "It craves someone's fear.",
		ARMORRUINS = "It faintly shines with vacuity.",
		RUINS_BAT = "It can emit its nightmare power anytime.",
		RUINSHAT = "Ruined King's Crown.",
		NIGHTMARE_TIMEPIECE =
		{
		CALM = "Everything is calm downed.",
		WARN = "The Darkness was beginning to gain.",
		WAXING = "Sorroundings are waxing with The Nightmare!",
		WANING = "I can feel the magical energy.",
		STEADY = "It starts to loose its power.",
		DAWN = "Now It goes dim. But not disappeared.",
		NOMAGIC = "There's no magic around here.",
		},
		BISHOP_NIGHTMARE = "A broken Bishop.",
		ROOK_NIGHTMARE = "He has the emotion. He's angry Now.",
		KNIGHT_NIGHTMARE = "Knightmare with Nightmare.",
		MINOTAUR = "I think that's the Minotaur.",
		SPIDER_DROPPER = "Spider with white beard!",
		NIGHTMARELIGHT = "I see a terrible Nightmares Inside.",
		NIGHTSTICK = "It will be maximized with wetness.",
		GREENGEM = "This symbolizes creation and destroy.",
		RELIC = "This should be exhibited.",
		RUINS_RUBBLE = "This can be fixed.",
		MULTITOOL_AXE_PICKAXE = "Seems like picksaw.",
		ORANGESTAFF = "This do same as my umbrella. What a useless!",
		YELLOWAMULET = "It emits glorious light.",
		GREENAMULET = "This provide ingredients from void.",
		SLURPERPELT = "So dirty.",	

		SLURPER = "Is that a monad or something?",
		SLURPER_PELT = "So dirty.",
		ARMORSLURPER = "Ewk, This is not hygienic.",
		ORANGEAMULET = "What is this use of?",
		YELLOWSTAFF = "Planet's lights are glown.",
		YELLOWGEM = "This symbolizes planets in universe.",
		ORANGEGEM = "This symbolizes human desire.",
		TELEBASE = 
		{
			VALID = "Energy flows through it.",
			GEMS = "It needs more purple gems.",
		},
		GEMSOCKET = 
		{
			VALID = "These set coordinate of teleportion.",
			GEMS = "It needs a gem.",
		},
		STAFFLIGHT = "Common situation with emitting magical power.",
	
        ANCIENT_ALTAR = "They must lived with highly developed civilization.",

        ANCIENT_ALTAR_BROKEN = "Altar's broken. I can fix with its ingredients.",

        ANCIENT_STATUE = "Vanity.",

        LICHEN = "A glowing symbiote",
		CUTLICHEN = "This will rot very fast.",

		CAVE_BANANA = "Its DNA structure is similar with humans.",
		CAVE_BANANA_COOKED = "Warm and yummy!",
		CAVE_BANANA_TREE = "Isn't it a tropical plant?",
		ROCKY = "Their muscles are protected with hard stone.",
		
		COMPASS =
		{
			GENERIC="I can't get a reading.",
			N = "North",
			S = "South",
			E = "East",
			W = "West",
			NE = "Northeast",
			SE = "Southeast",
			NW = "Northwest",
			SW = "Southwest",
		},

		NIGHTMARE_TIMEPIECE =
		{
			WAXING = "Their screaming is waving.",
			STEADY = "They are around us.",
			WANING = "They start to wax.",
			DAWN = "They're going to be dim.",
			WARN = "They're coming.",
			CALM = "They're gone.",
			NOMAGIC = "There's no magic around here.",
		},

		HOUNDSTOOTH="It's hard and usefully sharp.",
		ARMORSNURTLESHELL="This also eventually be broken.",
		BAT="A nocturnal, mammal animal.",
		BATBAT = "Why don't its ingredients include their tooth?",
		BATWING="So stachelig. I hate it.",
		BATWING_COOKED="Better than the raw.",
		BEDROLL_FURRY="Looks cozy.",
		BUNNYMAN="Are they hate me..?",
		FLOWER_CAVE="That's not a LED.",
		FLOWER_CAVE_DOUBLE="That's not a LED.",
		FLOWER_CAVE_TRIPLE="That's not a LED.",
		GUANO="Extra smelly.",
		LANTERN="It's a bit heavy.",
		LIGHTBULB="...Edible lightbulb.",
		MANRABBIT_TAIL="So furry.",
		MUSHTREE_TALL  ="This one is taller than common trees!.",
		MUSHTREE_MEDIUM="Looks different with Minecraft ones.",
		MUSHTREE_SMALL ="Green magic mushtree.",
		RABBITHOUSE=
		{
			GENERIC = "Are they really love carrots?",
			BURNT = "Now it burnt.",
		},
		SLURTLE="He's looking for minerals.",
		SLURTLE_SHELLPIECES="Looks good ingredients for flowerpot.",
		SLURTLEHAT="It's unexpectedly tight as head.",
		SLURTLEHOLE="Why this is so spiky?",
		SLURTLESLIME="An explodable slime.",
		SNURTLE="He seems to be less agressive.",
		SPIDER_HIDER="Their skins are so tight!",
		SPIDER_SPITTER="Common AD monster.",
		SPIDERHOLE="Looks like a spider den.",
		STALAGMITE="They do growth. but they aren't organism.",
		STALAGMITE_FULL="Seems they fully grown up.",
		STALAGMITE_LOW="They do growth. but they aren't organism.",
		STALAGMITE_MED="They do growth. but they aren't organism.",
		STALAGMITE_TALL="They do growth. but they aren't organism.",
		STALAGMITE_TALL_FULL="Seems they fully grown up.",
		STALAGMITE_TALL_LOW="They do growth. but they aren't organism.",
		STALAGMITE_TALL_MED="They do growth. but they aren't organism.",

		TURF_CARPETFLOOR = "It's an item form now. So I can hold it.",
		TURF_CHECKERFLOOR = "It's an item form now. So I can hold it.",
		TURF_DIRT = "It's an item form now. So I can hold it.",
		TURF_FOREST = "It's an item form now. So I can hold it.",
		TURF_GRASS = "It's an item form now. So I can hold it.",
		TURF_MARSH = "It's an item form now. So I can hold it.",
		TURF_ROAD = "It's an item form now. So I can hold it.",
		TURF_ROCKY = "It's an item form now. So I can hold it.",
		TURF_SAVANNA = "It's an item form now. So I can hold it.",
		TURF_WOODFLOOR = "It's an item form now. So I can hold it.",

		TURF_CAVE="It's an item form now. So I can hold it.",
		TURF_FUNGUS="It's an item form now. So I can hold it.",
		TURF_SINKHOLE="It's an item form now. So I can hold it.",
		TURF_UNDERROCK="It's an item form now. So I can hold it.",
		TURF_MUD="It's an item form now. So I can hold it.",

		TURF_DECIDUOUS = "It's an item form now. So I can hold it.",
		TURD_SANDY = "It's an item form now. So I can hold it.",
		TURF_BADLANDS = "It's an item form now. So I can hold it.",

		POWCAKE = "I think it has no nutrient.",
        CAVE_ENTRANCE = 
        {
            GENERIC="Someone plugged it up on purpose.",
            OPEN = "I can go deeper.",
        },
        CAVE_EXIT = "I think I didn't tie with a rope.",
		MAXWELLPHONOGRAPH = "It suffers him.",
		BOOMERANG = "Actually, This is hard to control.",
		PIGGUARD = "Stupid zealots.",
		ABIGAIL = "Who makes you undead?",
		ADVENTURE_PORTAL = "That is, what I have to go.",
		AMULET = "This really gives me an extra life.",
		ANIMAL_TRACK = "Beast lefts its trail.",
		ARMORGRASS = "I'm worried about its protection.",
		ARMORMARBLE = "Really, It's so heavy.",
		ARMORWOOD = "I don't want to fire fighting.",
		ARMOR_SANITY = "More like shield.",
		ASH =
		{
			GENERIC = "Every mortals finally goes to.",
			REMAINS_GLOMMERFLOWER = "oh, It wasn't disappeared.",
			REMAINS_EYE_BONE = "oh, It wasn't disappeared.",
			REMAINS_THINGIE = "oh, It wasn't disappeared.",
		},
		AXE = "This must be more potenter than sword.",
		BABYBEEFALO = "Look at that empty eyes!",
		BACKPACK = "One of necessaries for survival.",
		BACONEGGS = "Abundance of proteins",
		BANDAGE = "I don't think it's good for my skins.",
		BASALT = "Just rock.",
		BATBAT = "Why don't its ingredients include their tooth?",
		BEARDHAIR = "Dirty beard",
		BEARGER = "What a big badger!",
		BEARGERVEST = "I'm afraid for hibernation.",
		ICEPACK = "Natural styrofoam",
		BEARGER_FUR = "It consists of high saturated fat.",
		BEDROLL_STRAW = "is little tough.",
		BEE =
		{
			GENERIC = "Very systematic creature always. where I was, and here too.",
			HELD = "Bee calm!",
		},
		BEEBOX =
		{
			FULLHONEY = "That smell lures me!",
			GENERIC = "Bee careful!",
			NOHONEY = "It's empty.",
			SOMEHONEY = "That smell lures me!",
			BURNT = "Wait, is the honey flammable?",
		},
		BEEFALO =
		{
			FOLLOWER = "Am I cowherder?.",
			GENERIC = "Look at that doom face!",
			NAKED = "A bit sorry for watching.",
			SLEEPING = "Was that a snoring sound?",
		},
		BEEFALOHAT = "Beefalos won't doubt me with this hat.",
		BEEFALOWOOL = "Less smelly than I expected.",
		BEEHAT = "This mesh is smaller than bee stingers.",
		BEEHIVE = "I need that honey.",
		BEEMINE = "Handle with care",
		BEEMINE_MAXWELL = "I think mosquitoes inside of it.",
		BERRIES = "Ardisia crenata.",
		BERRIES_COOKED = "Sticky.",
		BERRYBUSH =
		{
			BARREN = "I think it needs to be fertilized.",
			WITHERED = "Heat withered him.",
			GENERIC = "Ardisia crenata.",
			PICKED = "They will grow back after 3-5 days.",
		},
		BIGFOOT = "Look at that brain on top!",
		BIRDCAGE =
		{
			GENERIC = "I have to put a bird in.",
			OCCUPIED = "It knows that can't escape.",
			SLEEPING = "It's sleeping.",
		},
		BIRDTRAP = "Will they come and get trapped in here?",
		BIRD_EGG = "It's smaller than I expected.",
		BIRD_EGG_COOKED = "Looks delicious.",
		BISHOP = "Seems they're waiting something.",
		BLOWDART_FIRE = "This set the target on fire.",
		BLOWDART_SLEEP = "I have to be care of sucking it in.",
		BLOWDART_PIPE = "I am a ninja!",
		BLUEAMULET = "It absorbs heat around here.",
		BLUEGEM = "This symbolizes coldness.",
		BLUEPRINT = "I have no idea how this works.",
		BELL_BLUEPRINT = "Its ingredients are very suspicious",
		BLUE_CAP = "Longish blue mushroom.",
		BLUE_CAP_COOKED = "Smells sweety.",
		BLUE_MUSHROOM =
		{
			GENERIC = "It will grow back on night.",
			INGROUND = "I can't pick it up now.",
			PICKED = "Will grow after raining.",
		},
		BOARDS = "Flat log.",
		BOAT = "NICE BOAT.",
		BONESHARD = "Bits of bone.",
		BONESTEW = "Oh, CaCO3.",
		BUGNET = "A tool for catching bugs.",
		BUSHHAT = "I hope this gonna work.",
		BUTTER = "Butter from butterfly.",
		BUTTERFLY =
		{
			GENERIC = "Butterfly, flutter by.",
			HELD = "Oh poor, I don't want to murder you.",
		},
		BUTTERFLYMUFFIN = "Its decoration makes me agony.",
		BUTTERFLYWINGS = "NOW I MURDERED YOU.",
		BUZZARD = "They're looking for some trashes.",
		CACTUS = 
		{
			GENERIC = "Their leaves are extremely thin.",
			PICKED = "This will regrow in 3 days.",
		},
		CACTUS_MEAT_COOKED = "Roasted.. juice!",
		CACTUS_MEAT = "Spiky juice.",
		CACTUS_FLOWER = "It has beautiful color on desert.",

		COLDFIRE =
		{
			EMBERS = "It is going to be disappeared.",
			GENERIC = "Inverted fire. Interesting.",
			HIGH = "It absorbs most of heat around here.",
			LOW = "It's still beatiful.",
			NORMAL = "Inverted fire. Interesting.",
			OUT = "Well, that's over.",
		},
		CAMPFIRE =
		{
			EMBERS = "It is going to be disappeared.",
			GENERIC = "Why here's night is extremely dark?",
			HIGH = "I need to remove combustible substance around here.",
			LOW = "Better put some fuels on it.",
			NORMAL = "Common camp fire.",
			OUT = "Well, that's over.",
		},
		CANE = "What is this use of?",
		CATCOON = "It's	just bored.",
		CATCOONDEN = 
		{
			GENERIC = "Who cut that stump?.",
			EMPTY = "It's empty.",
		},
		CATCOONHAT = "It's a bit thin I think.",
		COONTAIL = "Furry.",
		CARROT = "It's Daucus carota.",
		CARROT_COOKED = "Good food for nyctalopia.",
		CARROT_PLANTED = "I can pick it up.",
		CARROT_SEEDS = "Seed of Daucus carota.",
		WATERMELON_SEEDS = "Seed of Citrullus lanatus.",
		CAVE_FERN = "One of Pteridophyta.",
		CHARCOAL = "Wickedness.",
        CHESSJUNK1 = "Clockwork junk.",
        CHESSJUNK2 = "Clockwork junk.",
        CHESSJUNK3 = "Clockwork junk.",
		CHESTER = "DON'T DROOL, stupid.",
		CHESTER_EYEBONE =
		{
			GENERIC = "It's looking at me.",
			WAITING = "He'll back in a day.",
		},
		COOKEDMANDRAKE = "Why you do a dead-face?!",
		COOKEDMEAT = "Most of cooked meats are shown as a steak.",
		COOKEDMONSTERMEAT = "It's hardly spiky.",
		COOKEDSMALLMEAT = "This is it.",
		COOKPOT =
		{
			COOKING_LONG = "This will take some time.",
			COOKING_SHORT = "It's going to be done.",
			DONE = "It's done. I can eat it.",
			EMPTY = "I can cook foods in here.",
			BURNT = "The pot got cooked.",
		},
		CORN = "Zea mays. Half of this will be abandoned.",
		CORN_COOKED = "Cooked corn.. I mean popcorn!",
		CORN_SEEDS = "Seed of Zea mays.",
		CROW =
		{
			GENERIC = "Okuu?",
			HELD = "I got Okuu.",
		},
		CUTGRASS = "Stuff for crafting.",
		CUTREEDS = "Stuff for crafting.",
		CUTSTONE = "Stuff for building.",
		DEADLYFEAST = "For suicide",
		DEERCLOPS = "A giant one-eyed creture",
		DEERCLOPS_EYEBALL = "Hope this doesn't read my mind.",
		EYEBRELLAHAT =	"The eyeball is really tough!",
		DEPLETED_GRASS =
		{
			GENERIC = "Needs to be fertilized.",
		},
		DEVTOOL = "Are you a developer?",
		DEVTOOL_NODEV = "What is this for?",
		DIRTPILE = "Something left this trail.",
		DIVININGROD =
		{
			COLD = "Nothing around here",
			GENERIC = "To find some 'thing'.",
			HOT = "Something is on your screen!",
			WARM = "Oh, It works!",
			WARMER = "I think the thing is around here.",
		},
		DIVININGRODBASE =
		{
			GENERIC = "It linked it to the other world.",
			READY = "I need to insert my divining rod.",
			UNLOCKED = "I can see what's beyond the world..",
		},
		DIVININGRODSTART = "I should pick it up.",
		DRAGONFLY = "That creature makes me confused.",
		ARMORDRAGONFLY = "I think it's softer than previous one.",
		DRAGON_SCALES = "It's a fly's scale!",
		DRAGONFLYCHEST = "I have to put something special.",
		LAVASPIT = 
		{
			HOT = "I think that's under 300°C.",
			COOL = "It's even cool-downed.",
		},
		DRAGONFRUIT = "That's Hylocereus Undatus. Good for women.",
		DRAGONFRUIT_COOKED = "What a healthy food!",
		DRAGONFRUIT_SEEDS = "Seed of Hylocereus Undatus.",
		DRAGONPIE = "It's even healthier.",
		DRUMSTICK = "Yummy!",
		DRUMSTICK_COOKED = "Chicken!!",
		DUG_BERRYBUSH = "I should plant this.",
		DUG_GRASS = "I should plant this.",
		DUG_MARSH_BUSH = "I should plant this.",
		DUG_SAPLING = "I should plant this.",
		DURIAN = "Durio Zibethinus. Drastic food.",
		DURIAN_COOKED = "Ewk, It wasn't a good idea.",
		DURIAN_SEEDS = "Seed of Durio Zibethinus.",
		EARMUFFSHAT = "It's so soft!",
		EGGPLANT = "Solanum Melongena, It's a perennial plant.",
		EGGPLANT_COOKED = "I don't want to eat this alone.",
		EGGPLANT_SEEDS = "Seed of Solanum Melongena.",
		DECIDUOUSTREE = 
		{
			BURNING = "Combustion.",
			BURNT = "It burnt.",
			CHOPPED = "It's too small to rest.",
			POISON = "Was it a monster?",
			GENERIC = "That's a deciduoustree. It bears fruit when fully grown.",
		},
		ACORN = 
		{
		    GENERIC = "Seed of tree.",
		    PLANTED = "It'll be a tree.",
		},
		ACORN_COOKED = "I like its flavor.",
		BIRCHNUTDRAKE = "Monster's minion.",
		EVERGREEN =
		{
			BURNING = "Combustion.",
			BURNT = "It burnt.",
			CHOPPED = "It's too small to rest.",
			GENERIC = "It's a tree.",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "Combustion.",
			BURNT = "It burnt.",
			CHOPPED = "It's too small to rest.",
			GENERIC = "They cannot leave their junior.",
		},
		EYEPLANT = "I think I'm being watched.",
		FARMPLOT =
		{
			GENERIC = "I can plant plants.",
			GROWING = "She's in growth!",
			NEEDSFERTILIZER = "I think it needs to be fertilized.",
			BURNT = "It burnt.",
		},
		FEATHERHAT = "They might consider me as an alliance.",
		FEATHER_CROW = "Feather of Okuu.",
		FEATHER_ROBIN = "Feather of Cardinalis.",
		FEATHER_ROBIN_WINTER = "Feather of white Cardinalis.",
		FEM_PUPPET = "",
		FIREFLIES =
		{
			GENERIC = "Group of Luciola cruciata",
			HELD = "They emit light for breeding.",
		},
		FIREHOUND = "Don't let him die around structures.",
		FIREPIT =
		{
			EMBERS = "It is going to be disappeared.",
			GENERIC = "Boring.",
			HIGH = "Much warmer.",
			LOW = "Better put some fuels on it.",
			NORMAL = "What's the next plan?",
			OUT = "Well, that's over.",
		},
		COLDFIREPIT =
		{
			EMBERS = "It is going to be disappeared.",
			GENERIC = "Nice and cool.",
			HIGH = "Well, that's Beautiful at least.",
			LOW = "Better put some fuels on it.",
			NORMAL = "How unrealistic.",
			OUT = "Well, that's over.",
		},
		FIRESTAFF = "Flame Wizard.",
		FIRESUPPRESSOR = 
		{	
			ON = "What's the source of ice?",
			OFF = "It's disabled.",
			LOWFUEL = "Better put some fuels in it.",
		},
		
		FISH = "Looks agly.",
		FISHINGROD = "How traditional!",
		FISHSTICKS = "Still Fishy!",
		FISHTACOS = "Fishy Taco.",
		FISH_COOKED = "It's now a food.",
		FLINT = "This might be useful to shape tools.",
		FLOWER = "All flowers are pretty and gorgeous.",
		FLOWERHAT = "But this is embarrassing!",
		FLOWER_EVIL = "Looks Beautiful, but it drains spirit.",
		FOLIAGE = "So purple. I like it.",
		FOOTBALLHAT = "A bit stuffy, but tight.",
		FROG =
		{
			DEAD = "You should have to stay in well.",
			GENERIC = "Creepy. Unlike Suwako.",
			SLEEPING = "Is he sleep with eyes open?",
		},
		FROGGLEBUNWICH = "You better be tasty...!",
		FROGLEGS = "Now it's time for electronic shock?",
		FROGLEGS_COOKED = "Better than shocked.",
		FRUITMEDLEY = "What a Refreshing!",
		GEARS = "Here's scientific mechines are un-understandable. What is this use for?",
		GHOST = "You are undead.",
		GOLDENAXE = "The Golden Axe harder than stone axe.",
		GOLDENPICKAXE = "I think I can't mine diamond through this?",
		GOLDENPITCHFORK = "Why did I even make a pitchfork this fancy?",
		GOLDENSHOVEL = "Laboury and glorious.",
		GOLDNUGGET = "SEEMS IT'S HARDER THAN ROCK.",
		GRASS =
		{
			BARREN = "It needs nutrient.",
			WITHERED = "It withered because of heat.",
			BURNING = "That's why it is used for fuel",
			GENERIC = "It's a tuft of grass.",
			PICKED = "It was cut down in the prime of its life.",
		},
		GREEN_CAP = "It doesn't have poison. I think.",
		GREEN_CAP_COOKED = "Salty!",
		GREEN_MUSHROOM =
		{
			GENERIC = "It's a green mushroom.",
			INGROUND = "It will comes out in dusk.",
			PICKED = "It will grow back in 2 days.",
		},
		GUNPOWDER = "Time to fireworks!",
		HAMBAT = "The weapon in un-convenient way.",
		HAMMER = "Isn't mole somewhere?",
		HEALINGSALVE = "Looks bitter.",
		HEATROCK =
		{
			FROZEN = "Icy as Chirno!",
			COLD = "Cold as Letty.",
			GENERIC = "I could manipulate its temperature.",
			WARM = "Nice and warm",
			HOT = "Hot as Utsuho!",
		},
		HOME = "Someone must live here.",
		HOMESIGN = 
		{
			GENERIC = "It says 'You are here'.",
			BURNT = "It says... I can't read it.",
		},
		HONEY = "Looks honey",
		HONEYCOMB = "It's taller than I expected.",
		HONEYHAM = "Sweety, sticky meat!",
		HONEYNUGGETS = "I cooked it myself!",
		HORN = "Are they sound from horn?!",
		HOUND = "He's so aggressive!",
		HOUNDBONE = "Creepy.",
		HOUNDMOUND = "That's a Hound den.",
		ICEBOX = "It requires gears. But where are they go?",
		ICEHAT = "Heavy and Melty. But It will completly block from hyperthermia.",
		ICEHOUND = "Their heart is filled with cold wave.",
		INSANITYROCK =
		{
			ACTIVE = "Its hardness is with magic.",
			INACTIVE = "An living-magical rock.",
		},
		JAMMYPRESERVES = "Sticky and yummy.",
		KABOBS = "Traditional food on Central Asia.",
		KILLERBEE =
		{
			GENERIC = "They're looking for something to attack.",
			HELD = "Bee calm.",
		},
		KNIGHT = "Check, mate.",
		KOALEFANT_SUMMER = "Something.. Hybridism.",
		KOALEFANT_WINTER = "Something.. Hybridism.",
		KRAMPUS = "He seems steal my stuff.",
		KRAMPUS_SACK = "Huge Storage. I like it.",
		LEIF = "Was that a monster?",
		LEIF_SPARSE = "Was that a monster?",
		LIGHTNING_ROD =
		{
			CHARGED = "What a Might!",
			GENERIC = "Safety comes first!",
		},
		LIGHTNINGGOAT = 
		{
			GENERIC = "You remind me Goat Simulater.",
			CHARGED = "Don't mess everything up!",
		},
		LIGHTNINGGOATHORN = "Will this use for lightning rod?",
		GOATMILK = "This must be a carbonated drink.",
		LITTLE_WALRUS = "He's learning desperately.",
		LIVINGLOG = "Are you a cursed tree?",
		LOCKEDWES = "He seems can't talk so that I didn't notice him.",
		LOG =
		{
			BURNING = "Combustion",
			GENERIC = "It's a log. Typical resource of survival game.",
		},
		LUREPLANT = "What does it ultimately want to?",
		LUREPLANTBULB = "It's so agressive.",
		MALE_PUPPET = "",
		MANDRAKE =
		{
			DEAD = "Well, it's more like ginseng.",
			GENERIC = "Atropa mandragora.",
			PICKED = ".....",
		},
		MANDRAKESOUP = "Best health food!",
		MANDRAKE_COOKED = "Why is this carrot-shaped?",
		MARBLE = "Crystalline limestone.",
		MARBLEPILLAR = "Ionic pillar.",
		MARBLETREE = "Seems like an icecream.",
		MARSH_BUSH =
		{
			BURNING = "Combustion",
			GENERIC = "Every rose has its thorns. But It's not a rose!",
			PICKED = "That, hurt.",
		},
		MARSH_PLANT = "They can regrow after being burnt.",
		MARSH_TREE =
		{
			BURNING = "Combustion",
			BURNT = "Now it burnt.",
			CHOPPED = "I chopped you, spiky.",
			GENERIC = "Deformed tree.",
		},
		MAXWELL = "There he is!",
		MAXWELLHEAD = "",
		MAXWELLLIGHT = "Their source is unknown.",
		MAXWELLLOCK = "Your destiny is on my hand.",
		MAXWELLTHRONE = "Don't worry. I'll release you. Forever.",
		MEAT = "I can eat it raw without loosing sanity.",
		MEATBALLS = "Really, what's the recipe of this?",
		MEATRACK =
		{
			DONE = "It's done",
			DRYING = "It'll take some time.",
			DRYINGINRAIN = "It can't keep its drying progress while raining.",
			GENERIC = "One of the great ways for preservation.",
			BURNT = "Combusted.",
		},
		MEAT_DRIED = "It's even darkish than I expected.",
		MERM = "That's awful!",
		MERMHEAD = 
		{
			GENERIC = "Dirty, Awful, Terrible!",
			BURNT = "Still Terrible.",
		},
		MERMHOUSE = 
		{
			GENERIC = "Who lives in deserted house?",
			BURNT = "Really. Deserted.",
		},
		MINERHAT = "This expands my activity time.",
		MONKEY = "They have a bad habit of stealing.",
		MONKEYBARREL = "",
		MONSTERLASAGNA = "What did I make?",
		FLOWERSALAD = "Freshy.",
        ICECREAM = "Chirno?",
        WATERMELONICLE = "So stiff.",
        TRAILMIX = "Substitutional food.",
        HOTCHILI = "It's hot but not hot.",
        GUACAMOLE = "Where's avocado?",
		MONSTERMEAT = "I don't think it's good to eat.",
		MONSTERMEAT_DRIED = "Much more darkish. And spiky.",
		MOOSE = "What the....",
		MOOSEEGG = "Many living things are inside of it.",
		MOSSLING = "They have a great appetite.",
		FEATHERFAN = "The most efficient fan!",
		TROPICALFAN = "The most efficient fan!",
		GOOSE_FEATHER = "I don't think it's for warmers.",
		STAFF_TORNADO = "Don't use this near our base.",
		MOSQUITO =
		{
			GENERIC = "Anopheles.",
			HELD = "I'll murder you.",
		},
		MOSQUITOSACK = "I'm worried about the parasite.",
		MOUND =
		{
			DUG = "It dugged.",
			GENERIC = "Something special is under the grave.",
		},
		NIGHTLIGHT = "This makes my mind cold.",
		NIGHTMAREFUEL = "Visualized someone's nightmare.",
		NIGHTSWORD = "I can control this more easily.",
		NITRE = "KNO3",
		ONEMANBAND = "Eh, I'm not good at performance..",
		PANDORASCHEST = "Typical Dungeon Reward, huh?",
		PANFLUTE = "Melodies of sleepiness",
		PAPYRUS = "The brother of Sans.",
		PENGUIN = "Are they have pupil?",
		PERD = "Looks like free chicken.",
		PEROGIES = "The name of this means 'festival'.",
		PETALS = "They can't keep its form for long.",
		PETALS_EVIL = "They absorbs one's mind.",
		PICKAXE = "What a breaking axe!",
		PIGGYBACK = "Unclean.",
		PIGHEAD = 
		{	
			GENERIC = "Disgusting!",
			BURNT = "Now It has even no meaning.",
		},
		PIGHOUSE =
		{
			FULL = "I can feel that they're looking at me.",
			GENERIC = "Well, that's not piggy.",
			LIGHTSOUT = "I knew you, pigs!",
			BURNT = "It burnt.",
		},
		PIGKING = "Only things he want is luxury and pleasure.",
		PIGMAN =
		{
			DEAD = "How disgusting.",
			FOLLOWER = "I'll use him as a slave.",
			GENERIC = "I hate you too.",
			GUARD = "Vained loyalty.",
			WEREPIG = "Die yourself of your aggression!",
		},
		PIGSKIN = "Symbol of pig murderer.",
		PIGTENT = "",
		PIGTORCH = "Fuelable piggy totem.",
		PINECONE = 
		{
		    GENERIC = "Just I don't want to use this up.",
		    PLANTED = "You cannot distinguish after it grown.",
		},
		PITCHFORK = "Let's reveal some of the earth.",
		PLANTMEAT = "This is not the result of photosynthesis.",
		PLANTMEAT_COOKED = "Well, at least it smells meaty.",
		PLANT_NORMAL =
		{
			GENERIC = "Plant of something.",
			GROWING = "I still can't understand farmer's mind.",
			READY = "I think it's fully-grown.",
			WITHERED = "Looks sad...",
		},
		POMEGRANATE = "Punica granatum. It's good at women's skin.",
		POMEGRANATE_COOKED = "Well, It's now not for our skin.",
		POMEGRANATE_SEEDS = "Seed of Punica granatum",
		POND = "It's not clean water.",
		POOP = "It's just item..  It's nothing but a item..",
		FERTILIZER = "Still just F...",
		PUMPKIN = "Cucurbita spp",
		PUMPKINCOOKIE = "Best snacks in this game!!",
		PUMPKIN_COOKED = "It's much softer.",
		PUMPKIN_LANTERN = "Halloween!",
		PUMPKIN_SEEDS = "Seed of Cucurbita spp.",
		PURPLEAMULET = "I can hear their screaming.",
		PURPLEGEM = "This symbolizes mental death.",
		RABBIT =
		{
			GENERIC = "Definitely it's smaller than Tewi.",
			HELD = "Hi! little minion.",
		},
		RABBITHOLE = 
		{
			GENERIC = "Like an ant tunnel.",
			SPRING = "They hate rain.",
		},
		RAINOMETER = 
		{	
			GENERIC = "There's no scientific basis.",
			BURNT = "Much more useless.",
		},
		RAINCOAT = "But it can't prevent my boots from wetness.",
		RAINHAT = "It's like a kindergarten hat.",
		RATATOUILLE = "Traditional French Provence stewed vegetable dish.",
		RAZOR = "Too rough and sharp.",
		REDGEM = "This symbolizes warmth.",
		RED_CAP = "Typical toadstool. but not critical.",
		RED_CAP_COOKED = "Still it's not goot for health.",
		RED_MUSHROOM =
		{
			GENERIC = "It's a red mushroom.",
			INGROUND = "They only grow up during the day.",
			PICKED = "I wonder if it will come back?",
		},
		REEDS =
		{
			BURNING = "Combustion.",
			GENERIC = "Meterials for high-tier items.",
			PICKED = "They will regrow in 3 days.",
		},
        RELIC = 
        {
            GENERIC = "Where was this place for?",
            BROKEN = "I can't even guess what it was.",
        },
        RUINS_RUBBLE = "This can be fixed.",
        RUBBLE = "",
		RESEARCHLAB = 
		{	
			GENERIC = "A science station.",
			BURNT = "Oh.. he's sad...",
		},
		RESEARCHLAB2 = 
		{
			GENERIC = "Better information is stored into it.",
			BURNT = "It burnt.",
		},
		RESEARCHLAB3 = 
		{
			GENERIC = "It's a shadow manipulater.",
			BURNT = "Now it's darker than shadow.",
		},
		RESEARCHLAB4 = 
		{
			GENERIC = "Wait, this magic was 'that' magic?",
			BURNT = "It burnt.",
		},
		RESURRECTIONSTATUE = 
		{
			GENERIC = "I should not have to follow the recipe..",
			BURNT = "It does nothing.",
		},
		RESURRECTIONSTONE = "It sets where I should come back.",
		ROBIN =
		{
			GENERIC = "It's not Tewi.",
			HELD = "Don't shudder, little poor.",
		},
		ROBIN_WINTER =
		{
			GENERIC = "It's not Tewi.",
			HELD = "Soft!",
		},
		ROBOT_PUPPET = "",
		ROCK_LIGHT =
		{ -- Not implemented
			GENERIC = "A crusted over lava pit.",
			OUT = "Looks fragile.",
			LOW = "The lava's crusting over.",
			NORMAL = "Nice and comfy.",
		},
		ROCK = "I think it's your skull.",
		ROCK_ICE = 
		{
			GENERIC = "Icy as Chirno.",
			MELTED = "Chirno has been melted.",
		},
		ROCK_ICE_MELTED = "Chirno has been melted.",
		ICE = "Part of Chirno.",
		ROCKS = "Like your brain.",
        ROOK = "He doesn't Rook good.",
		ROPE = "It's still leafy.",
		ROTTENEGG = "Lump of calcium carbonate!",
		SANITYROCK =
		{
			ACTIVE = "It's an active rock.", -- big
			INACTIVE = "Seems I can go through it now.", -- small
		},
		SAPLING =
		{
			BURNING = "Combustion",
			WITHERED = "It withered because of heat.",
			GENERIC = "It's a sapling.",
			PICKED = "I'll regrow after in 4 days.",
		},
		SEEDS = "I have no idea what's inside.",
		SEEDS_COOKED = "I like its flavor.",
		SEWING_KIT = "Game logic is always good.",
		SHOVEL = "Symbol of worker.",
		SILK = "Stiky",
		SKELETON = "Results of all mortals.",
		SKELETON_PLAYER = "Results of all mortals.", -- It won't actually be spawned.
		SKULLCHEST = "Heh",
		SMALLBIRD =
		{
			GENERIC = "Ew.. So cute!",
			HUNGRY = "It's hungry, but it didn't know how to expose it.",
			STARVING = "I think It's about to die because of starving.",
		},
		SMALLMEAT = "It's a meat. Though it's small.",
		SMALLMEAT_DRIED = "It's so stiff!",
		SPEAR = "Primeval spear.",
		SPIDER =
		{
			DEAD = "I killed it.",
			GENERIC = "It's not Yamame.",
			SLEEPING = "Well, At least It's cute now.",
		},
		SPIDERDEN = "eh, something was changed..",
		SPIDEREGGSACK = "Why it's just...",
		SPIDERGLAND = "Spider guts",
		SPIDERHAT = "what a creepy hat.",
		SPIDERQUEEN = "Things are seriously changed!!",
		SPIDER_WARRIOR =
		{
			DEAD = "I murdered it.",
			GENERIC = "He has slower attack period.",
			SLEEPING = "Good chance to kick it off.",
		},
		SPOILED_FOOD = "Bunch of rots",
		STATUEHARP = "Its head wasn't even designed from the first.",
		STATUEMAXWELL = "Piece of wastes.",
		STINGER = "It has no poison.",
		STRAWHAT = "What a dapper hat.",
		STUFFEDEGGPLANT = "Digestible food.",
		SUNKBOAT = "It's Debug Item!",
		SWEATERVEST = "It's not sticky!",
		REFLECTIVEVEST = "Shiny vest.",
		HAWAIIANSHIRT = "Icy!",
		TAFFY = "It's too sweaty!",
		TALLBIRD = "What the..Is that deformed creature? How can It be alive?",
		TALLBIRDEGG = "I won't be rotted.",
		TALLBIRDEGG_COOKED = "Look at that 'bolks!'",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "It's vibrating",
			GENERIC = "It's hatching.",
			HOT = "It can't put the heat out itself.",
			LONG = "I should not help him with hatching.",
			SHORT = "It'll gonna be broken as soon!",
		},
		TALLBIRDNEST =
		{
			GENERIC = "That egg is worth.",
			PICKED = "The nest is empty.",
		},
		TEENBIRD =
		{
			GENERIC = "What if he fully grew up?",
			HUNGRY = "He's hungry.",
			STARVING = "I think It's going to die because of starving.",
		},
		TELEBASE =
		{
			VALID = "Energy flows through it.",
			GEMS = "It needs more purple gems.",
		},
		GEMSOCKET = 
		{
			VALID = "These set coordinate of teleportion.",
			GEMS = "It needs a gem.",
		},
		TELEPORTATO_BASE =
		{
			ACTIVE = "It's ready to get me out to the world.",
			GENERIC = "This is linked to the other dimension.",
			LOCKED = "There's still something missing.",
			PARTIAL = "Their powers are accumulated.",
		},
		TELEPORTATO_BOX = "Badness are flowing into here.",
		TELEPORTATO_CRANK = "Madness are linked from here.",
		TELEPORTATO_POTATO = "This consist of alien molecules.",
		TELEPORTATO_RING = "Logics in this world is stroed in here.",
		TELESTAFF = "Staff of randomness.",
		TENT = 
		{
			GENERIC = "What if I can't get up?",
			BURNT = "It burnt.",
		},
		SIESTAHUT = 
		{
			GENERIC = "Now I can sleep in the day time!",
			BURNT = "It burnt",
		},
		TENTACLE = "Watch out!",
		TENTACLESPIKE = "Unpleasantly sticky",
		TENTACLESPOTS = "This will be using for water-proofing.",
		TENTACLE_PILLAR = "What a huge!",
		TENTACLE_PILLAR_ARM = "It spawned from the magic energy.",
		TENTACLE_GARDEN = "A giant pole.",
		TOPHAT = "How much can I stack up to?",
		TORCH = "Can't I attach it on wall?",
		TRANSISTOR = "It's a transistor!",
		TRAP = "Capture the fools!",
		TRAP_TEETH = "Deadly teeth",
		TRAP_TEETH_MAXWELL = "That's for the human!",
		TREASURECHEST = 
		{
			GENERIC = "Another Inventory",
			BURNT = "It burnt.",
		},
		TREASURECHEST_TRAP = "I don't think that's a good chest.",
		TREECLUMP = "It blocks me.",
		TRINKET_1 = "Their patterns show it's not natural.",
		TRINKET_10 = "Eccentrically clean",
		TRINKET_11 = "He do lie with no sence of guilt.",
		TRINKET_12 = "So what is this stuff for?",
		TRINKET_2 = "It's an artificial stuff.",
		TRINKET_23 = "Debug Item",
		TRINKET_3 = "Is this a historical stuff or something?",
		TRINKET_4 = "It's a.. Gnome!",
		TRINKET_5 = "Toy for children.",
		TRINKET_6 = "I can't use this for crafting.",
		TRINKET_7 = "Toy for children.",
		TRINKET_8 = "Are they have any bath?",
		TRINKET_9 = "Their color is beautiful.",
		TRUNKVEST_SUMMER = "This is a bit thin.",
		TRUNKVEST_WINTER = "Nice padding wear",
		TRUNK_COOKED = "Looks delicious",
		TRUNK_SUMMER = "This skin looks useful.",
		TRUNK_WINTER = "Extra Fatty.",
		TUMBLEWEED = "I wonder what's inside in it.",
		TURF_CARPETFLOOR = "A chunk of ground.",
		TURF_CHECKERFLOOR = "A chunk of ground.",
		TURF_DIRT = "A chunk of ground.",
		TURF_FOREST = "A chunk of ground.",
		TURF_GRASS = "A chunk of ground.",
		TURF_MARSH = "A chunk of ground.",
		TURF_ROAD = "A chunk of ground.",
		TURF_ROCKY = "A chunk of ground.",
		TURF_SAVANNA = "A chunk of ground.",
		TURF_WOODFLOOR = "A chunk of ground.",
		TURKEYDINNER = "Chicken, this is it.",
		TWIGS = "Can't I make just bow and arrow?",
		UMBRELLA = "What is this use of?",
		GRASS_UMBRELLA = "What is this really use of?",
		PALMLEAF_UMBRELLA = "What is this use of?",
		UNIMPLEMENTED = "",
		WAFFLES = "Should I get this honey on my hand?",
		WALL_HAY = 
		{	
			GENERIC = "I should keep the fire off.",
			BURNT = "It burnt.",
		},
		WALL_HAY_ITEM = "It isn't some kind of feeds.",
		WALL_STONE = "Better than others.",
		WALL_STONE_ITEM = "This will set my own place.",
		WALL_RUINS = "Seems like golden.",
		WALL_RUINS_ITEM = "It's very hard.",
		WALL_WOOD = 
		{
			GENERIC = "I should keep the fire off.",
			BURNT = "It burnt.",
		},
		WALL_WOOD_ITEM = "I don't like this.",
		WALRUS = "Odobenus rosmarus of Gaelic variety",
		WALRUSHAT = "Hunters Hat (+2)",
		WALRUS_CAMP =
		{
			EMPTY = "It's a building lot.",
			GENERIC = "I think.. stones are inside of the walls.",
		},
		WALRUS_TUSK = "Quite durable",
		WARG = "It's a big dog. But It will tire us unless being killed.",
		WASPHIVE = "Bee's colony",
		WATERMELON = "It's a.. Suika!",
		WATERMELON_COOKED = "It's a.. Suika!",
		WATERMELONHAT = "Hat Suika!",
		WETGOOP = "This food's calories is absolutely zero.",
		WINTERHAT = "Some nice winter hat.",
		WINTEROMETER = 
		{
			GENERIC = "That's not just a long-ranged timer.",
			BURNT = "It burnt.",
		},
		WORMHOLE =
		{
			GENERIC = "Nydus Worm?",
			OPEN = "Really, creepy.",
		},
		WORMHOLE_LIMITED = "Guh, that thing looks worse off than usual.",
		ACCOMPLISHMENT_SHRINE = "It won't go forever.",        
		LIVINGTREE = "Why? That's completly normal!",
		ICESTAFF = "Better be freezing it well than Chirno.",
		
        FLOTSAM = "Some of them must be a special.",

        SUNKEN_BOAT = {
            GENERIC = "He have something to do for me.",
            ABANDONED = "Maybe I can chase him?",
        },
        SUNKEN_BOAT_BURNT = "It burnt.",
   		SUNKEN_BOAT_TRINKET_1 = "I don't have to use this for distance computation.", --sextant
		SUNKEN_BOAT_TRINKET_2 = "Toy for children.", --toy boat
		SUNKEN_BOAT_TRINKET_3 = "Is this usable actually?", --candle
		SUNKEN_BOAT_TRINKET_4 = "Ingredient for another world-linker", --sea worther
		SUNKEN_BOAT_TRINKET_5 = "Common fishing trash.", --boot

		HOUNDFIRE = "It's hot! be careful!",

		ANTIVENOM = "This can be a venom or an antivenom.",
		VENOMGLAND = "It's a poison to cure poison.",
		BLOWDART_POISON = "Another ragned weapon!",
		OBSIDIANMACHETE = "It's a thermal tool.",
		SPEARGUN_POISON = "Target will be dead with agony.",
		OBSIDIANSPEARGUN = "It's more like 'cursed fire'",
		LUGGAGECHEST = "Floated inventory",
		PIRATIHATITATOR =
		{
			GENERIC = "Ingredients for magic is just poor now.",
			BURNT = "It burnt",
		},
		COFFEEBEANS = "I can't smell yet.",
		COFFEE = "mhhmm.. This is it.",
		COFFEEBEANS_COOKED = "Now I can smell them!",
		COFFEEBUSH =
		{
			BARREN = "It needs to be fertilized.",
			WITHERED = "Heat broke this.",
			GENERIC = "It's more like Rafflesia.",
			PICKED = "It will regrow in 4 days.",
		},
		COFFEEBOT = "It produces coffee.",
		MUSSEL = "Why it reduces sanity by eating raw?",
		MUSSEL_FARM =
		{
			 GENERIC = "No Vibrio cholerae detected",
			 STICKPLANTED = "It will take some time."
		},

		MUSSEL_STICK = "Mussels will stick to here.",
		LOBSTER = "Robbed Lobster.",
		LOBSTERHOLE = "That's a lobster.",
		SEATRAP = "To rob lobster.",
		SAND_CASTLE =
		{
			SAND = "It's so childish.",
			GENERIC = "It's so childish."
		},
		BOATREPAIRKIT = "How can it be made??",

		BALLPHIN = "It's small and cute!",
		BOATCANNON = "I want to do war at sea.",
		BOTTLELANTERN = "Too conventional.",
		BURIEDTREASURE = "Is that for fermentation?",
		BUSH_VINE =
		{
			BURNT = "It burnt",
			CHOPPED = "It will regrow in 4 days.",
			GENERIC = "Some of them hide snakes.",
		},
		CAPTAINHAT = "This reminds me about Kantai C....",
		COCONADE =
		{
			BURNING = "Don't test my defensive power.",
			GENERIC = "It needs to be lighted to explode.",
		},
		CORAL = "Living CaCO3",
		CORALREEF = "Abundance of planktons",
		CRABHOLE = "It's a crab hole.",
		CUTLASS = "Deadly knife",
		DUBLOON = "Let's make a deal.",
		FABRIC = "Natural woody fabric.",
		FISHINHOLE = "Lots of planktons are here.",
		GOLDENMACHETE = "It's a golden machete.",
		JELLYFISH = "Scyphozoa Creature.",
		JELLYFISH_PLANTED = "How do I explain it?",
		JELLYJERKY = "Unpleasantly tough.",

		LIMPETROCK =
		{
			GENERIC = "Source of cholera.",
			PICKED = "It will replenish in 3 days.",
		},
		LOGRAFT = "It can barely be floated.",
		MACHETE = "To cut vines",
		MESSAGEBOTTLEEMPTY = "It will be meaningful by put something in it.",
		MOSQUITO_POISON = "Good example of spread of disaster.",
		OBSIDIANCOCONADE = "The fragment after exploding will let them death.",
		OBSIDIANFIREPIT = "Efficient firepit.",
		OX = "Ew, smell",
		PIRATEHAT = "Who wanna be a sea king?",
		RAFT = "Better than log one.",
		ROWBOAT = "It needs to be rowed. I hate it.",
		SAIL = "No more rowing Yeah!",
		SANDBAG_ITEM = "To avoid flooding",
		SANDBAG = "To avoid flooding",
		SEASACK = "Natural styrofoam",
		SEASHELL_BEACHED = "Bivalvia organism",
		SEAWEED = "The soup of this is delicious.",

		SEAWEED_PLANTED = "That's some seaweed.",
		SLOTMACHINE = "Gambling is disease.",
		SNAKE_POISON = "It has poison.",
		SNAKESKIN = "It's tough.",
		SNAKESKINHAT = "Tough hat",
		SOLOFISH = "Who let the Doge out?",
		SPEARGUN = "It's like musket",
		SPOILED_FISH = "Abandoned Fish",
		SWORDFISH = "Look at that knify beak.",
		TRIDENT = "It's for hand-to-hand combat.",
		TRINKET_13 = "For some reason, I won't open this.",
		TRINKET_14 = "Don't let it break.",
		TRINKET_15 = "It's a white bishop.",
		TRINKET_16 = "IT's a black bishop.", -- #TODO: Why is this here?
		TRINKET_17 = "Valuable trash",
		TRINKET_18 = "Well, it's already broken.",
		TRINKET_19 = "Suspicious Pill", -- #TODO: What is this?
		TURBINE_BLADES = "Surprisingly, It's plastic.",
		TURF_BEACH = "A chunk of ground.",
		TURF_JUNGLE = "A chunk of ground.",
		VOLCANO_ALTAR = --#T
		{
			GENERIC = "Entrance of Volcano",
			OPEN = "The altar is ready.",
		},
		VOLCANO_ALTAR_BROKEN = "Can be fixed",
		WHALE_BLUE = "That I know about whale face is always happy..",
		WHALE_CARCASS_BLUE = "I can hack it with machete.",
		WHALE_CARCASS_WHITE = "I can hack it with machete.",

		ARMOR_SNAKESKIN = "It's like a gent's hat.",
		CLOTHSAIL = "Bamboo sail.",
		DUG_COFFEEBUSH = "Definitely, It's a rafflecia..",
		LAVAPOOL = "It's a spicy soup.",
		BAMBOO = "Its Emptiness of stem means honesty.",
		AERODYNAMICHAT = "The man who lives above the ground will see me as a shark.",
		POISONHOLE = "Smells suck!",
		BOAT_LANTERN = "Essencial item for sailing.",
		DEAD_SWORDFISH = "Its beak looks useful.",
		LIMPETS = "It is recommended to eat after cook.",
		JELLYFISH_COOKED = "Orange Onion-ring.",
		OBSIDIANAXE = "It's a thermal tool.",
		COCONUT = "I can't hack it with my hands.",
		COCONUT_COOKED = "It heals 9.375 of hunger.",
		BERMUDATRIANGLE = "It's like Bermuda Triangle.",
		SNAKE = "Cut his neck!",
		SNAKEOIL = "What is this for?'",
		ARMORSEASHELL = "Bivalvia Armor",
		SNAKE_FIRE = "Is that snake smoldering?",
		MUSSEL_COOKED = "It should be in noodles.",

		PACKIM_FISHBONE = "It's not a.. normal fish rot.",
		PACKIM = "Flying Inventory!",

		ARMORLIMESTONE = "What a ugly armor",
		TIGERSHARK = "How do they make kind of like this terrible syncytial creature?",
		WOODLEGS_KEY1 = "It's a key for releasing someone.",
		WOODLEGS_KEY2 = "It's a key for releasing someone.",
		WOODLEGS_KEY3 = "It's a key for releasing someone.",
		WOODLEGS_CAGE = "That is the 'someone' who I have to release.",
		OBSIDIAN_WORKBENCH = "It's a hot-bench.",

		NEEDLESPEAR = "It's not that hard but extreamly sharp.",
		LIMESTONE = "Many artical masterpiece have been made of this.",
		DRAGOON = "You aren't a four-legged, huh?",

		ICEMAKER = {
			OUT = "It needs more fuel.",
			VERYLOW = "It's quite slowed.",
			LOW = "Its pace is dropping.",
			NORMAL = "He does work great so far.",
			HIGH = "He's working greatly.",
		},

		DUG_BAMBOOTREE = "I need to plant this.",
		BAMBOOTREE =
		{
			BURNT = "It burnt",
			CHOPPED = "I think it will regrow in 4 days.",
			GENERIC = "It's empty inside.",
		},
		JUNGLETREE =
		{
			BURNING = "Combustion",
			BURNT = "It burnt",
			CHOPPED = "Why I feel shortage?",
			GENERIC = "Tropical trees are such a tall like this.",
		},
		SHARK_GILLS = "Isn't it a tiger skin?",
		OBSIDIAN = "Well, It's not a black.",
		BABYOX = "It's a tiny meat beast.",
		STUNGRAY = "Beware of poisoness!",
		SHARK_FIN = "Holy, I just cut his entire fin!",
		FROG_POISON = "Be Careful!",
		ARMOUREDBOAT = "It's a boat against waves.",
		ARMOROBSIDIAN = "I think it's softer than wood.",
		BIOLUMINESCENCE = "unrealistic. But Beautiful.",
		SPEAR_POISON = "What a efficient weapon.",
		SPEAR_OBSIDIAN = "It's a thermal weapon.",
		SNAKEDEN =
		{
			BURNT = "It burnt.",
			CHOPPED = "It chopped.",
			GENERIC = "Snakes are inside.",
		},
		TOUCAN = "He's actually carnivorous bird.",
		MESSAGEBOTTLE = "Real treasure map!",
		SAND = "Some Mixtures of Si, SiO2, NaCl..",
		SANDHILL = "It's a mountain. Only for the small.",
		PEACOCK = "It's a both P. Muticus and P. cristatus.",
		VINE = "Durable twig.",
		SUPERTELESCOPE = "Though lens arrangement isn't optimized",
		SEAGULL = "Looks Fat! Don't pee!",
		SEAGULL_WATER = "Looks Fat! Don't pee!",
		PARROT = "He's taunting me",
		ARMOR_LIFEJACKET = "Even I need this because I can't swin forever.",
		WHALE_BUBBLES = "Giant Beast is under water.",
		EARRING = "Nice accessory!",
		ARMOR_WINDBREAKER = "I really like its color.",
		SEAWEED_COOKED = "Nothing different with lavers.",
		CARGOBOAT = "It has a weird-red part.",
		GASHAT = "Most weird thing ever",
		ELEPHANTCACTUS = "What an agressive plant!",
		DUG_ELEPHANTCACTUS = "You. are under controlled.",
		ELEPHANTCACTUS_ACTIVE = "Watch out for spikes!",
		ELEPHANTCACTUS_STUMP = "They're charging spikes.",
		FEATHERSAIL = "Sail with feather-light!",
		WALL_LIMESTONE_ITEM = "It's sad that I can't make such a masterpiece.",
		JUNGLETREESEED = "",
		VOLCANO = "I can climb up there.",
		IRONWIND = "Industrial revolution!",
		SEAWEED_DRIED = "I want seaweed soup!",
		TELESCOPE = "A clairvoyant",
		
		DOYDOY = "What exactly are you supposed to be?",
		DOYDOYBABY = "Cute, At least..",
		DOYDOYEGG = "Dumbs Egg.",
		
		DOYDOYEGG_CRACKED = "Wut",
		DOYDOYFEATHER = "Gently soft..",
		DOYDOYNEST = "Maybe I should leave this alone for a while.",

		PALMTREE =
		{
			BURNING = "Combustion",
			BURNT = "It burnt.",
			CHOPPED = "It cut.",
			GENERIC = "Watch out for palms falling",
		},
		PALMLEAF = "What a large leaf, might be useful.",
		CHIMINEA = "Windproof pit",
		DOUBLE_UMBRELLAHAT = "I didn't know that the eye is that tough.",
		CRAB = {
			GENERIC = "Holy Crab!",
			HIDDEN = "Ah, Crab!",
		},
		TRAWLNET = "Catch the fishes!",
		TRAWLNETDROPPED = {
			SOON = "It is definitely sinking.",
			SOONISH = "I think it's sinking.",
			GENERIC = "Let it be sinked.",
		},
		VOLCANO_EXIT = "It's an exit.",
		SHARX = "That remind me about Jaws.",
		SEASHELL = "Murasa liked this.",
		WHALE_BUBBLES = "Giant Beast is under water.",
		MAGMAROCK = "Dig it!",
		MAGMAROCK_GOLD = "Something gold is in here.",
		CORAL_BRAIN_ROCK = "Are you a wise tree?",
		CORAL_BRAIN = "Holy, It's too creepy!",
		SHARKITTEN = "How do they make kind of like this terrible syncytial creature?",
		SHARKITTENSPAWNER = 
		{
			GENERIC = "I can hear cat thingy sound.",
			INACTIVE = "It's a something special.",
		},
		LIVINGJUNGLETREE = "It's Completely Normal",
		WALLYINTRO_DEBRIS = "Part of a wrecked ship.",
		MERMFISHER = "How creepy",
        
        PRIMEAPE = "You better not do anything suspicious.",
        PRIMEAPEBARREL = "(sigh)",

        REDBARREL = "You obviously wanna break this. YOU.",
        PORTAL_SHIPWRECKED = "It's completely broken.",

		MARSH_PLANT_TROPICAL = "",

		TELEPORTATO_SW_POTATO = "It's a ingredient for something.",
		PIKE_SKULL = "Ouch.",
		PALMLEAF_HUT = "Looks good for taking break.",
		FISH_RAW_SMALL_COOKED = "And now it's eaty.",
		LOBSTER_DEAD = "hmm, yummy.",
		MERMHOUSE_FISHER = "....",
		WILDBOREGUARD = "He's aggressive.",
		PIRATEPACK = "Worn to earn.",
		TUNACAN = "Who can can can?",
		MOSQUITOSACK_YELLOW = "Dirty.",
		SANDBAGSMALL = "Prevent from flooding!",
		FLUP = "Get the heck out of me!",
		OCTOPUSKING = "Can I touch your skin?",
		OCTOPUSCHEST = "Unknown Reward.",
		GRASS_WATER = "Watered grass.",
		WILDBOREHOUSE = "That's a.. house!",
		FISH_RAW_SMALL = "Take it before it rot",
		TURF_SWAMP = "A chunk of ground.",
		FLAMEGEYSER = "Keep distance",
		KNIGHTBOAT = "You better be get out of me.",
		MANGROVETREE_BURNT = "I wonder how that happened.",
		TIDAL_PLANT = "It's a tidal Plant",
		WALL_LIMESTONE = "It'a wall",
		FISH_RAW = "A chunk of fish meat.",
		LOBSTER_DEAD_COOKED = "Let's just eat this",
		JELLYFISH_DEAD = "x_x",
		BLUBBERSUIT = "It's like guts. yuck",
		BLOWDART_FLUP = "Eye see.",
		TURF_MEADOW = "A chunk of ground.",
		TURF_VOLCANO = "A chunk of ground.",
		SWEET_POTATO = "Kyouko?",
		SWEET_POTATO_COOKED = "Cooked Kyouko.",
		SWEET_POTATO_PLANTED = "That's a Kyouko!",
		SWEET_POTATO_SEEDS = "Seed of Kyouko.",
		BLUBBER = "sigh..",
		TELEPORTATO_SW_RING = "It's like a rotten seaweed",
		TELEPORTATO_SW_BOX = "Looks like a part for something.",
		TELEPORTATO_SW_CRANK = "Tongy broom",
		TELEPORTATO_SW_BASE = "I think this is missing parts.",
		VOLCANOSTAFF = "[Skill] Meteor Strike",
		THATCHPACK = "Leafy inventory",
		TURF_DESERTDIRT = "A chunk of ground.",
		SHARK_TEETHHAT = "Looks dangerous",
		TURF_ASH = "A chunk of ground.",
		TURF_FUNGUS_GREEN = "A chunk of ground.",
		BOAT_TORCH = "This let me stay on ocean.",
		MANGROVETREE = "Salty!",
		HAIL_ICE = "Chirn-y.",
		TROPICAL_FISH = "Typical tropical fish.",
		TIDALPOOL = "I can do fishing.",
		WHALE_WHITE = "You look mad",
		VOLCANO_SHRUB = "Hello? Are you alive?",
		ROCK_OBSIDIAN = "That's.. an obsidian!",
		ROCK_CHARCOAL = "I thought it's an obsidian!",
		DRAGOONDEN = "It isn't a 'Gateway'.",
		WILBUR_UNLOCK = "He looks kind of regal.",
		WILBUR_CROWN = "It's oddly monkey-sized.",

		TWISTER = "Living Tornado!",
		TWISTER_SEAL = "Hey! you..are just..",
		MAGIC_SEAL = "I can feel tons of magical power in here.",
		SAIL_STICK = "Windy Staff!",
		WIND_CONCH = "Tornady staff!",
		DRAGOONEGG = "It's a dragoon egg.",
		BUOY = "Useful mark.", 
		TURF_SNAKESKINFLOOR = "A chunk of ground.",
        DOYDOYNEST = "It's a dumbs nest",

		ARMORCACTUS = "It's a thoornmail.",
		BIGFISHINGROD = "How can such a big thing is in my inventory.",
		BOOK_METEOR = "Oh, I could make this!",
		BRAINJELLYHAT = "I don't want to be provided knowledge by this.",
		COCONUT_HALVED = "It heals 4.6875 of hunger.",
		CRATE = "Check what's inside.",
		DEPLETED_BAMBOOTREE = "It will regrow.",
		DEPLETED_BUSH_VINE = "It will regrow.",
		DEPLETED_GRASS_WATER = "It will regrow.",
		DOYDOYEGG_COOKED = "Look at that 'golk'",
		DRAGOONHEART = "Dragon's heart... wait a minute,",
		DRAGOONSPIT = "Flame saliva",
		DUG_BUSH_VINE = "I need to plant this",
		FRESHFRUITCREPES = "Oh, I could make this!",
		KRAKEN = "Oh,,.. hi?",
		KRAKENCHEST = "It's a typical boss reward!",
		KRAKEN_TENTACLE = "Watch it!",
		MAGMAROCK_FULL = "Dig it!",
		MAGMAROCK_GOLD_FULL = "Something gold is in here.",
		MONKEYBALL = "Dummy ball",
		MONSTERTARTARE = "I don't want to eat this..",
		MUSSELBOUILLABAISE = "It's Bouillabaise",
		MYSTERYMEAT = "Completely Waste",
		OXHAT = "Looks tight!",
		OX_FLUTE = "Rainy melodies..?",
		OX_HORN = "It's an ox horn.",
		PARROT_PIRATE = "You better be say something!",
		PEG_LEG = "Can I hit with this?",
		PIRATEGHOST = "Oh, you're undead too.",
		SANDBAGSMALL_ITEM = "Prevent from flooding!",
		SHADOWSKITTISH_WATER = "You better stay out of me.",
		SHIPWRECKED_ENTRANCE = "",
		SHIPWRECKED_EXIT = "",
		SNAKESKINSAIL = "Tough sail",
		SPEAR_LAUNCHER = "I can't believe this is a gun.",
		SWEETPOTATOSOUFFLE = "Kyouko souffle",
		TIGEREYE = "I hate eyeball.",
		TRINKET_20 = "Why such a scratcher.",
		TRINKET_21 = "It's a broken cooking tool.",
		TRINKET_22 = "Is this worth anything?",
		TURF_FUNGUS_RED = "A chunk of ground.",
		TURF_MAGMAFIELD = "A chunk of ground.",
		TURF_TIDALMARSH = "A chunk of ground.",
		VOLCANO_ALTAR_TOWER = "It's a grand structure.",
		WATERYGRAVE = "Take this!",
		WHALE_TRACK = "It's a whale track!",
		WILDBOREHEAD = "Smells bad.",
		WOODLEGSBOAT = "A vessel fit for a scallywag.",
		WOODLEGSHAT = "Does it make me look scurvy... I mean scary!?",
		WOODLEGSSAIL = "The quintessential pirate sail.",
		WRECK = "I can't fix it",
		INVENTORYGRAVE = "",
        INVENTORYMOUND = "",
		LIMPETS_COOKED = "It smells good",
		RAWLING = "It's weird.",
		
		CREAWLINGNIGHTMARE = "Reincarnation. Your existence is unlimited.",
		NIGHTMAREBEAK = "Reincarnation. Your existence is unlimited.",
		CRAWLINGHORROR = "Improbitas. Licks human of greed.",
		TERRORBEAK = "Damnatio. Your execution is brutal.",
		SWIMMINGHORROR = "Sailing the Virgin Oceans. You know the way, huh?",
		SHADOWWATCHER = "Espinaje. What are you spying?",
		SHADOWSKITTISH = "Unexpected. You, are not intended.",
		SHADOWSKITTISH_WATER = "Viscidus. You are the scrap.",
		CREEPYEYES = "Superintentor. But you can't see inside.",
		SCHEMETOOL = "I've made this for the other one.",
	},

	-- CHARACTER SPECIFIC DESCRIPTION

	DESCRIBE_GENERIC = "I don't even know about this.",
	DESCRIBE_TOODARK = "It's BLACK!",
	DESCRIBE_SMOLDERING = "That thing is about to catch fire.",
	DESCRIBE_LOWPOWER = "I don't have enough power!",
	DESCRIBE_NOSKILL = "I have no skills.",
	DESCRIBE_INVINCIBILITY_DURATION = "Invisible duration has been increased.",
	DESCRIBE_CLOAKING = "They don't know where I am.",
	DESCRIBE_DECLOAKING = "I'm not invisible anymore!",
	DESCRIBE_CANNOTRESIST = "I can't resist more if I do this.",
	DESCRIBE_NOREINFORCE = "I'm not reinforced anymore!",
	DESCRIBE_EYEHURT = "Ouch! My eyes!",
	DESCRIBE_DONEEFFCT = "The effect has over.",
	DESCRIBE_NOSPAWN = "I can't spawn.",
	DESCRIBE_TOOMANYBUTTER = "I think It's enough..?",
	DESCRIBE_ABILITY_ALREADY = "I already have this ability.",
	DESCRIBE_HATUPGRADE = "Hat Upgraded",
	DESCRIBE_NOHANDED = "I should bring something on my hand.",
	DESCRIBE_DONEUPGRADE = "\nUpgrade Finished",
	DESCRIBE_INVINCIBILITY_ACTIVATE = "INVINCIBILITY Activated",
	DESCRIBE_INVINCIBILITY_DONE = "I'm no longer invincible.",
	DESCRIBE_UPGRADE_FREE = "\nFree to Upgrade",
	DESCRIBE_UPGRADE_HEALTH = "My heart is mighter.",
	DESCRIBE_UPGRADE_HUNGER = "My Stomach is tougher",
	DESCRIBE_UPGRADE_SANITY = "Things are getting.. fresh!",
	DESCRIBE_UPGRADE_POWER = "I can feel my inner power is getting grown.",
	DESCRIBE_INGREDIENTS = "I don't have enough Ingredients.",
	DESCRIBE_LOWLEVEL = "I must reach %s level to %s",

	ONULTIMATE = {
		"I can now evade death..",
		"Now I have power of TheWorld.",
		"The world is beginning to show with new sights.",
		"Yes... this is my power I had."
	},

	ONULTIMATESW = {
		"I changed my destiny myself...",
		"Everythings are... DESTROYABLE.",
		"This, is the power who my friend had...",
		"Yes... this is my power I had."
	},

	ONEATHUMAN = {
		"...Youkai's basic instinct.",
		"...This is really.. fresh",
		"...Really delicious",
	},

	NECRO = {
		"美しく残酷にこの大地から往ね！",
		"You were nothing but a piece of paper...",
		"Go rest in the void..",
		"You were just nothing..",
	},

	LAMENT_B = {
		"Oops",
		"Oh, this is not good.",
		"What is this?!",
		"What? wait,"
	},

	LAMENT_H = {
		"I'll never do this again!",
		"What the f..",
		"What the,",
		"Oh, no.",
		"Ahh!!",
	},

	TAUNT = {
		"I'll set you free, if you win.",
		"Hey! You wanna go?",
		"Get taunted, mortals!",
	},

	NEWSIGHT = {
		"No one can hide from my sight.",
		"Knowing everything on the present.",
		"You shall not hit me, the darkness.",
	},

	NODANGERSCHEME = "I can't concentrate right now!",
}