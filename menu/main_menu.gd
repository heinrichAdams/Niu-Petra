extends Control

@onready var background_music = $background_music
@onready var button_click = $button_click
@onready var button_hover = $button_hover
@onready var menu_character = $menu_character

var timer 

func _ready():
	menu_character.play("main")

func _on_play_pressed():
	button_click.play()
	timer = get_tree().create_timer(2)
	if timer.timeout:
		DirAccess.remove_absolute("user://tilemap_save_data.dat")
		get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_load_pressed():
	button_click.play()
	timer = get_tree().create_timer(2)
	if timer.timeout:
		get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_exit_pressed():
	button_click.play()
	timer = get_tree().create_timer(2)
	if timer.timeout:
		get_tree().quit()



func _on_background_music_finished():
	background_music.play()


func _on_play_mouse_entered():
	button_hover.play()


func _on_exit_mouse_entered():
	button_hover.play()


func _on_load_mouse_entered():
	button_hover.play()
