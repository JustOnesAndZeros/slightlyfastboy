extends VBoxContainer

@export var enabled = false
@onready var title: Label = $"../../../MarginContainer/Title"
@onready var main_menu: Control = $"../Menu"
@onready var options_menu: Control = $"../Options"
@onready var weird_menu: Control = $"../Weird"
@onready var evil_menu: Control = $"../Evil"
@onready var fullscreen_option: Label = $"../Options/Fullscreen"
@onready var mute_option: Label = $"../Options/Mute"
@onready var ads: Node2D = $"../../../Ads"
var children
var selected = 0
var total
const marker = "> "
var bg_girl = preload("res://sprites/slowgirl_background.png")
var bg_boy = preload("res://sprites/fastboy_background.png")
@onready var bgm: AudioStreamPlayer = $"../../../BGM"
var file_prompt = preload("res://scenes/file_prompt.tscn")

func _ready() -> void:
	set_process_input(enabled)
	visible = enabled
	children = get_children()
	total = len(children)
	call_deferred("update_fullscreen")
	call_deferred("update_mute")
	call_deferred("update_c_spelling")
	update_option(selected)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_down"):
		update_option(selected + 1)
	elif Input.is_action_just_pressed("move_up"):
		update_option(selected - 1)
	elif Input.is_action_just_pressed("ui_accept"):
		select_option()
	elif Input.is_action_just_pressed("ui_cancel"):
		if name == "Menu": get_tree().quit()
		else: switch_menu(0)
	elif Input.is_action_just_pressed("toggle_fullscreen"):
		call_deferred("update_fullscreen")
	elif Input.is_action_just_pressed("open_settings_folder"):
		OS.shell_open(OS.get_user_data_dir())
		get_tree().quit()

func switch_menu(index: int) -> void:
	main_menu.call_deferred("set_enabled", index == 0)
	options_menu.call_deferred("set_enabled", index == 1)
	weird_menu.call_deferred("set_enabled", index == 2)
	evil_menu.call_deferred("set_enabled", index == 3)
	update_option(0)

func update_option(index: int) -> void:
	if index < 0: index = total - 1
	index %= total
	
	children[selected].text = children[selected].text.replace(marker, "")
	children[index].text = marker + children[index].text
	selected = index

func set_enabled(value: bool) -> void:
	enabled = value
	visible = value
	set_process_input(enabled)

func select_option() -> void:
	var option: Label = children[selected]
	match option.name:
		"Start":
			if Settings.ransomware_mode:
				set_process_input(false)
				add_child(file_prompt.instantiate())
			else:
				get_tree().change_scene_to_file("res://scenes/game.tscn")
		"Options":
			switch_menu(1)
		"Weird":
			switch_menu(2)
		"Evil":
			switch_menu(3)
		"Quit":
			get_tree().quit()
		"Back":
			switch_menu(0)
		"Fullscreen":
			if Settings.toggle_fullscreen(): option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Mute":
			if Settings.toggle_mute(): option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Volume":
			Settings.negative_volume = not Settings.negative_volume
			bgm.set_reverse()
			if Settings.negative_volume: option.text = option.text.replace("100", "-100")
			else: option.text = option.text.replace("-100", "100")
		"Timer":
			Settings.timer = not Settings.timer
			if Settings.timer: option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Faster":
			Settings.faster = not Settings.faster
			if Settings.faster:
				option.text = option.text.replace("Disabled", "Enabled")
				title.text = title.text.replace("fast", "faster")
			else:
				option.text = option.text.replace("Enabled", "Disabled")
				title.text = title.text.replace("faster", "fast")
		"Transgender":
			Settings.trans = not Settings.trans
			if Settings.trans:
				option.text = option.text.replace("Disabled", "Enabled")
				title.text = title.text.replace("boy", "girl")
				Settings.set_text_colours(Settings.pink)
				$"../../../Background".texture = bg_boy
			else:
				option.text = option.text.replace("Enabled", "Disabled")
				title.text = title.text.replace("girl", "boy")
				Settings.set_text_colours(Settings.blue)
				$"../../../Background".texture = bg_girl
		"Colour":
			RenderingServer.set_default_clear_color(Color(randf(), randf(), randf()))
		"Color":
			Settings.change_c_spelling()
			update_c_spelling()
			$"../Weird/Color".text = marker + $"../Weird/Color".text
		"Murder":
			Settings.murder = not Settings.murder
			if Settings.murder: option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Explosion":
			Settings.explosion_has_damage = not Settings.explosion_has_damage
			if Settings.explosion_has_damage: option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Bullet":
			Settings.bullet_hell = not Settings.bullet_hell
			if Settings.bullet_hell: option.text = option.text.replace("Disabled", "Enabled")
			else: option.text = option.text.replace("Enabled", "Disabled")
		"Ads":
			Settings.ads = not Settings.ads
			ads.visible = Settings.ads
			var word = "boy"
			if Settings.trans: word = "girl"
			title.text = title.text.replace("™", "")
			if Settings.ads:
				option.text = option.text.replace("Enabled", "Disabled")
				title.text = title.text.replace(word, word + "™")
			else: option.text = option.text.replace("Disabled", "Enabled")
		"Ransomware":
			title.text = title.text.replace(".exe", "")
			Settings.ransomware_mode = not Settings.ransomware_mode
			if Settings.ransomware_mode:
				option.text = option.text.replace("Disabled", "Enabled")
				title.text += ".exe"
			else: option.text = option.text.replace("Enabled", "Disabled")

func update_fullscreen() -> void:
	if Settings.is_fullscreen(): fullscreen_option.text = fullscreen_option.text.replace("Disabled", "Enabled")
	else: fullscreen_option.text = fullscreen_option.text.replace("Enabled", "Disabled")

func update_mute() -> void:
	if Settings.mute: mute_option.text = mute_option.text.replace("Disabled", "Enabled")
	else: mute_option.text = mute_option.text.replace("Enabled", "Disabled")

func update_c_spelling() -> void:
	$"../Weird/Colour".text = "Change Background " + Settings.c_spelling
	$"../Weird/Color".text = "Change " + Settings.c_spelling
