class_name Adventurer 
extends CharacterBody2D

@export var walk_speed: float = 25.0

@export var animated_sprite: AnimatedSprite2D
@export var adventurer_name: String

@onready var state_machine: NodeStateMachine = $StateMachine
@onready var name_label: Label = $NameLabel
@onready var debug_current_state: Label = $DebugCurrentState

var direction_name: String = "down"

func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	name_label.text = "<" + adventurer_name + ">"
	GlobalMessageManager.add_message("INFO", adventurer_name + " has entered the game")

func _on_state_changed(state: String) -> void:
	debug_current_state.text = state
