extends Area2D

@onready var player: CharacterBody2D = $"../../FastBoy"
@onready var camera: Camera2D = $"../../FastBoy/Camera2D"
@onready var flee_timer: Timer = $FleeTimer
@onready var follow_timer: Timer = $FollowTimer
@onready var voice: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var jumpscare: AnimationPlayer = $"../../Jumpscare"
@onready var groans: Array[AudioStreamPlayer] = [$"../../EvilRectangle/JohnFace/Groan0", $"../../EvilRectangle/JohnFace/Groan1", $"../../EvilRectangle/JohnFace/Groan2"]
var target: Vector2 = Vector2.ZERO
var camera_bounds: Vector2 = Vector2(113, 58.5)
var explosion = preload("res://scenes/explosion.tscn")
var john_behaviours: Array[String] = ["NORMAL", "LURK", "ORBIT", "ZIGZAG", "FOLLOW"]
var current_behaviour: String = john_behaviours.pick_random()
var speed = 0
var acceleration = 0
var min_distance_from_player = 20
var orbit_distance = 0
var min_orbit_distance = 22
var follow_path: Array[Vector2] = []

func _ready() -> void:
	if Settings.murder_count >= Settings.evil_number:
		$Sprite2D/Eyes.modulate = Color.RED
		voice.play()
	
	match current_behaviour:
		"NORMAL":
			speed = player.speed * 2
			acceleration = player.acceleration * 2
		"LURK":
			flee_timer.start()
			speed = player.speed * 3
			acceleration = player.acceleration
		"ORBIT":
			orbit_distance = (global_position - player.global_position).length()
			speed = 2 * camera.zoom.x / 8
			acceleration = 1 * camera.zoom.x / 8
		"ZIGZAG":
			flee_timer.start()
			speed = player.speed * 3
			acceleration = player.acceleration
			target = get_random_position()
			look_at(target)
			rotate(deg_to_rad(90))
		"FOLLOW":
			target = global_position
			follow_timer.start()
			speed = player.speed * 1.5
			acceleration = player.acceleration

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
	
	match current_behaviour:
		"FLEE":
			var to_player: Vector2 = player.global_position - global_position
			target = global_position - to_player.normalized() * player.speed * 2
		"NORMAL":
			target = player.global_position
		"LURK":
			var to_player: Vector2 = player.global_position - global_position
			target = global_position + to_player - min_distance_from_player * to_player.normalized()
		"ORBIT":
			var from_player: Vector2 = (global_position - player.global_position).rotated(speed * delta)
			global_position = player.global_position + from_player.normalized() * orbit_distance
			orbit_distance -= 37.5 * delta
			target = global_position
			look_at(player.global_position)
			rotate(deg_to_rad(-90))
			if orbit_distance < min_orbit_distance: flee()
		"ZIGZAG":
			if target == global_position:
				target = get_random_position()
				look_at(target)
				rotate(deg_to_rad(90))
		"FOLLOW":
			if global_position.distance_to(player.global_position) < 32:
				target = player.global_position
			elif target == global_position:
				if len(follow_path) > 0:
					target = follow_path.pop_at(0)
				else: target = player.global_position

func get_random_position() -> Vector2:
	var pos = player.global_position
	pos.x += randf_range(-camera_bounds.x, camera_bounds.x)
	pos.y += randf_range(-camera_bounds.y, camera_bounds.y)
	return pos

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	speed += acceleration * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "FastBoy":
		die()
	else:
		body.apply_effect()

func die() -> void:
	if Settings.murder_count >= Settings.evil_number:
		if Settings.negative_volume: jumpscare.play_backwards("jumpscare")
		else: jumpscare.play("jumpscare")
		for sfx: AudioStreamPlayer in groans: sfx.stop()
		groans.pick_random().play()
	else:
		var new_explosion: AnimatedSprite2D = explosion.instantiate()
		new_explosion.global_position = global_position
		new_explosion.global_scale = global_scale * 0.5
		new_explosion.global_rotation = global_rotation
		add_sibling.call_deferred(new_explosion)
	queue_free()

func _on_flee_timer_timeout() -> void:
	flee()

func flee() -> void:
	current_behaviour = "FLEE"
	speed = player.speed * 5
	rotation = 0

func _on_screen_exited() -> void:
	if current_behaviour == "FLEE":
		queue_free()


func _on_follow_timer_timeout() -> void:
	follow_path.append(player.global_position)
