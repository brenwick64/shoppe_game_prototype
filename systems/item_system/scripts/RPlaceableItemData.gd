class_name RPlaceableItemData
extends RItemData

@export var placeable_scene: PackedScene
@export var preview_scene: PackedScene
@export var scale_value: Vector2 = Vector2.ONE

func new_placeable() -> Node2D:
	var placeable_ins: Node2D = placeable_scene.instantiate()
	placeable_ins.scale = scale_value
	return placeable_ins

func new_preview() -> Node2D:
	var preview_ins: Node2D = preview_scene.instantiate()
	preview_ins.scale = scale_value
	return preview_ins
