extends AudioStreamPlayer2D

@export var sfx: AudioStream
@export var sfx_reverse: AudioStream

func _ready() -> void:
	set_reverse()

func set_reverse() -> void:
	var music_pos = sfx.get_length() - get_playback_position()
	if Settings.negative_volume: stream = sfx_reverse
	else: stream = sfx
	if autoplay: play(music_pos)
