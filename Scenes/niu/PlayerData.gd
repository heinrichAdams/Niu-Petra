extends Node

@onready var character_body_2d = $"../CharacterBody2D"


var hotbar_contents = [
	"grass",
	"flower",
	"water",
	"pickaxe"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hotbar_slot_contents(slot_number):
	return hotbar_contents[slot_number]


func _on_overworld_load_player_data():
	var save_file = FileAccess.open("user://player_save_data.dat", FileAccess.READ)
	if save_file.file_exists("user://player_save_data.dat"):
		var content = save_file.get_var() 
		
		hotbar_contents[0] = content.get("hotbar_contents")[0]
		hotbar_contents[1] = content.get("hotbar_contents")[1]
		hotbar_contents[2] = content.get("hotbar_contents")[2]
		hotbar_contents[3] = content.get("hotbar_contents")[3]
		
		print("loaded hotbar")
		
		var new_location : Vector2 = content.get("player_location")
		new_location.x = 10
		new_location.y = 10 
		character_body_2d.position = new_location
		
		print("loaded player position")
	

func _on_overworld_save_player_data():
	var content = {
		"hotbar_contents" : [],
		"player_location" : Vector2()
	}
	var save_file = FileAccess.open("user://player_save_data.dat", FileAccess.WRITE)
	
	# SAVE HOTBAR
	content.get("hotbar_contents").append(hotbar_contents[0])
	content.get("hotbar_contents").append(hotbar_contents[1])
	content.get("hotbar_contents").append(hotbar_contents[2])
	content.get("hotbar_contents").append(hotbar_contents[3])
	print("saved hotbar")
	
	# SAVE PLAYER LOCATION
	content["player_location"] = character_body_2d.position
	print("saved player location")
	
	save_file.store_var(content)
