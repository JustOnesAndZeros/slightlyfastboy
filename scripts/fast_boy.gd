extends CharacterBody2D

var speed = 36
var speed_multiplier = Vector2.ONE
var acceleration = 0
var faster_mode_acceleration = 2.5
var move_direction = Vector2.ZERO
var spin_speed = 0
var spin_acceleration = 10
var max_distance_from_player: Vector2 = Vector2(480, 270)
@onready var overlay = $"../Overlay"
@onready var spawners: Array[Timer] = [$"../GirlSpawner", $"../JamesSpawner"]
@onready var camera: Camera2D = $Camera2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var james_hat: Node2D = $JamesHat
@onready var speedlines: TextureRect = $"../Overlay/Speedlines"
@onready var fast_music: AudioStreamPlayer = $"../Overlay/Speedlines/FastMusic"
@onready var hit_box: ColorRect = $HitBox
var music_pos = 0
const weird_effects = ["WIDE", "TALL", "FLIP_X", "FLIP_Y", "ZOOM_IN", "ZOOM_OUT", "RGB", "HAT", "TRANS"]
var current_effects = []
const effect_time = {"WIDE": 15, "TALL": 15, "FLIP_X": 10, "FLIP_Y": 10, "ZOOM_IN": 5, "ZOOM_OUT": 5, "RGB": 10, "HAT": 30, "TRANS": 20}
var current_effect_time = []
var is_rgb = false
const rgb_speed = 360
var rgb_time = 0

func _ready() -> void:
	if Settings.ads: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if Settings.trans: transition()
	if Settings.faster:
		acceleration = faster_mode_acceleration
		if Settings.murder_count >= Settings.evil_number: fast_music = $"../Overlay/Speedlines/EvilFastMusic"
	if Settings.bullet_hell:
		collider.shape.size = Vector2.ONE
		hit_box.visible = true

func die() -> void:
	Settings.save_data()
	if Settings.ransomware_mode:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/ransom.tscn")
	else:
		OS.shell_open("https://veryslowgirl.github.io/")
		get_tree().quit()

func transition() -> void:
	if sprite.texture == Settings.boy_texture:
		sprite.texture = Settings.girl_texture
	else:
		sprite.texture = Settings.boy_texture

func _process(delta: float) -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	speed += acceleration * delta
	
	if Settings.faster and (move_direction != Vector2.ZERO or spin_speed > 0):
		if not fast_music.playing: fast_music.play(music_pos)
		camera.shake_enabled = true
		speedlines.visible = true	
	else:
		camera.shake_enabled = false
		speedlines.visible = false
		if fast_music.playing:
			music_pos = fast_music.get_playback_position()
			fast_music.stop()
	
	if Input.is_action_pressed("spin"):
		spin_speed = clampf(spin_speed + spin_acceleration * delta, 0, INF)
		rotation += spin_speed * delta
	else:
		spin_speed = 0
		rotation = 0
	
	var effects_to_remove = []
	for i in range(len(current_effect_time)):
		current_effect_time[i] -= delta
		if current_effect_time[i] < 0: effects_to_remove.insert(0, i)
	if len(effects_to_remove) > 0: remove_effects(effects_to_remove)
	
	if is_rgb:
		rgb_time = fmod(rgb_time + rgb_speed * delta, 360)
		var new_colour = Color.WHITE
		new_colour.r = 1 + sin(deg_to_rad(rgb_time))
		new_colour.g = 1 + sin(deg_to_rad(rgb_time + 120))
		new_colour.b = 1 + sin(deg_to_rad(rgb_time + 240))
		modulate = new_colour
		overlay.modulate = new_colour

func remove_effects(effects_to_remove) -> void:
	for i in effects_to_remove:
		var effect_to_remove = current_effects[i]
		current_effects.remove_at(i)
		current_effect_time.remove_at(i)
		remove_effect(effect_to_remove)

func remove_all_effects() -> void:
	var effects_to_remove = range(len(current_effects))
	if len(effects_to_remove) > 0:
		effects_to_remove.reverse()
		remove_effects(effects_to_remove)

func _physics_process(_delta: float) -> void:
	velocity = move_direction * speed * speed_multiplier
	move_and_slide()

func weird():
	var new_effect: String = weird_effects.pick_random()
	current_effects.append(new_effect)
	current_effect_time.append(effect_time[new_effect])
	apply_effect(new_effect)

func apply_effect(effect: String) -> void:
	match effect:
		"WIDE":
			scale *= Vector2(2.5, 0.5)
			speed_multiplier *= Vector2(2.5, 1)
		"TALL":
			scale *= Vector2(0.5, 2.5)
			speed_multiplier *= Vector2(1, 2.5)
		"FLIP_X":
			camera.zoom *= Vector2(-1, 1)
			speed_multiplier *= Vector2(-1, 1)
		"FLIP_Y":
			camera.zoom *= Vector2(1, -1)
			speed_multiplier *= Vector2(1, -1)
		"ZOOM_IN":
			camera.zoom *= 2
			overlay.change_scale(0.5)
			for s in spawners:
				s.offset_scale /= 2
		"ZOOM_OUT":
			camera.zoom /= 2
			overlay.change_scale(2)
			for s in spawners:
				s.offset_scale *= 2
		"RGB":
			is_rgb = true
		"HAT":
			james_hat.add_james()
		"TRANS":
			transition()

func remove_effect(effect: String) -> void:
	match effect:
		"WIDE":
			scale /= Vector2(2.5, 0.5)
			speed_multiplier /= Vector2(2.5, 1)
		"TALL":
			scale /= Vector2(0.5, 2.5)
			speed_multiplier /= Vector2(1, 2.5)
		"FLIP_X":
			camera.zoom *= Vector2(-1, 1)
			speed_multiplier *= Vector2(-1, 1)
		"FLIP_Y":
			camera.zoom *= Vector2(1, -1)
			speed_multiplier *= Vector2(1, -1)
		"ZOOM_IN":
			camera.zoom /= 2
			overlay.change_scale(2)
			for s in spawners:
				s.offset_scale *= 2
		"ZOOM_OUT":
			camera.zoom *= 2
			overlay.change_scale(0.5)
			for s in spawners:
				s.offset_scale /= 2
		"RGB":
			if "RGB" in current_effects: return
			is_rgb = false
			modulate = Color.WHITE
			overlay.modulate = Color.WHITE
		"HAT":
			james_hat.remove_james()
		"TRANS":
			transition()
