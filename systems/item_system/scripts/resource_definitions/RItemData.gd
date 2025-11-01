class_name RItemData
extends Resource

@export var item_id: int
@export var item_name: String
@export_multiline var item_tooltip_desc: String
@export var item_type: Constants.ITEM_TYPES
@export var icon_texture: AtlasTexture
@export var icon_scale_multiplier: float = 2.0
@export var pickup_texture: AtlasTexture
@export var pickup_scale: Vector2 = Vector2.ONE

var _pickup_scene: PackedScene = preload("res://systems/item_system/scenes/item_pickup/item_pickup.tscn")

## -- constructors --
func new_pickup() -> ItemPickup:
	var pickup_ins: ItemPickup = _pickup_scene.instantiate()
	pickup_ins.item_id = item_id
	pickup_ins.pickup_texture = pickup_texture
	pickup_ins.scale = pickup_scale
	return pickup_ins
