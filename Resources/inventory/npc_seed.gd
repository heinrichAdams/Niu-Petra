extends Area2D

@onready var inventory: Inventory = preload("res://Resources/inventory/player_inventory.tres")
@export var item: InventoryItem
@export var inDungeon : bool 
var player = null
@onready var animation_player = $AnimationPlayer
@onready var item_card = $item_card

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("item_animation")
	item_card.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	PersistentPlayerData.add_item_to_inventory("npc_seed")
	player = body
	player.collect(item)
	if !inDungeon:
		player.update_hotbar_contents()
		
	for i in PersistentPlayerData.player_inventory:
		print("Item: ", i[0], " Amount: ", i[1])
	queue_free()

func interpolate_size():
	pass


func _on_mouse_entered():
	item_card.visible = true
	
func _on_mouse_exited():
	item_card.visible = false
