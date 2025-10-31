class_name ToolTipComponent
extends Node2D

@export var parent: Control
@export var position_offset: Vector2 = Vector2.ZERO

@onready var tool_tip_timer: Timer = $ToolTipTimer
@onready var tool_tip_container: Control = $ToolTipContainer


func _ready() -> void:
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	tool_tip_timer.timeout.connect(_on_tool_tip_timer_timeout)


## -- signals --
func _on_mouse_entered() -> void:
	tool_tip_timer.start()
	
func _on_mouse_exited() -> void:
	visible = false
	tool_tip_timer.stop()

func _on_tool_tip_timer_timeout() -> void:
	visible = true
