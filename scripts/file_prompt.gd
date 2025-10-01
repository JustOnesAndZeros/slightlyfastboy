extends Node

@onready var file_dialog = $FileDialog
@onready var accept_dialog = $AcceptDialog

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	accept_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	file_dialog.visible = false
	Settings.file_path = path
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_file_dialog_canceled() -> void:
	cancel()

func _on_accept_dialog_confirmed() -> void:
	file_dialog.visible = true

func _on_accept_dialog_canceled() -> void:
	cancel()

func cancel() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_parent().set_process_input(true)
	queue_free()
