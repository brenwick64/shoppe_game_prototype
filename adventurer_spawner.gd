extends Node2D

var adventurer_spritesheet_rg: ResourceGroup = preload("res://resources/resource_groups/rg_adventurer_spritesheets.tres")

@export var adventurer_scene: PackedScene
@onready var creation_data: Node = $CreationData

var adventurers: Node2D

var spritesheet_arr: Array[Texture]
var debug_spawn_count: int = 0

func _ready() -> void:
	var adventurers_node: Node2D = get_tree().get_first_node_in_group("adventurers")
	if not adventurers_node:
		push_error("error: adventurers node not found in scene tree.")
	adventurers =adventurers_node
	adventurer_spritesheet_rg.load_all_into(spritesheet_arr)

func _spawn_adventurer(global_pos: Vector2) -> void:
	var adventurer_ins: Adventurer = adventurer_scene.instantiate()
	adventurer_ins.animated_sprite.character_spritesheet_texture = spritesheet_arr.pick_random()
	adventurer_ins.global_position = global_pos
	var random_name: String = creation_data.get_random_name()
	adventurer_ins.adventurer_name = random_name
	adventurers.add_child(adventurer_ins)

func _on_timer_timeout() -> void:
	var random_gp: Vector2 = global_position + Vector2(randi_range(-150, 150), randi_range(-65, 65))
	var ground_layers = GlobalTileManager.get_tilemap_layers_by_tag("ground")
	var spawn_point = GlobalTileManager.get_adjacent_ground_tiles_gp(
		random_gp, 
		"Grass",
		["navigatable"])
	if not spawn_point: return
	if debug_spawn_count > 5: return
	_spawn_adventurer(spawn_point[0])
	debug_spawn_count += 1
