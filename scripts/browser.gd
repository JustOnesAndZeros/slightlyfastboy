extends Panel

@onready var ransom: Control = $".."
@onready var cef: GDCef = $CEF
@onready var texture: TextureRect = $VBoxContainer/TextureRect
@onready var loading_anim = $VBoxContainer/TextureRect/AnimationPlayer
@onready var timer: Timer = $Timer
@onready var web_browser: GDBrowserView
@onready var home_button: Button = $VBoxContainer/HBoxContainer/Home
@onready var refresh_button: Button = $VBoxContainer/HBoxContainer/Refresh
@onready var back_button: Button = $VBoxContainer/HBoxContainer/Back
@onready var forward_button: Button = $VBoxContainer/HBoxContainer/Forward
const SUBSCRIBE_LINK = "https://www.youtube.com/@veryslowgirl?sub_confirmation=1"
const subscribed_html = "\"payload\":{\"subscriptionStateEntity\":{\"key\":\"EhhVQ2M2S1J5eEtxY1gwODAyWm9HT04ycUEgMygB\",\"subscribed\":true}}}"
const zoom_level = 1.5

func start() -> void:
	loading_anim.play("loading")
	var cache_path = OS.get_user_data_dir() + "/browser_cache"
	cef.initialize({"cache_path": cache_path, "root_cache_path": cache_path})
	web_browser = cef.create_browser(SUBSCRIBE_LINK, texture, {})
	web_browser.resize(texture.size / zoom_level)
	web_browser.on_html_content_requested.connect(_on_html_content_requested)
	web_browser.on_page_loaded.connect(_on_page_loaded)
	home_button.disabled = false
	refresh_button.disabled = false

func _input(event: InputEvent) -> void:
	if web_browser == null: return
	
	if Input.is_action_just_pressed("to_start_page"):
		_on_home_pressed()
	elif Input.is_action_just_pressed("refresh_page"):
		_on_refresh_pressed()
	elif event is InputEventKey:
		web_browser.set_key_pressed(
			event.unicode if event.unicode != 0 else event.keycode,
			event.pressed, event.shift_pressed, event.alt_pressed,
			event.is_command_or_control_pressed())

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if web_browser == null: return
	
	if event is InputEventMouseButton:
		match [event.button_index, event.pressed]:
			[MOUSE_BUTTON_LEFT, true]:
				web_browser.set_mouse_left_down()
			[MOUSE_BUTTON_LEFT, false]:
				web_browser.set_mouse_left_up()
			[MOUSE_BUTTON_RIGHT, true]:
				web_browser.set_mouse_right_down()
			[MOUSE_BUTTON_RIGHT, false]:
				web_browser.set_mouse_right_up()
			[MOUSE_BUTTON_WHEEL_DOWN, event.pressed]:
				web_browser.set_mouse_wheel_vertical(-2)
			[MOUSE_BUTTON_WHEEL_UP, event.pressed]:
				web_browser.set_mouse_wheel_vertical(2)
			[MOUSE_BUTTON_MIDDLE, true]:
				web_browser.set_mouse_middle_down()
			[MOUSE_BUTTON_MIDDLE, false]:
				web_browser.set_mouse_middle_up()
	elif event is InputEventMouseMotion:
		web_browser.set_mouse_moved(event.position.x / zoom_level, event.position.y / zoom_level)

func _process(delta: float) -> void:
	if web_browser == null: return
	back_button.disabled = not web_browser.has_previous_page()
	forward_button.disabled = not web_browser.has_next_page()

func _on_page_loaded(_browser: GDBrowserView) -> void:
	timer.start()
	await timer.timeout
	web_browser.request_html_content()

func _on_html_content_requested(html: String, _browser: GDBrowserView) -> void:
	if subscribed_html in html:
		home_button.disabled = true
		refresh_button.disabled = true
		back_button.disabled = true
		forward_button.disabled = true
		web_browser.close()
		ransom.attempt_decrypt_file()

func _on_home_pressed() -> void:
	web_browser.load_url(SUBSCRIBE_LINK)

func _on_refresh_pressed() -> void:
	web_browser.reload()

func _on_back_pressed() -> void:
	web_browser.previous_page()

func _on_forward_pressed() -> void:
	web_browser.next_page()
