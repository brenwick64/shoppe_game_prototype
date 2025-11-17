class_name TrainingDummy
extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_sound: OneShotSoundComponent = $HitSound

## -- helper functions --
func _shake_sprite() -> void:
	var shake_time: float = 0.25
	sprite.material.set_shader_parameter("shake_intensity", 1)
	await get_tree().create_timer(shake_time).timeout
	sprite.material.set_shader_parameter("shake_intensity", 0.0)

func _add_floating_text(text: String) -> void:
	var floating_text_ui: FloatingTextUI = get_tree().get_first_node_in_group("floating_text_ui")
	if not floating_text_ui: return
	floating_text_ui.add_text(self, text)


## -- signals --
func _on_enemy_hurt_box_area_entered(area: Area2D) -> void:
	_shake_sprite()
	hit_sound.play_sound()
	_add_floating_text("-1")
