extends Area2D

@onready var player: CharacterBody2D = $"../../FastBoy"
var speed = 25
var acceleration = 2.5
var direction = Vector2.ZERO

func _ready() -> void:
	speed = player.speed * 0.75
	if Settings.faster: acceleration *= 3

func _process(_delta: float) -> void:
	var distance_from_player = global_position - player.global_position
	if distance_from_player.x < -player.max_distance_from_player.x:
		global_position.x += player.max_distance_from_player.x * 2
	if distance_from_player.x > player.max_distance_from_player.x:
		global_position.x -= player.max_distance_from_player.x * 2
	if distance_from_player.y < -player.max_distance_from_player.y:
		global_position.y += player.max_distance_from_player.y * 2
	if distance_from_player.y > player.max_distance_from_player.y:
		global_position.y -= player.max_distance_from_player.y * 2

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(player.global_position, speed * delta)
	speed += acceleration * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "FastBoy":
		body.weird()
		queue_free()
	else:
		body.die()
