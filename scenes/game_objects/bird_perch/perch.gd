extends Node2D

var areas_occupied: Array[Area2D]

func is_occupied() -> bool:
	return areas_occupied.size() > 0

func _on_perch_area_area_entered(area: Area2D) -> void:
	areas_occupied.append(area)

func _on_perch_area_area_exited(area: Area2D) -> void:
	var index: int = areas_occupied.find(area)
	areas_occupied.remove_at(index)
