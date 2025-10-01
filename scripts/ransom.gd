extends Control

@onready var browser: Panel = $Browser
@onready var popup: AcceptDialog = $AcceptDialog
@onready var loading: Window = $LoadingWindow
@onready var progress_bar: ProgressBar = $LoadingWindow/ProgressBar
const encrypt_success_message = "Your file has been encrypted >:3\nTo get it back, subscribe to veryslowgirl and refresh the page"
const encrypt_failure_message = "I couldn't encrypt your file. I have been outsmarted >:("
const decrypt_success_message = "Your file has been decrypted :)"
const decrypt_failure_message = "I couldn't decrypt your file :("
const bytes_per_frame = 1024 * 1024

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	attempt_encrypt_file()

func attempt_encrypt_file() -> void:
	loading.title = "Encrypting file"
	if await flip_file(): show_popup(encrypt_success_message)
	else: show_popup(encrypt_failure_message)

func attempt_decrypt_file() -> void:
	loading.title = "Decrypting file"
	if await flip_file(): show_popup(decrypt_success_message)
	else: show_popup(decrypt_failure_message)

func flip_file() -> bool:
	var file = FileAccess.open(Settings.file_path, FileAccess.READ_WRITE)
	if FileAccess.get_open_error(): return false
	progress_bar.value = 0
	if file.get_length() > bytes_per_frame: loading.visible = true
	var success: bool = await flip_text(file)
	file.close()
	loading.visible = false
	return success

func flip_text(file: FileAccess) -> bool:
	var text: PackedByteArray = FileAccess.get_file_as_bytes(Settings.file_path)
	progress_bar.max_value = len(text)
	for i in range(len(text)):
		text[i] = (text[i] + 128) % 256
		progress_bar.value += 1
		if i % bytes_per_frame == 0: await get_tree().process_frame
	if not file.store_buffer(text): return false
	return true

func show_popup(new_text: String):
	popup.dialog_text = new_text
	popup.call_deferred("move_to_center")
	popup.visible = true

func _on_popup_closed() -> void:
	if popup.dialog_text == encrypt_success_message:
		browser.start()
	else:
		OS.shell_open("https://veryslowgirl.github.io/")
		get_tree().quit()
