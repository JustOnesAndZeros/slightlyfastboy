extends Timer

var popup_ad = preload("res://scenes/popup_ad.tscn")
const ad_chance = 0.7

func _ready() -> void:
	if Settings.ads: start()

func _on_timeout() -> void:
	if randf() < ad_chance:
		add_child(popup_ad.instantiate())
