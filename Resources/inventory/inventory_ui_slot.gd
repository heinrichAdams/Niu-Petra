extends Panel

@onready var item_image = $CenterContainer/Panel/item_image
@onready var label = $CenterContainer/Panel/Label


func update_slot(slot: Inventory_Slot):
	if !slot.item:
		item_image.visible = false 
		label.visible = false
	else:
		item_image.visible = true
		item_image.texture = slot.item.image
		label.visible = true
		label.text = str(slot.amount)
