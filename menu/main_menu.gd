extends Control

@onready var background_music = $background_music
@onready var button_click = $button_click


var timer : Timer = Timer.new()

func _on_play_pressed():
	button_click.play()
	timer.start(2)
	if timer.is_stopped():
		DirAccess.remove_absolute("user://tilemap_save_data.dat")
		get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_load_pressed():
	button_click.play()
	timer.start(2)
	if timer.is_stopped():
		get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_exit_pressed():
	button_click.play()
	timer.start(2)
	if timer.is_stopped():
		get_tree().quit()


func _on_background_music_finished():
	background_music.play()
