extends Control

@onready var health_bar_image = $health_bar_image
@onready var health_amount = $health_bar_image/health_amount


func set_health_level(amount : int, max : int):
	var bar_level = floori(((max-amount)*18) / 18)
	var amount_str : String = str(amount)
	var animation_level = "level_" + amount_str
	health_bar_image.play(animation_level)
	health_amount.text = str(amount) + " / " + str(max)
