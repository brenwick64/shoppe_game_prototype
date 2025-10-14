class_name PlaceableItemSlot
extends Node2D

signal item_added(item_slot: PlaceableItemSlot, placed_item: PlaceableItem)
signal item_removed(item_slot: PlaceableItemSlot, placed_item: PlaceableItem, placed_item_tile_coords: Array[Vector2i])

@export var parent_furniture: PlaceableFurniture
@export var slot_index: int
@export var dimensions: Vector2i = Vector2i.ONE
@export var distance_from_origin: Vector2i = Vector2i.ZERO

@onready var purchase_sound: OneShotSoundComponent = $PurchaseSound

var shoppe_items: ShoppeItems

var placed_item_id: int = -1
var placed_item: PlaceableItem
var placed_item_tile_coords: Array[Vector2i]

func _ready() -> void:
	var shoppe_items_ref: Node = get_tree().get_first_node_in_group("shoppe_items")
	if not shoppe_items_ref:
		push_error("PlaceableItemSlot error: no shoppe_items node found in scene tree.")
		return
	shoppe_items = shoppe_items_ref


## -- public methods --
func item_purchased(placeable_item: PlaceableItem) -> void:
	var item_price: int = _get_item_price(placeable_item.item_id)
	_spawn_coins(item_price)
	_play_coin_sound()
	_update_player_currency(item_price)
	remove_item()

func item_removed_by_player(item_id: int, player_node: Player) -> void:
	remove_item()
	GlobalItemSpawner.spawn_item_pickup(
		item_id,
		global_position,
		player_node.global_position,
		player_node
	)

func add_item(placeable_item: PlaceableItem) -> void:
	placeable_item.furniture_unique_id = parent_furniture.furniture_unique_id
	placeable_item.item_slot_index = slot_index
	placed_item_id = placeable_item.item_id
	placed_item = placeable_item
	add_child(placeable_item)
	shoppe_items.handle_item_added(placeable_item)
	item_added.emit(self, placeable_item)

func remove_item() -> void:
	item_removed.emit(self, placed_item, placed_item_tile_coords)
	shoppe_items.handle_item_removed(placed_item)
	placed_item.queue_free()
	_reset_item_slot()


## -- helper functions --
func _reset_item_slot() -> void:
	placed_item_id = -1
	placed_item = null
	placed_item_tile_coords = []

func _spawn_coins(item_price: int) -> void:
	GlobalItemSpawner.spawn_coins(global_position, item_price)

func _play_coin_sound() -> void:
	purchase_sound.play_sound()

func _get_item_price(item_id: int) -> int:
	var item_data: RShoppeItemData = GlobalItemDb.get_item_by_id(item_id)
	if not item_data:
		push_error("PlaceableItemSlot error: cannot find data for item_id: " + str(item_id))
		return 0
	var item_price: int = item_data.shoppe_item_stats.base_price
	return item_price

func _update_player_currency(item_price: int) -> void:
	var player_currency_manager: CurrencyManager = get_tree().get_first_node_in_group("player_currency")
	if not player_currency_manager:
		push_error("PlaceableItemSlot error: cannot find player currency manager")
		return
	player_currency_manager.add_currency(item_price)
