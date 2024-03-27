extends Resource

class_name Inventory

signal update

@export var slots: Array[Inventory_Slot]

func insert(item: InventoryItem):
	var item_slots = slots.filter(func(slots): return slots.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slots): return slots.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1

func get_item_at_slot(slot_number: int):
	if !slots[slot_number - 1].item:
		return "none"
	return slots[slot_number - 1].item.name

	
	update.emit()
