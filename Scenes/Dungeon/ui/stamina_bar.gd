extends Control

@onready var stamina_bar_image = $stamina_bar_image
@onready var stamina_amount = $stamina_bar_image/stamina_amount

func set_stamina_level(amount : int, max : int):
	var bar_level = floori(((max-amount)*18) / 18)
	var amount_str : String = str(amount)
	var animation_level = "level_" + amount_str
	stamina_bar_image.play(animation_level)
	stamina_amount.text = str(amount) + " / " + str(max)
