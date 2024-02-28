extends TileMap

@onready var timer = $"../Timer"

var grass_min : int = 1
var grass_max : int = 3

var flower_min : int = 1
var flower_max : int = 3

var current_tile_type : String
var current_tile_progression : int
var current_tile_location : Vector2i
var current_tile_atlas_coords : Vector2i
var modified_tile_atlas_coords : Vector2i

var tile_data : TileData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_timer_timeout():
	print("timer ended")
	for tile in get_used_cells(1):
		tile_data = get_cell_tile_data(1, Vector2i(tile.x, tile.y))
		if tile_data:
			current_tile_type = tile_data.get_custom_data("type")
			match current_tile_type:
				"grass":
					print("grass")
					current_tile_progression = tile_data.get_custom_data("grass_progression")
					if (current_tile_progression >= grass_min) and (current_tile_progression <= grass_max):
						current_tile_location = Vector2i(tile.x,tile.y)
						current_tile_atlas_coords = get_cell_atlas_coords(1,current_tile_location)
						modified_tile_atlas_coords.x = current_tile_atlas_coords.x
						modified_tile_atlas_coords.y = current_tile_atlas_coords.y + 4
						set_cell(1, current_tile_location, 3, modified_tile_atlas_coords)
		
				"flower":
					current_tile_progression = tile_data.get_custom_data("flower_progression")
					if (current_tile_progression >= flower_min) and (current_tile_progression <= flower_max):
						current_tile_location = Vector2i(tile.x,tile.y)
						current_tile_atlas_coords = get_cell_atlas_coords(1,current_tile_location)
						modified_tile_atlas_coords.x = current_tile_atlas_coords.x
						modified_tile_atlas_coords.y = current_tile_atlas_coords.y + 4
						set_cell(1, current_tile_location, 3, modified_tile_atlas_coords)
