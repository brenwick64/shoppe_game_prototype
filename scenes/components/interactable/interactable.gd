class_name Interactable
extends Area2D

signal interacted()
signal focus_changed(is_focused: bool)

#var interactable_characters: Dictionary = {}

## -- methods --
func interact() -> void:
	interacted.emit()

func set_focus() -> void:
	focus_changed.emit(true)

func unset_focus() -> void:	
	focus_changed.emit(false)

#func _ready() -> void:
	#self.body_entered.connect(_on_body_entered)
	#self.body_exited.connect(_on_body_exited)

### -- signals --
#func _on_body_entered(body: Node2D) -> void:
	#var body_id: int = body.get_instance_id()
	#interactable_characters[body_id] = body
	#
#func _on_body_exited(body: Node2D) -> void:
	#var body_id: int = body.get_instance_id()
	#interactable_characters.erase(body_id)
