extends Label

@onready var player: CharacterBody2D = $"../../../FastBoy"
@onready var james_spawner: Timer = $"../../../JamesSpawner"
@onready var parent: Control = $".."
@onready var evil_music = $SuperEvilNotFunTimes
@onready var evil_rectangle = $"../../../EvilRectangle"

func _ready() -> void:
	parent.visible = Settings.murder
	parent.set_process(Settings.murder)
	update_counter()

func increase_murder() -> void:
	Settings.murder_count += 1
	Settings.call_deferred("save_data")
	update_counter()

func update_counter() -> void:
	text = "Murder: " + str(Settings.murder_count)
	parent.call_deferred("update_max_pos")
	
	if Settings.murder_count >= Settings.evil_number and not evil_music.playing:
		james_spawner.enable_evil_mode()
		player.remove_all_effects()
		evil_music.play()
		evil_rectangle.set_process(true)
		modulate = Color.RED
