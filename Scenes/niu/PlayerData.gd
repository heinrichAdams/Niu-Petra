extends Node

var hotbar_contents = [
	"grass",
	"flower",
	"water"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hotbar_slot_contents(slot_number):
	return hotbar_contents[slot_number]
