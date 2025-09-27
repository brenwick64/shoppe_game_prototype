extends Control

@export var icon_scale_multiplier: float = 2.0

## -- public methods --
func add_texture(texture: AtlasTexture) -> void:
	self.texture = texture
	_align_texture()

func hide_texture() -> void:
	self.visible = false

func show_texture() -> void:
	self.visible = true

func reset_texture() -> void:
	self.texture = null

## -- helper functions --
func _align_texture() -> void:
	set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	set_offsets_preset(Control.LayoutPreset.PRESET_CENTER)
	# Set pivot to center so scaling stays centered
	pivot_offset = size / 2
	scale = Vector2(icon_scale_multiplier, icon_scale_multiplier)	
