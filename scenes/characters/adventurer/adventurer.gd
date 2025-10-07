class_name Adventurer 
extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var chat_manager: ChatManager
@export var adventurer_name: String
@export var adventurer_persona: RAdventurerPersona

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: NodeStateMachine = $StateMachine
@onready var npc_movement_component: NPCMovementComponent = $NPCMovementComponent
@onready var npc_animation_component: NPCAnimationComponent = $NPCAnimationComponent
@onready var name_label: Label = $NameLabel
@onready var debug_current_state: Label = $DebugCurrentState

var direction_name: String = "down"
var current_direction: Vector2 = Vector2.ZERO


## -- public methods --
func pickup(item_id: int, count: int) -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(item_id)
	# TODO: add to inventory
	print(adventurer_name + " picked up " + str(count) + " x " + str(item_data.item_name))


func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	name_label.text = "<" + adventurer_name + ">"
	GlobalMessageManager.add_console_message("INFO", adventurer_name + " has entered the game")
	
func _physics_process(_delta: float) -> void:
	npc_movement_component.handle_movement(current_direction, 1)
	npc_animation_component.handle_animation(current_direction)

func _on_state_changed(state: String) -> void:
	debug_current_state.text = state
