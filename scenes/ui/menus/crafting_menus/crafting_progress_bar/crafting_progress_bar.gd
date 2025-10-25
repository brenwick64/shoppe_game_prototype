class_name CraftingProgressBar
extends Control

signal finished(recipe: RRecipe)

@onready var cog_wheel: TextureRect = $CogWheel
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var craft_timer: Timer = $CraftTimer

@export var cog_rotation_speed: float = 180.0 # degrees per second

var is_running: bool = false
var crafting_time_sec: float = 1.0

var _current_recipe: RRecipe
var _cog_angle: float = 0.0


## -- public methods --
func start(p_crafting_time_sec: float, recipe: RRecipe) -> void:
	crafting_time_sec = p_crafting_time_sec
	craft_timer.start(crafting_time_sec)
	_current_recipe = recipe
	progress_bar.value = 0
	is_running = true
	visible = true


## -- overrides --
func _physics_process(delta: float) -> void:
	if not is_running: return
	var elapsed_time_percentage: float = (crafting_time_sec - craft_timer.time_left) / crafting_time_sec
	progress_bar.value = elapsed_time_percentage * 100
	_spin_cog(delta)
	if elapsed_time_percentage == 1:
		_finish()


## -- helper functions --
func _spin_cog(delta: float) -> void:
	_cog_angle += cog_rotation_speed * delta
	_cog_angle = fmod(_cog_angle, 360.0)
	cog_wheel.rotation_degrees = _cog_angle

func _finish() -> void:
	finished.emit(_current_recipe)
	visible = false
	is_running = false
	progress_bar.value = 0
	_current_recipe = null
