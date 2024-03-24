extends Panel

@onready var item_image = $CenterContainer/Panel/item_image

func update_slot(item: InventoryItem):
	if !item:
		item_image.visible = false 
	else:
		item_image.visible = true
		item_image.texture = item.image
