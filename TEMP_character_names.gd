var sweat_names: Array[String] = [
	"ParseDaddy",
	"BiSOrBust",
	"NoWipesAllowed",
	"MinMaxMatt",
	"ChartTopperCharles",
	"GearScoreGary",
	"PrePotPete",
	"ZeroMistakes",
	"WorldFirst",
	"HardcoreHank",
	"TryhardTrevor"
]

var dad_names: Array[String] = [
	"BackPainBob",
	"GrillMasterGreg",
	"BowlingNightBill",
	"CargoShortsCarl",
	"FishingFrank",
	"LawnMowerLarry",
	"WeekendWarriorWalt",
	"HoneyDoHank",
	"DIYDoug",
	"SteakSearSam"
]

var simp_names: Array[String] = [
	"Sub4Sakura",
	"HealzForHer",
	"UwUProtector",
	"Pay2WinHerHeart",
	"OnlyTanks",
	"WhiteKnightIRL",
	"ModInHerChat",
	"DMsAreOpen",
	"Tier3Sub",
	"ThirstyPaladin",
	"CuddleCleric",
	"WaifuWallet"
]

var twitch_streamer_names: Array[String] = [
	"LootLordTV",
	"CritDaddyTV",
	"DPSDanTV",
	"HotDropHankTV",
	"PatchNotePeteTV",
	"TradeChatTonyTV"
]

var egirl_names: Array[String] = [
	"AriaUwU",
	"xxLunaBabyxx",
	"PastelPixie",
	"KittenOfDoom",
	"SakuraSlay",
	"VelvetVamp",
	"BunniBoo",
	"GothGFIRL",
	"AngelBitez",
	"Nyxie",
	"VoidKitten",
	"HexxieHeart",
	"DreamDoll"
]

var cringe_names: Array[String] = [
	"xxSephiroth420xx",
	"NarutoSasukeLove69",
	"BloodzKillaBoi",
	"UwUHealzMeSenpai",
	"XxShadowLuvr69xX",
	"LegolasGFPlz",
	"DankMemerMage",
	"HotAnimeWaifu",
	"FurryDragonLord",
	"XxXNoScopeElfXxX",
	"DarkSoulzDaddy",
	"420BlazeElf",
	"YoloTankPro",
	"EpicGamerUwU",
	"Over9000Power",
	"NarutoRunMage",
	"KawaiiSlayer666",
	"XoXoPallyPrincessXoXo",
	"LinkinParkMage",
	"FinalBossBae"
]

var serious_names: Array[String] = [
	"ArdentVale",
	"Seraphion",
	"Thalorin",
	"Kaelwyn",
	"Shadowbrook",
	"Lyssandra",
	"Veynar the Hollow",
	"Oathforged",
	"Mournveil",
	"Elyndor"
]

var funny_names: Array[String] = [
	"LootGoblin69",
	"MomSaidPause",
	"KeyboardTurner",
	"CritOrQuit",
	"MountMePlz",
	"TreeHuggerIRL",
	"StabMcStabby",
	"AFKandBaking",
	"DeleteMyHistory",
	"GuildTaxEvader",
	"TradeChatPhilosopher",
	"BuffBotBenny",
	"LootLoverLarry"
]

var reference_names: Array[String] = [
	"GandalfTheBae",
	"ObiWanAFKobi",
	"ShrekOnCooldown",
	"LaraCroftFan420",
	"PikachuTank",
	"Legolast",
	"NotACylon",
	"RickRolled",
	"KratosGotDadBod",
	"JojoStandUser"
]

var edgy_names: Array[String] = [
	"Xx_DarkSlayer_xX",
	"VoidEater",
	"Bloodcrypt",
	"SoulReaper666",
	"Chaos.exe",
	"CorpseCollector",
	"VenomFang",
	"Deathhug",
	"NightmareBoi",
	"EmoMage"
]

var absurd_names: Array[String] = [
	"PancakePaladin",
	"FishWithLegs",
	"LegalizePotions",
	"HorseWizard",
	"HotdogKnight",
	"SpoonInTheStone",
	"GiraffeCleric",
	"ToasterOfDoom",
	"DuckPalpatine",
	"BagOfRats"
]

# jakes
var derp_names: Array[String] = [
	"HorsePants",
	"BagelWizard",
	"SoupOnKeyboard",
	"ChairAggro",
	"GnomeBoi420",
	"Lvl1BankAlt",
	"SpankTank",
	"DuckInBoots",
	"PunchingAirIRL",
	"FarticusMaximus",
	"MountStuckAgain",
	"PotatoMode",
	"Dance4Healz",
	"WrongSpellLOL"
]


var names = [
	sweat_names,
	dad_names,
	simp_names, 
	twitch_streamer_names, 
	egirl_names, 
	cringe_names, 
	serious_names, 
	funny_names, 
	reference_names, 
	edgy_names, 
	absurd_names, 
	derp_names
]

# Spawn logic - maximums
# sweats - 1
# jakes - 1
# rpers - 2
# funny - 2
# rare - 1

# original group - branches out and recruits more people
# issue - players refreshing to get optimal team
# top 5 picked for invasion ( balance team (no stacking))
# griefers LOL - have characters come in and fuck shit up 
# vote to kick/ban
# make a quest to find grieferLMAO
# resouce specific tab for inv (Guild Wars)

# What do NPCs do in the Neutral game?
# - farm resource
# - kill mobs
# - fish
# hang out / RP - tavern 
# sell to the junk trader

# different cosmetics / crafting stations (meta progression)


var commons = [
	
]

var rares = [
	
]



func get_random_name() -> String:
	var random_set: Array[String] = names.pick_random()
	var random_name: String = random_set.pick_random()
	return random_name
