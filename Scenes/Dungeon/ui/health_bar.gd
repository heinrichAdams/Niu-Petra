extends Control

@onready var health_bar_image = $health_bar_image

func set_health_level(amount : int):
	var amount_str : String = str(amount)
	var animation_level = "level_" + amount_str
	health_bar_image.play(animation_level)
