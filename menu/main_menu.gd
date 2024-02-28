extends Control


func _on_play_pressed():
	
	DirAccess.remove_absolute("user://tilemap_save_data.dat")
	get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_load_pressed():
	get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")


func _on_exit_pressed():
	get_tree().quit()
