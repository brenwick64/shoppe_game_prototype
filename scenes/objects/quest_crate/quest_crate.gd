class_name QuestCrate
extends StaticBody2D

@export var sprite: Sprite2D

@onready var navigation_marker: Marker2D = $NavigationMarker
@onready var lootable_component: LootableComponent = $LootableComponent
@onready var interactable: Interactable = $Interactable
@onready var deposit_sound: OneShotSoundComponent = $DepositSound


func _ready() -> void:
	if not lootable_component.lootable_items:
		interactable.disable_collision()

## -- public methods --
func deposit_items(depositor: Node2D, item_id: int, count: int) -> void:
	_spawn_pickups(item_id, count, depositor.global_position, global_position)

func withdraw_items(player: Player) -> void:
	var items: Array[RInventoryItem] = lootable_component.loot_all_items()
	GlobalPlayerInventory.add_items(items)


## -- helper functions --
func _spawn_pickups(item_id: int, count: int, from_gp: Vector2, to_gp: Vector2) -> void:
	for i: int in range(count):
		await get_tree().create_timer(0.1).timeout
		var spawned_pickup = GlobalItemSpawner.spawn_item_pickup(
			item_id,
			1,
			from_gp,
			to_gp
		)
		spawned_pickup.drop_finished.connect(_on_pickup_drop_finished)

func _show_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)

func _hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)


## -- signals --
func _on_pickup_drop_finished(item_pickup: ItemPickup) -> void:
	lootable_component.deposit_items(item_pickup.item_id, item_pickup.count)
	deposit_sound.play_sound()
	item_pickup.queue_free()

func _on_interactable_focus_changed(is_focused: bool) -> void:
	if is_focused: _show_outline()
	else: _hide_outline()

func _on_interactable_interacted(interactor: Node2D) -> void:
	if not lootable_component.lootable_items: return
	var interactor_parent: Node2D = interactor.get_parent()
	if not interactor_parent is Player: return
	withdraw_items(interactor_parent)

func _on_lootable_component_items_changed(lootable_items: Array[RInventoryItem]) -> void:
	if lootable_items: interactable.enable_collision()
	else: interactable.disable_collision()
