extends Node2D


enum SELECTION{
	SLOT_1,
	SLOT_2,
	SLOT_3
}


var selected_slot : SELECTION = SELECTION.SLOT_1

@onready var player_data = $PlayerData
@onready var character_body_2d = $CharacterBody2D
@onready var target_box = $TargetBox
@onready var tile_map = $TileMap
const ground_layer : int = 1
const tilemap_id : int = 3
var desired_tile : Vector2i = Vector2i(0,0)
var distance_to_player = 0

var can_place_grass_tile = 0
var can_place_flower_tile = 0
var can_place_water_tile = 0

func _ready():
	character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
	pass


func _process(delta):
	pass


func _input(_event):
	
	if Input.is_action_just_pressed("LMB_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		var last_growth_level : int = 2
		desired_tile = tile_map.get_cell_atlas_coords(ground_layer,tile_mouse_pos)
		distance_to_player = target_box.global_position.distance_to(character_body_2d.global_position)
		plant(tile_mouse_pos)
		
		
	if Input.is_action_just_pressed("quick_save"):
		quick_save()
	
	if Input.is_action_just_pressed("quick_load"):
		quick_load()
		
	if Input.is_action_just_pressed("slot_1"):
		selected_slot = SELECTION.SLOT_1
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
		
	if Input.is_action_just_pressed("slot_2"):
		selected_slot = SELECTION.SLOT_2
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
			
	if Input.is_action_just_pressed("slot_3"):
		selected_slot = SELECTION.SLOT_3
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))

# QUICK_SAVE
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

# ENDOF QUICK_SAVE 

# QUICK_LOAD
func quick_load():
	var save_file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if save_file.file_exists("user://save_game.dat"):
		var saved_tile_data = save_file.get_var()
		for tile in saved_tile_data:
			tile_map.set_cell(ground_layer, tile[0], tilemap_id, tile[1])

# ENDOF QUICK_LOAD

# PLANT
func plant(tile_pos):
	
	var hotbar_item = player_data.get_hotbar_slot_contents(selected_slot)
	
	
	
	match hotbar_item:
		"grass":
			if distance_to_player < 150:
				var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
				if tile_data:
					can_place_grass_tile = tile_data.get_custom_data("can_place_grass")
				
				if can_place_grass_tile:
					var grass_tile : Vector2i = Vector2i(desired_tile.x,desired_tile.y + 4)
					tile_map.set_cell(ground_layer, tile_pos, tilemap_id, grass_tile)
			
		"flower":
			if distance_to_player < 150:
				var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
				if tile_data:
					can_place_flower_tile = tile_data.get_custom_data("can_place_flowers")
				
				if can_place_flower_tile:
					print("placed flower")
					var flower_tile : Vector2i = Vector2i(desired_tile.x,desired_tile.y + 4)
					tile_map.set_cell(ground_layer, tile_pos, tilemap_id, flower_tile)
		"water":
			if distance_to_player < 150:
				var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
				if tile_data:
					can_place_water_tile = tile_data.get_custom_data("can_place_water")
				
				if can_place_water_tile:
					var water_tile : Vector2i = Vector2i(0,1)
					tile_map.set_cell(ground_layer, tile_pos, tilemap_id, water_tile)


# ENDOF PLANT

# GROW


# ENDOF GROW
