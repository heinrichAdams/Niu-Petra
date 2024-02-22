extends Node2D


@onready var character_body_2d = $CharacterBody2D
@onready var target_box = $TargetBox
@onready var tile_map = $TileMap
const ground_layer : int = 1
const tilemap_id : int = 3
var desired_tile : Vector2i = Vector2i(0,0)
var distance_to_player = 0


func _ready():
	pass


func _process(delta):
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("LMB_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		
		desired_tile = tile_map.get_cell_atlas_coords(ground_layer,tile_mouse_pos)
		if desired_tile.y <= 10:
			desired_tile.y += 4
		
		distance_to_player = target_box.global_position.distance_to(character_body_2d.global_position)
		
		if distance_to_player < 150:
			tile_map.set_cell(ground_layer, tile_mouse_pos, tilemap_id, desired_tile)
			
	if Input.is_action_just_pressed("quick_save"):
		quick_save()
	
	if Input.is_action_just_pressed("quick_load"):
		quick_load()


func quick_save():
	var cell_atlas = 0
	var cell_location = 0
	var cell_data = []
	
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	for tile in tile_map.get_used_cells(ground_layer):
		cell_location = tile
		cell_atlas = tile_map.get_cell_atlas_coords(ground_layer, tile)
		
		cell_data.append([cell_location,cell_atlas])
		
	save_file.store_var(cell_data)
	
func quick_load():
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if save_file.file_exists("user://save_game.dat"):
		var saved_tile_data = save_file.get_var()
		for tile in saved_tile_data:
			tile_map.set_cell(ground_layer, tile[0], tilemap_id, tile[1])

