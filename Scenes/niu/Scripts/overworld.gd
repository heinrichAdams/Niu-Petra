extends Node2D

@onready var tile_map : TileMap = $TileMap
var ground_layer : int = 1
var environment_layer  : int = 2
var tilemap_source_id : int = 5
var tile_data : TileData = null
var can_place_seed_CD : String = "can_place_seed"
var can_place_dirt_CD : String = "can_place_dirt"
var can_place_tile : bool = false
var dirt_tiles = []
var min_seed_level : int = 0
var max_seed_level : int = 3

enum TILE_PLACEMENT_MODE {SEED,DIRT}

var placement_mode : TILE_PLACEMENT_MODE = TILE_PLACEMENT_MODE.SEED

func _ready():
	pass


func _process(delta):
	pass


func _input(_event):
	
	var mouse_vector_pos : Vector2 = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = tile_map.local_to_map(mouse_vector_pos)
	
	
	
	if Input.is_action_just_pressed("toggle_dirt"):
		placement_mode = TILE_PLACEMENT_MODE.DIRT
	
	if Input.is_action_just_pressed("toggle_seed"):
		placement_mode = TILE_PLACEMENT_MODE.SEED
	
	
	if Input.is_action_just_pressed("LMB_click"):
		tile_data = tile_map.get_cell_tile_data(ground_layer, mouse_tile_pos)
		
		match placement_mode:
			TILE_PLACEMENT_MODE.SEED:
				
				can_place_tile = get_custom_data_from_tile(mouse_tile_pos, can_place_seed_CD, ground_layer)
				if can_place_tile:
					var tile_coordinates : Vector2i = Vector2i(11,1)
					handle_seed(mouse_tile_pos, min_seed_level, tile_coordinates, max_seed_level)
					
			TILE_PLACEMENT_MODE.DIRT:
				
				can_place_tile = get_custom_data_from_tile(mouse_tile_pos, can_place_dirt_CD, ground_layer)
				if can_place_tile:
					dirt_tiles.append(mouse_tile_pos)
					tile_map.set_cells_terrain_connect(ground_layer, dirt_tiles, 2, 0)
		
		
#################################
# GET TILE DATA                 #
#################################
func get_custom_data_from_tile(mouse_tile_pos : Vector2i, custom_data_layer : String, layer : int):
	tile_data = tile_map.get_cell_tile_data(layer, mouse_tile_pos)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false
	
#################################
# HANDLE SEEDS                  #
#################################

func handle_seed(tile_pos, stage, tile_coordinates, last_tile):
	
	tile_map.set_cell(environment_layer, tile_pos, tilemap_source_id, tile_coordinates)
	
	await get_tree().create_timer(5.0).timeout
	
	if stage == last_tile:
		return
	else:
		var new_coord : Vector2i = Vector2i(tile_coordinates.x + 1, tile_coordinates.y)
		handle_seed(tile_pos, stage + 1, new_coord, last_tile)
		
