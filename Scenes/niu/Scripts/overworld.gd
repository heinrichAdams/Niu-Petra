extends Node2D

signal Load_Player_Data
signal Save_Player_Data

enum SELECTION{
	SLOT_1,
	SLOT_2,
	SLOT_3,
	SLOT_4,
	SLOT_5,
	SLOT_6
}

var crack_level_atlas = [
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(4,0)
]

var selected_slot : SELECTION = SELECTION.SLOT_1

var npc = preload("res://Scenes/niu/npc/grown_npc.tscn")
var npc_inventory_item = preload("res://Resources/inventory/npc_item.tres")

@onready var player_data = $PlayerData
@onready var character_body_2d = $CharacterBody2D
@onready var target_box = $TargetBox
@onready var tile_map = $TileMap
@onready var bgm = $bgm
@onready var break_sound = $break_sound

const ADJACENT_VECTORS = [
	Vector2i(0,1), 
	Vector2i(0,-1), 
	Vector2i(1,0), 
	Vector2i(-1,0), 
	Vector2i(1,1), 
	Vector2i(1,-1), 
	Vector2i(-1,1),
	Vector2i(-1,-1)
	]

const ground_layer : int = 1
const wall_layer : int = 3
const effects_layer : int = 5
const tilemap_id : int = 3
const wall_id : int = 4
var desired_tile : Vector2i = Vector2i(0,0)
var distance_to_player = 0
var isPaused : bool = false

var can_place_grass_tile = 0
var can_place_flower_tile = 0
var can_place_water_tile = 0

func _ready():
	character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
	quick_load()
	character_body_2d.set_selected_slot(1)



func _process(delta):
	pass

func _input(_event):
	
	if Input.is_action_just_pressed("LMB_click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		var last_growth_level : int = 2
		var hotbar_item = character_body_2d.get_item_at_selected_slot()
		desired_tile = tile_map.get_cell_atlas_coords(ground_layer,tile_mouse_pos)
		distance_to_player = target_box.global_position.distance_to(character_body_2d.global_position)
		
		if hotbar_item == "pickaxe":
			mine(tile_mouse_pos)
		else:
			plant(tile_mouse_pos)
		
		
	if Input.is_action_just_pressed("quick_save"):
		quick_save()
	
	if Input.is_action_just_pressed("quick_load"):
		quick_load()
		
	if Input.is_action_just_pressed("slot_1"):
		selected_slot = SELECTION.SLOT_1
		character_body_2d.set_selected_slot(1)
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
		
	if Input.is_action_just_pressed("slot_2"):
		selected_slot = SELECTION.SLOT_2
		character_body_2d.set_selected_slot(2)
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
			
	if Input.is_action_just_pressed("slot_3"):
		selected_slot = SELECTION.SLOT_3
		character_body_2d.set_selected_slot(3)
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
		
	if Input.is_action_just_pressed("slot_4"):
		selected_slot = SELECTION.SLOT_4
		character_body_2d.set_selected_slot(4)
		character_body_2d.set_temporary_hotbar_label(player_data.get_hotbar_slot_contents(selected_slot))
		
	if Input.is_action_just_pressed("slot_5"):
		selected_slot = SELECTION.SLOT_5
		character_body_2d.set_selected_slot(5)
		
	if Input.is_action_just_pressed("slot_6"):
		selected_slot = SELECTION.SLOT_6
		character_body_2d.set_selected_slot(6)
	
	pause_menu()

# QUICK_SAVE
func quick_save():
	var cell_atlas = 0
	var cell_location = 0
	var content = {
		"ground_tiles" : [],
		"wall_tiles" : []
	}
	
	var save_file = FileAccess.open("user://tilemap_save_data.dat", FileAccess.WRITE)
	
	# POPULATE GOUND LAYER
	for tile in tile_map.get_used_cells(ground_layer):
		cell_location = tile
		cell_atlas = tile_map.get_cell_atlas_coords(ground_layer, tile)
		
		content.get("ground_tiles").append([cell_location,cell_atlas])
		
	# POPULATE WALL LAYER
	for tile in tile_map.get_used_cells(wall_layer):
		cell_location = tile
		cell_atlas = tile_map.get_cell_atlas_coords(wall_layer, tile)
		
		content.get("wall_tiles").append([cell_location,cell_atlas])
		
	save_file.store_var(content)
	Save_Player_Data.emit()
	

# ENDOF QUICK_SAVE 

# QUICK_LOAD
func quick_load():
	var save_file = FileAccess.open("user://tilemap_save_data.dat", FileAccess.READ)
	if save_file:
		var saved_tile_data = save_file.get_var()
		
		# POPULATE GROUND LAYER
		var ground_tiles = saved_tile_data.get("ground_tiles")
		for tile in ground_tiles:
			tile_map.set_cell(ground_layer, tile[0], tilemap_id, tile[1])
			
		# POPULATE GROUND LAYER
		#var wall_tiles = saved_tile_data.get("wall_tiles")
		#for tile in wall_tiles:
			#tile_map.set_cell(wall_layer, tile[0], wall_id, tile[1])
		
		Load_Player_Data.emit()

# ENDOF QUICK_LOAD

# PLANT
func plant(tile_pos):
	
	var hotbar_item = character_body_2d.get_item_at_selected_slot()
	
	var is_empty_cell : int = tile_map.get_cell_source_id(wall_layer, tile_pos)
	if is_empty_cell != wall_id:
		match hotbar_item:
			"grass":
				if distance_to_player < 150:
					var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
					if tile_data:
						can_place_grass_tile = tile_data.get_custom_data("can_place_grass")
				
					if can_place_grass_tile:
						var grass_tile : Vector2i = Vector2i(desired_tile.x,desired_tile.y + 4)
						tile_map.set_cell(ground_layer, tile_pos, tilemap_id, grass_tile)
						character_body_2d.play_planting_animation()
						PersistentPlayerData.add_xp(1)
			
			"flower":
				if distance_to_player < 150:
					var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
					if tile_data:
						can_place_flower_tile = tile_data.get_custom_data("can_place_flowers")
				
					if can_place_flower_tile:
						print("placed flower")
						var flower_tile : Vector2i = Vector2i(desired_tile.x,desired_tile.y + 4)
						tile_map.set_cell(ground_layer, tile_pos, tilemap_id, flower_tile)
						character_body_2d.play_planting_animation()
						PersistentPlayerData.add_xp(1)
			"water":
				if distance_to_player < 150:
					var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
					if tile_data:
						can_place_water_tile = tile_data.get_custom_data("can_place_water")
				
					if can_place_water_tile:
						#var water_tile : Vector2i = Vector2i(0,1)
						#tile_map.set_cell(ground_layer, tile_pos, tilemap_id, water_tile)
						#var affected_tile_list: Array[Vector2i]
						#for i in tile_map.get_surrounding_cells(tile_pos):
							#for j in tile_map.get_surrounding_cells(i):
								#if j == tile_pos: continue
								#affected_tile_list.append(j)
						
						tile_map.erase_cell(ground_layer, tile_pos)
						#tile_map.set_cells_terrain_connect(ground_layer, affected_tile_list, 0,0,true)
			"npc":
				if distance_to_player < 150:
					var tile_data : TileData = tile_map.get_cell_tile_data(ground_layer, tile_pos)
					if tile_data:
						can_place_grass_tile = tile_data.get_custom_data("can_place_grass")
						can_place_flower_tile = tile_data.get_custom_data("can_place_flowers")
				
					if can_place_grass_tile || can_place_flower_tile:
						print("placed npc")
						var npc_instance = npc.instantiate()
						npc_instance.global_position.y = get_global_mouse_position().y
						npc_instance.global_position.x = get_global_mouse_position().x
						add_child(npc_instance)
						character_body_2d.play_planting_animation()
						character_body_2d.remove(npc_inventory_item)
						PersistentPlayerData.add_xp(1)

# ENDOF PLANT

# MINE
func mine(tile_pos):
	var is_valid_cell : bool = (tile_map.get_cell_source_id(wall_layer, tile_pos)) == wall_id
	if is_valid_cell and (distance_to_player < 150):
		character_body_2d.play_mining_animation()
		print("valid wall cell")
		var wall_tile_data : TileData = tile_map.get_cell_tile_data(wall_layer, tile_pos)
		var has_effect : bool = (tile_map.get_cell_source_id(effects_layer, tile_pos)) == wall_id
		
		if has_effect:
			var effect_tile_data : TileData = tile_map.get_cell_tile_data(effects_layer, tile_pos)
			var crack_level : int = effect_tile_data.get_custom_data("crack_level")
			if crack_level < 4:
				tile_map.set_cell(effects_layer, tile_pos, wall_id, crack_level_atlas[crack_level])
			elif crack_level >= 4:
				#var affected_tile_list: Array[Vector2i]
				#for i in tile_map.get_surrounding_cells(tile_pos):
				#	for j in tile_map.get_surrounding_cells(i):
				#		if j == tile_pos: continue
				#		affected_tile_list.append(j)
						
				#tile_map.erase_cell(effects_layer, tile_pos)
				#tile_map.erase_cell(wall_layer, tile_pos)
				#BetterTerrain.set_cell(tile_map, wall_layer, tile_pos, -1)
				#BetterTerrain.update_terrain_cells(tile_map, wall_layer, affected_tile_list)
				clear_cell_from_position(tile_pos)
				PersistentPlayerData.add_xp(2)
				break_sound.play()
				
		else:
			tile_map.set_cell(effects_layer, tile_pos, wall_id, crack_level_atlas[0])
			
		
# ENDOF MINE

func _on_portal_portal_entered():
	print("PORTAL SIGNAL RECIEVED")
	
	quick_save()
	get_tree().change_scene_to_file("res://Scenes/Dungeon/dungeon.tscn")
	pass # Replace with function body.


func pause_menu():
	if Input.is_action_just_pressed("pause"):
		if isPaused:
			get_tree().paused = false
			isPaused = false
		else:
			get_tree().paused = true
			isPaused = true
			

func _on_bgm_finished():
	bgm.play()

func clear_cell_from_position(position):
	#var cell = tile_map.local_to_map(position)
	#if cell != null:
		var cells_to_be_updated = []
		#tile_map.set_cell(wall_layer, position, wall_id, Vector2i(-1,-1))
		#tile_map.set_cell(effects_layer, position, wall_id, Vector2i(-1,-1))
		
		##tile_map.erase_cell(wall_layer, position)
		for neighboring_cell in ADJACENT_VECTORS:
			if tile_map.get_cell_tile_data(wall_layer, position + neighboring_cell) != null:
				cells_to_be_updated.append(position + neighboring_cell)
		
		#tile_map.set_cells_terrain_connect(wall_layer, cells_to_be_updated, 1, 0, true)
		BetterTerrain.set_cell(tile_map, wall_layer, position, -1)
		BetterTerrain.update_terrain_cells(tile_map, wall_layer, cells_to_be_updated)
		tile_map.erase_cell(effects_layer, position)


func on_grown_npc_mouse_left_npc():
	print("SIGNAL RECIEVED BY MAIN SCRIPT")


func on_grown_npc_mouse_over_npc():
	print("SIGNAL RECIEVED BY MAIN SCRIPT")
