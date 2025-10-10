extends Node2D

var adventurer_personas_rg: ResourceGroup = preload("res://resources/resource_groups/rg_adventurer_personas.tres")

@export var max_adventurers: int = 2
@export var adventurer_scene: PackedScene

var adventurers: Node2D
var adventurer_personas: Array[RAdventurerPersona]

var _spawned_adventurers: Array[Adventurer]
var _spawn_count: int = 0


## -- overrides --
func _ready() -> void:
	var adventurers_node: Node2D = get_tree().get_first_node_in_group("adventurers")
	if not adventurers_node:
		push_error("error: adventurers node not found in scene tree.")
	adventurers = adventurers_node
	adventurer_personas_rg.load_all_into(adventurer_personas)


## -- public methods --
func spawn_adventurer(global_pos: Vector2) -> void:
	var persona: RAdventurerPersona = _get_new_persona()
	var adventurer_template: Adventurer = adventurer_scene.instantiate()
	var spritesheet: Texture = persona.get_random_spritesheet()
	adventurer_template.adventurer_name = persona.get_new_name(_spawned_adventurers)
	adventurer_template.animated_sprite.character_spritesheet_texture = spritesheet
	adventurer_template.adventurer_persona = persona
	adventurer_template.global_position = global_pos
	# add adventurer
	_spawned_adventurers.append(adventurer_template)
	adventurers.add_child(adventurer_template)


## -- helper functions --
func _get_new_persona() -> RAdventurerPersona:
	var persona_counts: Array[Dictionary] = _tally_persona_counts()
	persona_counts.shuffle()
	
	var lowest_persona: RAdventurerPersona
	var lowest_count: int = Constants.MAX_INT_VALUE
	for rank: Dictionary in persona_counts:
		if rank["count"] < lowest_count:
			lowest_persona = rank["persona"]
			lowest_count = rank["count"]
	return lowest_persona

func _tally_persona_counts() -> Array[Dictionary]:
	var persona_counts: Array[Dictionary] = []
	for persona: RAdventurerPersona in adventurer_personas:
		var count: int = 0
		for adventurer: Adventurer in _spawned_adventurers:
			if adventurer.adventurer_persona == persona: 
				count += 1
		var rank: Dictionary = { "persona": persona, "count": count }
		persona_counts.append(rank)
	return persona_counts


## -- signals --
func _on_timer_timeout() -> void:
	#TODO: swap this out with actual spawn point
	var random_gp: Vector2 = global_position + Vector2(randi_range(-150, 150), randi_range(-65, 65))
	var spawn_point = GlobalTileManager.get_adjacent_ground_tiles_gp(
		random_gp, 
		"Grass",
		["navigatable"])
	if not spawn_point: return
	if _spawn_count >= max_adventurers: return
	spawn_adventurer(spawn_point[0])
	_spawn_count += 1
