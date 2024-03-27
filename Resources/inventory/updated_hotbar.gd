extends Control

@export var inventory: Inventory
@onready var slots: Array 

@onready var selection_box_1 = $hotbar_image/selected_box
@onready var selection_box_2 = $hotbar_image/selected_box2
@onready var selection_box_3 = $hotbar_image/selected_box3
@onready var selection_box_4 = $hotbar_image/selected_box4
@onready var selection_box_5 = $hotbar_image/selected_box5
@onready var selection_box_6 = $hotbar_image/selected_box6


func _ready():
	for i in $hotbar_image.get_children():
		if i.get_class() == "Panel":
			slots.append(i)
	
	inventory.update.connect(update_hotbar_slots)
	
func update_hotbar_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update_slot(inventory.slots[i])
	
func selected_slot(slot_number: int):
	match slot_number:
		1:
			selection_box_1.visible = true
			selection_box_2.visible = false
			selection_box_3.visible = false
			selection_box_4.visible = false
			selection_box_5.visible = false
			selection_box_6.visible = false
			
		2:
			selection_box_1.visible = false
			selection_box_2.visible = true
			selection_box_3.visible = false
			selection_box_4.visible = false
			selection_box_5.visible = false
			selection_box_6.visible = false
			
		3:
			selection_box_1.visible = false
			selection_box_2.visible = false
			selection_box_3.visible = true
			selection_box_4.visible = false
			selection_box_5.visible = false
			selection_box_6.visible = false
			
		4:
			selection_box_1.visible = false
			selection_box_2.visible = false
			selection_box_3.visible = false
			selection_box_4.visible = true
			selection_box_5.visible = false
			selection_box_6.visible = false
			
		5:
			selection_box_1.visible = false
			selection_box_2.visible = false
			selection_box_3.visible = false
			selection_box_4.visible = false
			selection_box_5.visible = true
			selection_box_6.visible = false
			
		6:
			selection_box_1.visible = false
			selection_box_2.visible = false
			selection_box_3.visible = false
			selection_box_4.visible = false
			selection_box_5.visible = false
			selection_box_6.visible = true
			
