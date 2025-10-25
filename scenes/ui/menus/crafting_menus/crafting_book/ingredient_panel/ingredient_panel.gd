class_name UIIngredientPanel
extends Panel

@onready var ingredient_texture: TextureRect = $MarginContainer/IngredientTexture
@onready var ingredient_count: Label = $IngredientCount

var ingredient: RInventoryItem

func _ready() -> void:
	var item_data: RItemData = GlobalItemDb.get_item_by_id(ingredient.item_id)
	ingredient_texture.texture = item_data.icon_texture
	ingredient_count.text = str(ingredient.count)
