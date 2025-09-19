class_name Interactor
extends Area2D

signal interactables_updated(interactables: Array[Interactable])
signal closest_interactable_updated(interactable: Interactable)

var nearby_interactables: Array[Interactable]
var closest_interactable: Interactable

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)

## -- methods --
func interact() -> void:
	if closest_interactable:
		closest_interactable.interact()

func handle_parent_movement() -> void:
	_update_closest_interactable()

## -- signals --
func _on_area_entered(area: Area2D) -> void:
	if area is not Interactable: return
	if area not in nearby_interactables:
		nearby_interactables.append(area)
	interactables_updated.emit(nearby_interactables)
	_update_closest_interactable()

func _on_area_exited(area: Area2D) -> void:
	if area is not Interactable: return
	if area in nearby_interactables:
		#area.get_parent().hide_outline()
		nearby_interactables = nearby_interactables.filter(func(i: Interactable): return i != area)
	interactables_updated.emit(nearby_interactables)
	_update_closest_interactable()

## -- helper functions --
func _update_closest_interactable() -> void:
	closest_interactable = _get_closest_interactable()
	closest_interactable_updated.emit(closest_interactable)

func _get_player_distance_to_area(area: Area2D) -> float:
	var player_gp: Vector2 = get_parent().global_position
	var shape_node: CollisionShape2D = area.get_node("CollisionShape2D")
	return player_gp.distance_to(shape_node.global_position)

func _get_player_distance_to_parent(area: Area2D) -> float:
	var player_gp: Vector2 = get_parent().global_position
	var parent_gp: Vector2 = area.get_parent().global_position
	return player_gp.distance_to(parent_gp)

func _get_closest_interactable() -> Interactable:
	if nearby_interactables.size() == 0: return null
	var closest: Interactable = nearby_interactables[0]
	for interactable: Interactable in nearby_interactables:
		var closest_distance: float = _get_player_distance_to_parent(closest)
		var new_distance: float = _get_player_distance_to_parent(interactable)
		if new_distance < closest_distance:
			closest = interactable
	return closest
