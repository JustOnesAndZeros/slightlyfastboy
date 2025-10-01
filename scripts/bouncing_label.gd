extends Control

@onready var overlay: Control = $".."
@onready var label: Label = $Label
var max_pos: Vector2
var direction: Vector2
var speed = randf_range(25, 50)
var acceleration = randf_range(1, 10)

func _ready() -> void:
	update_max_pos()
	position.x = randf_range(0, max_pos.x)
	position.y = randf_range(0, max_pos.y)
	direction = Vector2.RIGHT.rotated(deg_to_rad([45, 135, 225, 315].pick_random()))

func _process(delta: float) -> void:
	position += direction * speed * delta
	if position.x < 0:
		position.x = 0
		direction = direction.bounce(Vector2.RIGHT)
	if position.x > max_pos.x:
		position.x = max_pos.x
		direction = direction.bounce(Vector2.LEFT)
	if position.y < -42:
		position.y = -42
		direction = direction.bounce(Vector2.DOWN)
	if position.y > max_pos.y + 33:
		position.y = max_pos.y + 33
		direction = direction.bounce(Vector2.UP)
	
	speed += acceleration * delta

func update_max_pos() -> void:
	max_pos = overlay.size - label.size
