class_name BirdArea
extends Area2D

@export var tags: Array[String] = []
@export var max_birds: int = 1

var birds: Array[Node2D] = []

func is_full() -> bool:
	return birds.size() > max_birds

func _on_area_entered(area: Area2D) -> void:
	var bird: Node2D = area.get_parent()
	birds.append(bird)

func _on_area_exited(area: Area2D) -> void:
	var bird: Node2D = area.get_parent()
	var index: int = birds.find(bird)
	birds.remove_at(index)
