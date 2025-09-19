class_name Interactable
extends Area2D

signal interacted()

var interactable_characters: Dictionary = {}

func interact() -> void:
	interacted.emit()

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

## -- signals --
func _on_body_entered(body: Node2D) -> void:
	var body_id: int = body.get_instance_id()
	interactable_characters[body_id] = body
	
func _on_body_exited(body: Node2D) -> void:
	var body_id: int = body.get_instance_id()
	interactable_characters.erase(body_id)
