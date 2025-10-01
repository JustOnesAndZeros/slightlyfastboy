extends AnimatedSprite2D

@onready var sfx: AudioStreamPlayer = $ExplosionSound
@onready var collider: Area2D = $Area2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	sfx.pitch_scale *= global_scale.y * 2.0
	sfx.pitch_scale /= global_scale.x * 2.0
	if Settings.negative_volume:
		frame = sprite_frames.get_frame_count("explosion") - 1
		speed_scale *= -1
		anim_player.play_backwards("explosion")
	else:
		anim_player.play("explosion")
	play()
	sfx.play()

func _on_animation_finished() -> void:
	queue_free()

func _on_frame_changed() -> void:
	collider.monitoring = frame <= 10 and Settings.explosion_has_damage

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_rgb: body.die()
