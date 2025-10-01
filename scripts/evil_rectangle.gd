extends ColorRect

@onready var overlay: Control = $"../Overlay"
var elapsed_time = 0
var evil_time = 60

func _ready() -> void:
	if Settings.murder_count < Settings.evil_number: set_process(false)
	size = overlay.size
	scale = overlay.scale
	global_position = overlay.global_position

func _process(delta: float) -> void:
	global_position = overlay.global_position
	elapsed_time += delta
	color.s = elapsed_time / evil_time
