extends AnimatedSprite2D

@export var chirp_delay_variance_sec: Vector2 = Vector2(0.5, 1)
@export var perch_seated_distance_px: int = 3
@export_range(0,1) var additional_chirp_chance_percent: float = 0.25
@export var chill_time_sec: float = 2.0
@export var chill_time_variance: float = 0.25
@export var despawn_time_sec: float = 20.0

# child components
@onready var bird_movement_component: BirdMovementComponent = $BirdMovementComponent
@onready var bird_animation_component: Node = $BirdAnimationComponent
@onready var bird_area: Area2D = $BirdArea
@onready var chirp_sound: SingleSoundComponent = $ChirpSound
# timers
@onready var chirp_timer: Timer = $ChirpTimer
@onready var chill_timer: Timer = $ChillTimer
@onready var despawn_timer: Timer = $DespawnTimer

var direction: String = "left"
var state: String

func _ready() -> void:
	bird_movement_component.perch_finished.connect(_on_perch_finished)
	bird_movement_component.takeoff_finished.connect(_on_takeoff_finished)
	bird_animation_component.chirp_finished.connect(_on_chirp_finished)
	bird_area.area_entered.connect(_on_bird_area_entered)
	chirp_timer.timeout.connect(_on_chirp_timer_timeout)
	chill_timer.timeout.connect(_on_chill_timer_timeout)
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	fly()

## -- state management --
func fly() -> void:
	state = "flying"

func land(perch: Node2D) -> void:
	state = "landing"
	bird_movement_component.perch = perch

func perched() -> void:
	state = "idle"
	var random_wait_time: float = randf_range(
		chirp_delay_variance_sec.x,
		chirp_delay_variance_sec.y
	)
	chirp_timer.wait_time = random_wait_time
	chirp_timer.start()

func chirp() -> void:
	state = "chirping"
	chirp_sound.play_sound()

func chill() -> void:
	state = "idle"
	var rand_chill_time: float = randf_range(
		chill_time_sec - (chill_time_sec * chill_time_variance),
		chill_time_sec + (chill_time_sec * chill_time_variance)
	)
	chill_timer.start(rand_chill_time)

func take_off() -> void:
	state = "takeoff"
	despawn_timer.start(despawn_time_sec)

## -- signals --
func _on_bird_area_entered(area: Area2D) -> void:
	var perch: Node2D = area.get_parent()
	if not perch.is_occupied():
		land(perch)

func _on_perch_finished() -> void:
	perched()

func _on_chirp_timer_timeout() -> void:
	chirp()
	
func _on_chirp_finished() -> void:
	state = "idle"
	var rng: float = randf_range(0, 1)
	if rng <= additional_chirp_chance_percent:
		perched()
	else:
		chill()

func _on_chill_timer_timeout() -> void:
	take_off()

func _on_takeoff_finished() -> void:
	fly()

func _on_despawn_timer_timeout() -> void:
	queue_free()
