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
	update.emit()

func get_item_at_slot(slot_number: int):
	if !slots[slot_number - 1].item:
		return "none"
	return slots[slot_number - 1].item.name

func remove(item: InventoryItem):
	var item_slots = slots.filter(func(slots): return slots.item == item)
	if !item_slots.is_empty():
		if item_slots[0].amount > 1:
			item_slots[0].amount -= 1
		else:
			item_slots[0].item = null
	else:
		var empty_slots = slots.filter(func(slots): return slots.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = null
			empty_slots[0].amount = 0
	update.emit()
