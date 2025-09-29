class_name RPlaceableItemData
extends RItemData

@export var placeable_scene: PackedScene
@export var preview_scene: PackedScene
@export var scale_value: Vector2 = Vector2.ONE
@export var dimensions: Vector2i = Vector2i.ONE

func new_placeable() -> Placeable:
	var placeable_ins: Placeable = placeable_scene.instantiate()
	placeable_ins.item_id = item_id
	placeable_ins.dimensions = dimensions
	placeable_ins.scale = scale_value
	return placeable_ins

func new_preview() -> PlaceablePreview:
	var preview_ins: PlaceablePreview = preview_scene.instantiate()
	preview_ins.item_id = item_id
	preview_ins.dimensions = dimensions
	preview_ins.scale = scale_value
	return preview_ins
