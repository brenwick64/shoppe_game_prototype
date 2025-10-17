class_name Player
extends CharacterBody2D

@export var player_name: String

@export var player_input_component: PlayerInputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var movement_sound: MovementSoundComponent

@onready var pickup_sound: OneShotSoundComponent = $PickupSound
@onready var interactor: Interactor = $Interactor
@onready var inventory_manager: InventoryManager = $InventoryManager
@onready var currency_manager: CurrencyManager = $CurrencyManager
@onready var name_label: Label = $NameLabel


var _current_terrain: String

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	GlobalMessageManager.add_console_message("INFO", player_name + " has entered the game")
	name_label.text = "<" + player_name + ">"


## -- public methods --
func pickup(item_id: int, count: int) -> void:
	pickup_sound.play_sound()
	inventory_manager.inventory.add_item(item_id, count)
	
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	GlobalMessageManager.add_console_message(
		"DEBUG",
		"picked up " + str(count) + " x " + item_data.item_name
	)


## -- overrides --
func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = player_input_component.get_input_direction()
	animation_component.handle_movement(input_direction, delta)
	movement_component.handle_movement(input_direction, delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		interactor.interact()


## -- helper functions --
func _check_tile_audio() -> void:
	# get all ground layers
	var layers: Array[TileMapLayer] = GlobalTileManager.get_tilemap_layers_by_tag("ground")
	if not layers: return
	# iterate through each layer, replacing the type until the highest terrain is selected
	var terrain_type: String = ""
	for layer: TileMapLayer in layers:
		var terrain: String = GlobalTileManager.get_tile_custom_metadata(
			layer, 
			global_position, 
			"terrain_type"
		)
		if terrain != "":
			terrain_type = terrain
	# if the type changes, switch track, and re-loop
	if terrain_type != _current_terrain:
		var new_tracks: Array[RAudioStreamData] = GlobalAudioManager.get_movement_audio_tracks("move_" + terrain_type)
		if not new_tracks:
			push_error("Player error: no movement sound found.")
			return
		movement_sound.switch_tracks(new_tracks)
		_current_terrain = terrain_type

	
## -- signals --
func _on_animation_component_animation_state_changed(state: String) -> void:
	if state == "moving":
		movement_sound.play_loop()
	elif state == "idle":
		movement_sound.stop_loop()

func _on_movement_component_moveable_moved(_new_position: Vector2) -> void:
	_check_tile_audio()
	interactor.handle_parent_movement()
