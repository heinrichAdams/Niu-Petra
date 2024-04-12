extends Control

@onready var stamina_bar_image = $stamina_bar_image

func set_stamina_level(amount : int):
	var amount_str : String = str(amount)
	var animation_level = "level_" + amount_str
	stamina_bar_image.play(animation_level)
