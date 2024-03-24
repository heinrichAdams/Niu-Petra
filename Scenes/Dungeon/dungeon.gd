extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_killbox_2_killbox_entered():
	get_tree().change_scene_to_file("res://Scenes/Dungeon/player_death/death_screen.tscn")

func _on_dungeon_portal_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")
