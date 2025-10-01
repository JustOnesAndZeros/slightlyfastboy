extends VBoxContainer

var children
var selected = 0
var total
const marker = "> "

func _ready() -> void:
	if not Settings.show_warning:
		call_deferred("load_main_menu")
		return
	
	children = get_children()
	total = len(children)
	update_option(selected)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_down"):
		update_option(selected + 1)
	elif Input.is_action_just_pressed("move_up"):
		update_option(selected - 1)
	elif Input.is_action_just_pressed("ui_accept"):
		select_option()
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func load_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func update_option(index: int) -> void:
	if index < 0: index = selected - 1
	index %= total
	
	children[selected].text = children[selected].text.replace(marker, "")
	children[index].text = marker + children[index].text
	selected = index

func select_option() -> void:
	var option: Label = children[selected]
	match option.name:
		"Ok":
			call_deferred("load_main_menu")
		"No":
			Settings.disable_warning()
			call_deferred("load_main_menu")
		"Quit":
			get_tree().quit()
