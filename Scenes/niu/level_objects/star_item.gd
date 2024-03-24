extends Area2D

@onready var inventory: Inventory = preload("res://Resources/inventory/player_inventory.tres")
var item_resource = preload("res://Resources/inventory/star_item.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	PersistentPlayerData.add_item_to_inventory("star")
	for i in inventory.items:
		if !i:
			i = item_resource
		
	for i in PersistentPlayerData.player_inventory:
		print("Item: ", i[0], " Amount: ", i[1])
	queue_free()
