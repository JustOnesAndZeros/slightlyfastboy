extends Timer

var james = preload("res://scenes/weird_james.tscn")
var john = preload("res://scenes/strange_john.tscn")
const min_james_chance = 0.25
var james_chance = min_james_chance
var john_chance = 0.2
@onready var player: CharacterBody2D = $"../FastBoy"
var offset_scale = 1.0
var offset_x = 130
var offset_y = 80

func _on_timeout() -> void:
	if randf() < james_chance and len(get_children()) == 0:
		spawn_james()
		james_chance = min_james_chance
	else:
		james_chance *= 1.5
	
func spawn_james() -> void:
	var new_james: Area2D = james.instantiate()
	
	if randf() < john_chance: new_james = john.instantiate()
	
	var offset = Vector2.ZERO
	if randf() < 0.5:
		offset.x = offset_x * offset_scale
		if randf() < 0.5: offset.x *= -1
		offset.y = randf_range(-offset_y * offset_scale, offset_y * offset_scale)
	else:
		offset.y = offset_y * offset_scale
		if randf() < 0.5: offset.y *= -1
		offset.x = randf_range(-offset_x * offset_scale, offset_x * offset_scale)
		
	new_james.global_position = player.global_position + offset
	add_child.call_deferred(new_james)

func enable_evil_mode() -> void:
	john_chance = 1
	for child in get_children(): child.queue_free()
