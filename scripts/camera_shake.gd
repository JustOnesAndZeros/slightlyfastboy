extends Camera2D

@onready var player: CharacterBody2D = $".."
@export var noise: NoiseTexture2D
@onready var noise_image = noise.get_image()
var noise_pos = Vector2.ZERO

var shake_speed = 64
var shake_strength = 2.5
var shake_enabled = false

func _process(delta: float) -> void:
	if not shake_enabled: return
	
	noise_pos += Vector2.ONE * shake_speed * delta
	noise_pos.x = fmod(noise_pos.x, noise.width)
	noise_pos.y = fmod(noise_pos.y, noise.height)
	var x = noise_image.get_pixel(floori(noise_pos.x), 0).r
	var y = noise_image.get_pixel(0, floori(noise_pos.y)).r
	global_position = player.global_position + Vector2(x, y) * shake_strength
