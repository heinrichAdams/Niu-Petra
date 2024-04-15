extends Node2D

@onready var rock_monster = $rock_monster
@onready var player_in_dungeon = $TileMap/Player_In_Dungeon

var distance_between_rock_monster_and_player = null
var player_is_within_distance_of_rock_monster = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rock_monster != null:
		distance_between_rock_monster_and_player = rock_monster.global_position.distance_to(player_in_dungeon.global_position)
		player_is_within_distance_of_rock_monster = distance_between_rock_monster_and_player < 400
		rock_monster.face_player(player_in_dungeon.global_position)
		rock_monster.try_to_attack(player_is_within_distance_of_rock_monster)
	



func _on_killbox_2_killbox_entered():
	get_tree().change_scene_to_file("res://Scenes/Dungeon/player_death/death_screen.tscn")

func _on_dungeon_portal_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/niu/Niu.tscn")

