extends SubTask

@export var input_var_name: String
@export var output_var_name: String

## state variables
var _target_harvestable: Harvestable
var _harvestable_pickup: ItemPickup
var _harvested: bool = false
var _harvestable_depleted: bool = false


## -- overrides --
func init(p_parent_task: Task, p_payload: Dictionary) -> void:
	super.init(p_parent_task, p_payload)
	var target_node: Node2D = payload[input_var_name]
	if target_node is Harvestable:
		_target_harvestable = target_node
		_target_harvestable.harvested.connect(_on_harvestable_harvested)

func on_physics_process(delta: float) -> void:
	super.on_physics_process(delta)
	if _harvestable_depleted:
		print("node depleted before i could farm it, getting new node")
		_target_harvestable.harvested.disconnect(_on_harvestable_harvested)
		super.fail(self, payload, "retry_task")
	elif not _harvested:
		_harvest_node()
	else:
		_start_conversation_about_harvesting() # say something right after node is harvested
		payload.merge({ output_var_name: _harvestable_pickup })
		_target_harvestable.harvested.disconnect(_on_harvestable_harvested)
		super.complete(payload, reset_state)

func reset_state() -> void:
	_target_harvestable = null
	_harvestable_pickup = null
	_harvestable_depleted = false
	_harvested = false


## -- helper functions --
func _start_conversation_about_harvesting() -> void:
	var message_context: RMessageContext = RMessageContext.new()
	message_context.can_reply = true
	message_context.type = Constants.CHAT_MESSAGE_TYPE.QUESTION
	message_context.subject_tags = ["level_inquiry", parent_task.harvestable_type]
	parent_task.adventurer.chat_manager.start_conversation(message_context)


## - main function --
func _harvest_node() -> void:
	if _target_harvestable.is_depleted():
		_harvestable_depleted = true
	else:
		_target_harvestable.harvest(parent_task.adventurer)


## --signals --
func _on_harvestable_harvested(pickup: ItemPickup) -> void:
	if not pickup.owner_id == parent_task.adventurer.get_instance_id(): return
	_harvestable_pickup = pickup
	_harvested = true
