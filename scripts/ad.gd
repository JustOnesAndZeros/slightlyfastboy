extends Sprite2D

@export var cycle: bool = false
@onready var timer: Timer = $Timer
@onready var fade: Sprite2D = $FadeOut
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	frame = get_random_frame()
	if cycle: timer.start()

func get_random_frame(last_frame: int = -1) -> int:
	var new_frame: int
	while true:
		new_frame = randi() % (hframes * vframes)
		if new_frame != last_frame: break
	return new_frame

func _on_timer_timeout() -> void:
	fade.frame = get_random_frame(frame)
	anim_player.play("fade_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		frame = fade.frame
		anim_player.play("reset")
