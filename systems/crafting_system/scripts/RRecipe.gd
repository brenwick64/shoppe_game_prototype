class_name RRecipe
extends Resource

@export var recipe_name: StringName
@export var recipe_tags: Array[String]
@export var base_craft_time_seconds: float
@export var input_items: Array[RInventoryItem]
@export var output_items: Array[RInventoryItem]
@export var output_texture: AtlasTexture
@export_multiline var output_desc: String
