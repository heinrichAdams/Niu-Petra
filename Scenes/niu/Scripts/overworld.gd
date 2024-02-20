extends Node2D

@onready var character_body_2d = $CharacterBody2D
@onready var target_box = $TargetBox
@onready var tile_map = $TileMap
const ground_layer : int = 1
const tilemap_id : int = 3
const GRASS_COORDINATES : Vector2i = Vector2i(9,17)
var distance_to_player = 0

func _ready():
	pass


func _process(delta):
	pass


func _input(_event):
	if Input.is_action_just_pressed("LMB_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		distance_to_player = target_box.global_position.distance_to(character_body_2d.global_position)
		
		if distance_to_player < 150:
			tile_map.set_cell(ground_layer, tile_mouse_pos, tilemap_id, GRASS_COORDINATES)





