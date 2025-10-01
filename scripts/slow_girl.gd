extends CharacterBody2D

@onready var player: CharacterBody2D = $"../FastBoy"
@onready var murder_counter: Label = $"../Overlay/MurderCounter/Label"
@onready var girl_spawner: Timer = $"../GirlSpawner"
@onready var sprite: Sprite2D = $Sprite2D
var explosion = preload("res://scenes/explosion.tscn")
var speed = 10
var move_direction = Vector2.ZERO
var is_rgb = false
var rgb_speed = 360
var rgb_time = randf() * 360
var is_spinning = false
var spin_speed = 0
var max_spin_speed = randf_range(1, 100)
var spin_acceleration = max_spin_speed / 5
var speed_multiplier = Vector2.ONE
var is_torpedo = false
@onready var john_cooldown: Timer = $JohnCooldown
var john_block = false

func _ready() -> void:
	speed = player.speed / 3
	if Settings.bullet_hell: speed /= 2
	if Settings.trans: sprite.texture = Settings.boy_texture
	if randf() < 0.1: apply_effect(5)

func apply_effect(max_loops: int = 1, from_john: bool = false) -> void:
	if john_block: return
	
	for i in range(max_loops):
		match randi_range(0, 6):
			0:
				if not is_torpedo: is_spinning = true
				speed_multiplier *= 1.5
			1:
				scale *= Vector2(2.5, 0.5)
				speed_multiplier *= Vector2(2.5, 0.5)
			2:
				scale *= Vector2(0.5, 2.5)
				speed_multiplier *= Vector2(0.5, 2.5)
			3:
				scale *= Vector2(1, -1)
				speed_multiplier *= 0.75
			4:
				scale *= Vector2(-1, 1)
				speed_multiplier *= 0.75
			5:
				if is_rgb:
					rgb_speed *= 1.5
				else:
					is_rgb = true
					$Sprite2D.modulate.s = 1
			6:
				if not is_spinning: is_torpedo = true
				speed_multiplier *= 1.5
		if randf() > 0.1: break
		if speed > player.speed: speed = player.speed
	
	if from_john:
		john_block = true
		john_cooldown.start()

func _process(delta: float) -> void:
	var distance_from_player = global_position - player.global_position
	if distance_from_player.x < -player.max_distance_from_player.x:
		global_position.x += player.max_distance_from_player.x * 2
	if distance_from_player.x > player.max_distance_from_player.x:
		global_position.x -= player.max_distance_from_player.x * 2
	if distance_from_player.y < -player.max_distance_from_player.y:
		global_position.y += player.max_distance_from_player.y * 2
	if distance_from_player.y > player.max_distance_from_player.y:
		global_position.y -= player.max_distance_from_player.y * 2
	
	move_direction = (player.global_position - global_position).normalized()
	if is_spinning:
		rotation += spin_speed * delta
		if spin_speed < max_spin_speed: spin_speed += spin_acceleration * delta
	elif is_torpedo:
		look_at(player.global_position)
		rotate(deg_to_rad(90))
	if is_rgb:
		rgb_time = fmod(rgb_time + rgb_speed * delta, 360)
		$Sprite2D.modulate.r = 1 + sin(deg_to_rad(rgb_time))
		$Sprite2D.modulate.g = 1 + sin(deg_to_rad(rgb_time + 120))
		$Sprite2D.modulate.b = 1 + sin(deg_to_rad(rgb_time + 240))

func _physics_process(_delta: float) -> void:
	velocity = move_direction * speed * speed_multiplier
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		if body.is_rgb and not is_rgb:
			die()
		else:
			body.die()

func die() -> void:
	murder_counter.increase_murder()
	girl_spawner.call_deferred("remove_girl", self)
	var new_explosion: AnimatedSprite2D = explosion.instantiate()
	new_explosion.global_position = global_position
	new_explosion.global_scale = global_scale * 0.5
	new_explosion.global_rotation = global_rotation
	add_sibling.call_deferred(new_explosion)


func _on_john_cooldown_timeout() -> void:
	john_block = false
