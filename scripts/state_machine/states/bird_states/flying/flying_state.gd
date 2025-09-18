extends State

@export var parent: Node2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var area_2d: Area2D

func _fly(delta: float) -> void: 
	var direction_vector: Vector2 = Vector2.LEFT if parent.direction_name == "left" else Vector2.RIGHT 
	parent.position += direction_vector.normalized() * parent.max_speed * delta

## -- overrides
func _on_physics_process(delta: float) -> void:
	_fly(delta)

func _on_enter() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	animated_sprite_2d.play("fly_" + parent.direction_name)

func _on_exit() -> void:
	area_2d.area_entered.disconnect(_on_area_2d_area_entered)
	animated_sprite_2d.stop()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is not BirdArea: return
	if area.is_full(): return
	if parent.bird_area_visited: return
	for tag: String in parent.bird_area_tags:
		if tag in area.tags:
			parent.target_bird_area = area
			parent.bird_area_visited = true
			transition.emit("landing")
			return
