extends Node2D

var adventurer_personas_rg: ResourceGroup = preload("res://resources/resource_groups/rg_adventurer_personas.tres")

@export var adventurer_scene: PackedScene

var adventurers: Node2D
var adventurer_personas: Array[RAdventurerPersona]
# TODO:
var debug_spawn_count: int = 0

func _ready() -> void:
	var adventurers_node: Node2D = get_tree().get_first_node_in_group("adventurers")
	if not adventurers_node:
		push_error("error: adventurers node not found in scene tree.")
	adventurers = adventurers_node
	adventurer_personas_rg.load_all_into(adventurer_personas)

func _spawn_adventurer(global_pos: Vector2) -> void:
	var persona: RAdventurerPersona = adventurer_personas.pick_random()
	var adventurer_template: Adventurer = adventurer_scene.instantiate()
	var spritesheet: Texture = persona.get_random_spritesheet()
	adventurer_template.animated_sprite.character_spritesheet_texture = spritesheet
	adventurer_template.adventurer_persona = persona
	adventurer_template.adventurer_name = persona.get_random_name()
	adventurer_template.global_position = global_pos
	adventurers.add_child(adventurer_template)

func _on_timer_timeout() -> void:
	var random_gp: Vector2 = global_position + Vector2(randi_range(-150, 150), randi_range(-65, 65))
	var ground_layers = GlobalTileManager.get_tilemap_layers_by_tag("ground")
	var spawn_point = GlobalTileManager.get_adjacent_ground_tiles_gp(
		random_gp, 
		"Grass",
		["navigatable"])
	if not spawn_point: return
	if debug_spawn_count > 10: return
	_spawn_adventurer(spawn_point[0])
	debug_spawn_count += 1
