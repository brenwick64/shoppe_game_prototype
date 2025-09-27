class_name RPlaceableItemData
extends RItemData

@export var placeable_scene: PackedScene
@export var preview_scene: PackedScene
@export var scale_value: Vector2 = Vector2.ONE

func new_placeable(global_pos: Vector2) -> Node2D:
	var placeable_ins: Node2D = placeable_scene.instantiate()
	placeable_ins.scale = scale_value
	placeable_ins.global_position = global_pos
	return placeable_ins

func new_preview(global_pos: Vector2) -> Node2D:
	var preview_ins: Node2D = preview_scene.instantiate()
	preview_ins.scale = scale_value
	preview_ins.global_position = global_pos
	return preview_ins
