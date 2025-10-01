extends Node

const save_path = "user://settings.json"

var last_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
const default_window_size: Vector2i = Vector2i(1280, 720)

var show_warning = true

const pink = "f5a9b8"
const blue = "5bcefa"

@onready var girl_texture = preload("res://sprites/slowgirl.png")
@onready var boy_texture = preload("res://sprites/fastboy.png")

var negative_volume = false
var mute = false

var timer = false
var faster = false
var trans = false

var c_spelling = "Colour"
var extra_spellings = ["Coler", "Coulour", "Coolor", "Coulr", "Coulour", "Coloor", "Culor", "Colorr", "Collour", "Kolor", "Culur", "Clour", "Cloor", "Color!", "C0l0r", "Cólor", "Colóur", "     "]

var evil_number = 666
var murder = false
var murder_count: int = 0

var explosion_has_damage = false

var bullet_hell = false

var ads = false

var ransomware_mode = false
var file_path = ""

var ls_title = preload("res://label settings/title.tres")
var ls_menu = preload("res://label settings/menu.tres")
var ls_option = preload("res://label settings/option.tres")
var ls_weird = preload("res://label settings/weird.tres")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(default_window_size)
	get_window().move_to_center()
	load_data()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"): toggle_fullscreen()

func disable_warning() -> void:
	show_warning = false
	call_deferred("save_data")

func set_text_colours(colour) -> void:
	ls_title.font_color = colour
	ls_menu.font_color = colour
	ls_option.font_color = colour
	ls_weird.font_color = colour

func toggle_fullscreen(save = true) -> bool:
	if is_fullscreen():
		DisplayServer.window_set_mode(last_window_mode)
		if save: call_deferred("save_data")
		return false
	else:
		last_window_mode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		call_deferred("save_data")
		return true

func is_fullscreen() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func toggle_mute(save = true) -> bool:
	mute = not mute
	AudioServer.set_bus_mute(0, mute)
	if save: call_deferred("save_data")
	return mute

func change_c_spelling() -> String:
	if c_spelling == "Colour": c_spelling = "Color"
	else: c_spelling = "Colour"
	if randf() < 0.1: c_spelling = extra_spellings.pick_random()
	call_deferred("save_data")
	return c_spelling

func save_data() -> void:
	var data = {"show_warning" : show_warning, "fullscreen" : is_fullscreen(), "mute_volume" : mute, "c_spelling" : c_spelling, "murder_count" : murder_count}
	var file_access = FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access: return
	file_access.store_line(JSON.stringify(data))
	file_access.close()

func load_data() -> void:
	if not FileAccess.file_exists(save_path): return
	var file_access = FileAccess.open(save_path, FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	var json = JSON.new()
	if json.parse(json_string): return
	var data: Dictionary = json.data
	show_warning = data.get("show_warning", show_warning)
	if data.get("fullscreen", false): toggle_fullscreen(false)
	if data.get("mute_volume", false): toggle_mute(false)
	c_spelling = data.get("c_spelling", c_spelling)
	murder_count = data.get("murder_count", murder_count)
