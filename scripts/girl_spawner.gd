extends Timer

var slow_girl = preload("res://scenes/slow_girl.tscn")
var girls = []
var max_girls = 256
@onready var player: CharacterBody2D = $"../FastBoy"
var offset_scale = 1.0
var offset_x = 130
var offset_y = 80
var min_wait_time = 0.25
var wait_time_acceleration = 0.025
var bullet_hell_multiplier = 10

func _ready() -> void:
	if Settings.bullet_hell:
		max_girls *= 5
		wait_time /= bullet_hell_multiplier
		min_wait_time /= bullet_hell_multiplier
	spawn_girl()

func _process(delta: float) -> void:
	wait_time = clamp(wait_time - wait_time_acceleration * delta, min_wait_time, INF)

func _on_timeout() -> void:
	spawn_girl()
	if wait_time > min_wait_time:
		wait_time -= wait_time_acceleration
		if wait_time < min_wait_time: wait_time = min_wait_time

func spawn_girl() -> void:
	while len(girls) > max_girls: remove_girl(girls[0])
	
	var new_slow_girl: CharacterBody2D = slow_girl.instantiate()
	
	var offset = Vector2.ZERO
	if randf() < 0.5:
		offset.x = offset_x * offset_scale
		if randf() < 0.5: offset.x *= -1
		offset.y = randf_range(-offset_y * offset_scale, offset_y * offset_scale)
	else:
		offset.y = offset_y * offset_scale
		if randf() < 0.5: offset.y *= -1
		offset.x = randf_range(-offset_x * offset_scale, offset_x * offset_scale)
		
	new_slow_girl.global_position = player.global_position + offset
	add_sibling.call_deferred(new_slow_girl)
	girls.append(new_slow_girl)

func remove_girl(girl: CharacterBody2D) -> void:
	girls.erase(girl)
	girl.queue_free()
