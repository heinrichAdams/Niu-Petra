extends Node

var player_inventory = [
]

func add_item_to_inventory(item: String):
	if player_inventory.size() >= 12:
		print("Inventory Full, Cannot Carry Any More")
		return
	for i in player_inventory:
		if i[0] == item:
			i[1] += 1
			return 
	
	player_inventory.append([item, 1])
