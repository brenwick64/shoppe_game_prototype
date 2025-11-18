class_name TreeSprite
extends CharacterBody2D

@export var FLOATING_TEXT_Y_OFFSET: float = -20

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_enemy_hurt_box_area_entered(area: Area2D) -> void:
	_flash_white(0.1)
	_add_floating_text("-1")
	

## -- helper functions --
func _add_floating_text(text: String) -> void:
	var floating_text_ui: FloatingTextUI = get_tree().get_first_node_in_group("floating_text_ui")
	if not floating_text_ui: return
	floating_text_ui.add_text(self, text, FLOATING_TEXT_Y_OFFSET)


func _flash_white(duration: float = 0.1) -> void:
	var t: Tween = create_tween()
	t.tween_property(animated_sprite_2d, "modulate", Color.RED, duration * 0.5)
	t.tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1, 1), duration * 0.5)
