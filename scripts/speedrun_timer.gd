extends Label

@onready var parent: Control = $".."
var time_elapsed = 0

func _ready() -> void:
	parent.visible = Settings.timer
	parent.set_process(Settings.timer)
	set_process(Settings.timer)

func _process(delta: float) -> void:
	time_elapsed += delta
	text = "%02d:%02d:%02d" % [time_elapsed / 60, fmod(time_elapsed, 60), fmod(time_elapsed, 1) * 100]
	parent.call_deferred("update_max_pos")
