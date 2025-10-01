extends Window

@onready var parent = $".."
@onready var ad: Sprite2D = $Ad
var ad_scale = 2

func _ready() -> void:
	update_ad_scale()
	update_window_size()
	set_random_position()
	call_deferred("set_window_title")

func update_ad_scale() -> void:
	ad.scale *= ad_scale
	ad.position *= ad_scale

func update_window_size() -> void:
	var ad_size = ad.texture.get_size()
	ad_size.x /= ad.hframes
	ad_size.y /= ad.vframes
	ad_size *= ad_scale
	size = ad_size

func set_random_position() -> void:
	var bounds = DisplayServer.screen_get_size(DisplayServer.MAIN_WINDOW_ID) - size
	position = DisplayServer.screen_get_position() + Vector2i(floori(randf() * bounds.x), floori(randf() * bounds.y))

func _on_close_requested() -> void:
	queue_free()

func set_window_title() -> void:
	var titles = []
	match ad.frame:
		0:
			titles = ["NO JAMES NO", "BUY NOW!!!!!!", "WIERD MONEY", "WIERD JAMES IS HERE", "I AM NOT ASKING", "STRANGE JOHN WOULD NEVER"]
		1:
			titles = ["GIRL GO FAST", "FASTEST GIRL", "STILL SLOW BUT AT LEAST I'M A GIRL", "GIRL SLOW DOWN", "GENDER SPEEDRUN", "WOKE AD"]
		2:
			titles = ["BEST DECISION I EVER MADE", "EVERYONE ISN'T ENOUGH", "UNDERTALE REFERENCE", "ONLY THE FASTEST BOYS COMMIT GENOCIDE", "ONLY £4.99", "GET TO " + str(Settings.evil_number) + " MURDERS FOR A SECRET MODE"]
		3:
			titles = [":(", "I AM GOING TO CRY", "RIP", "GOT TOO WEIRD", "I CAN'T WAIT FOR THE SEQUEL", "GONER JAMES", "HOLY SHIT IS THAT WINGLE DINGLE!?"]
		4:
			titles = ["WEIRD JAMES IS MY NEW RELIGION", "WE HAVE SNACKS", "DO PEOPLE STILL USE REDDIT?", "WEIRD JAMES > GOD", "ACCEPTING DONATIONS"]
		5:
			titles = ["WHAT THE FUCK IS A PORTALPILLED?", "MODERATELYSTATIONARYPERSON", "AVERAGESPEEDNONBINARY", "MY NAME IS LITERALLY BINARY", "THERE ARE MULTIPLE GENDERS???", "THERE ARE ONLY 2 NUMBERS: 0 and 1!"]
		6:
			titles = ["COMING IN 2025", "THIS IS NOT VERY WEIRD", "THE FINAL CHAPTER: PART 1: EPISODE 2", "THE LORE IS REALLY GOOD I PROMISE", "INDIE GOTY"]
		7:
			titles = ["I WISH I WASN'T SINGLE", "THEY PUT MY BOY ON A CIRCLE", "THIS IS HIS CANON HEIGHT", "IS IT SPELLED DISC OR DISK?", "LOOK AT HIM SPIN!"]
		8:
			titles = ["AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", "PLEASE...", "BATTERIES NOT INCLUDED", "CHARGE TO 300% INSTANTLY", "NIKOLA TESLA DIED FOR THIS"]
		9:
			titles = ["IS THAT THE GUY WHO MADE THE IPHONE?", "NOT SUITABLE FOR VEGETARIANS", "FREE APPLE WITH EVERY PURCHASE", "I MISS HIM", "THE BINDING OF ISAAC: REBIRTH"]
		10:
			titles = ["SLIGHTLYFASTGPT MADE THIS GAME FOR ME", "GOINGLE 'TILL YOU POINGLE", "WE PAY OUR INTERNS IN DATA", "I'M SO LONELY", "BETTER THAN REAL FRIENDS", "FIRST 10 MESSAGES FREE!"]
		11:
			titles = ["I HAVEN'T BEEN OUTSIDE IN 3 WEEKS", "NOT ENOUGH PIXELS", "SLOW GIRLS NEAR YOU", "MUST BE AT LEAST 18x18 PIXELS", "NO FAST BOYS ALLOWED!", "NOW WITH EVEN MORE LESBIANS!"]
		12:
			titles = ["BECOME A SLOW GIRL TODAY", "I AM RIGHT BEHIND YOU", "YOU ARE GOING TOO FAST", "LOOK AT MY WEBSITE!", "SUBSCRIBE TO VERYSLOWGIRL"]
		13:
			titles = ["DON'T DRINK THE GREEN", "GET YOUR GOOP TODAY", "01000111 01101111 01110100 01110100 01100101 01101101", "I'M SO SMART", "SLIGHTLYGREENBOY"]
		14:
			titles = ["I DON'T KNOW HOW MONEY WORKS", "PLEASE BUY MY CRYPTOCURRENCY", "COMMIT TAX EVASION", "THE MONEY IS GETTING BIGGER", "THE LINE IS GOING SOMWHERE"]
	title = titles.pick_random()
