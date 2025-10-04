extends AnimatedSprite2D

@export var character_spritesheet_texture: Texture2D

const FRAME_DIMENSIONS: Vector2i = Vector2i(24, 24)
const SPRITESHEET_DIMENSIONS: Vector2i = Vector2i(16, 4)
const ANIMATION_DIMENSIONS: int = 4
const ANIMATION_ORDER: Array[String] = ["down", "left", "right", "up"]

var skin_index_randomizer: int = randi_range(0, 3) # 4 possible combinations

func _create_idle_animations(spriteframes: SpriteFrames) -> SpriteFrames:
	for x: int in range(ANIMATION_DIMENSIONS):
		var animation_name: String = "idle_" + ANIMATION_ORDER[x]
		spriteframes.add_animation(animation_name)
		var y: int = ANIMATION_DIMENSIONS * skin_index_randomizer + 1
		var region: Rect2 = Rect2(
			y * FRAME_DIMENSIONS.y,
			x * FRAME_DIMENSIONS.x,
			FRAME_DIMENSIONS.y,
			FRAME_DIMENSIONS.x
		)
		var subtex: AtlasTexture = AtlasTexture.new()
		subtex.atlas = character_spritesheet_texture
		subtex.region = region
		if x == 0:
			spriteframes.add_frame("default", subtex)
		spriteframes.add_frame(animation_name, subtex)
	return spriteframes


func _create_walking_animations(spriteframes: SpriteFrames) -> SpriteFrames:
	for x: int in range(ANIMATION_DIMENSIONS):
		var animation_name: String = "walk_" + ANIMATION_ORDER[x]
		spriteframes.add_animation(animation_name)
		for y: int in range(ANIMATION_DIMENSIONS):
			y = y + (ANIMATION_DIMENSIONS * skin_index_randomizer) # random skin color
			var region: Rect2 = Rect2(
				y * FRAME_DIMENSIONS.y,
				x * FRAME_DIMENSIONS.x,
				FRAME_DIMENSIONS.y,
				FRAME_DIMENSIONS.x
			)
			var subtex: AtlasTexture = AtlasTexture.new()
			subtex.atlas = character_spritesheet_texture
			subtex.region = region
			spriteframes.add_frame(animation_name, subtex)
	return spriteframes

func _configure_sprite() -> void:
	var spriteframes: SpriteFrames = SpriteFrames.new()
	spriteframes = _create_idle_animations(spriteframes)
	spriteframes = _create_walking_animations(spriteframes)
	#self.frames = spriteframes
	self.sprite_frames = spriteframes

func _ready() -> void:
	_configure_sprite()
