extends Control

@onready var inventory: Inventory = preload("res://Resources/inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false 

func _ready():
	inventory.update.connect(update_slots)
	close()
	
func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update_slot(inventory.slots[i])
	
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
	
func close():
	visible = false
	is_open = false
	
func open():
	update_slots()
	visible = true
	is_open = true
