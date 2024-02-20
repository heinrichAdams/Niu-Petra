extends Sprite2D

@onready var tile_map = $"../TileMap"
@onready var character_body_2d = $"../CharacterBody2D"
var mouse_pos : Vector2 = Vector2(0,0)
var mouse_tile_pos : Vector2i = Vector2i(0,0)
var distance_from_player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	mouse_tile_pos = tile_map.local_to_map(mouse_pos)
	distance_from_player = global_position.distance_to(character_body_2d.global_position)
	
	position.x = (mouse_tile_pos.x + .5) * 64
	position.y = (mouse_tile_pos.y + .5 ) * 64 
	
	var is_in_range : bool = distance_from_player > 150
	
	if is_in_range:
		self_modulate = Color(1,0,0)
	else:
		self_modulate = Color(1,1,1)
	

