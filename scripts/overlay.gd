extends Control

@onready var camera: Camera2D = $"../FastBoy/Camera2D"
var offset: Vector2

func _ready() -> void:
	offset = size * scale / -2

func _process(_delta: float) -> void:
	global_position = camera.global_position + offset

func change_scale(multiplier: float) -> void:
	scale *= multiplier
	offset *= multiplier
