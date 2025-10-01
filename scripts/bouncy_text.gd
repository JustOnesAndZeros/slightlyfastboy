extends RigidBody2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

func _ready() -> void:
	var rect = RectangleShape2D.new()
	rect.size = label.get_rect().size
	collider.shape = rect
	
