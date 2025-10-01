extends Node2D

@onready var player: CharacterBody2D = $".."
var hat_james = preload("res://scenes/hat_james.tscn")
var explosion = preload("res://scenes/explosion.tscn")
const james_seperation = 7
var james_count = 0

func add_james() -> void:
	var new_james: Node2D = hat_james.instantiate()
	new_james.position.y -= james_seperation * james_count
	add_child(new_james)
	move_child(new_james, 0)
	james_count += 1

func remove_james() -> void:
	var james_to_remove: Node2D = get_child(0)
	var james_sprite: Sprite2D = james_to_remove.get_child(0)
	var new_explosion: AnimatedSprite2D = explosion.instantiate()
	new_explosion.global_position = global_position
	new_explosion.global_scale = james_sprite.global_scale * 0.5
	new_explosion.global_rotation = global_rotation
	james_to_remove.queue_free()
	player.add_sibling(new_explosion)
	james_count -= 1
