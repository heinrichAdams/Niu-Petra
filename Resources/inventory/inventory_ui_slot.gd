extends Panel

@onready var item_image = $CenterContainer/Panel/item_image
@onready var label = $CenterContainer/Panel/Label

signal mouse_hover
signal mouse_leave

func update_slot(slot: Inventory_Slot):
	if !slot.item:
		item_image.visible = false 
		label.visible = false
	else:
		item_image.visible = true
		item_image.texture = slot.item.image
		label.visible = true
		label.text = str(slot.amount)



func _on_panel_mouse_entered():
	mouse_hover.emit()
	return item_image.texture

func _on_panel_mouse_exited():
	mouse_leave.emit()
