extends Control


@onready var xp_bar_image = $bar_animation

func set_xp_level():
	var amount = PersistentPlayerData.get_current_xp()
	var bar_level = floori((amount*18) / (PersistentPlayerData.get_player_level()*18))
	var amount_str : String = str(bar_level)
	var animation_level = "level_" + amount_str
	xp_bar_image.play(animation_level)
