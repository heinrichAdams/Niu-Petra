extends Node

var xp_amount = 1
var player_level = 1
var required_xp_multiplier = 2
var required_xp_for_level_up = 18

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
	
	
func get_current_xp():
	return xp_amount
	
func get_player_level():
	return player_level
	
func add_xp(amount: int):
	if (xp_amount + amount) > required_xp_for_level_up:
		player_level += 1
		xp_amount = 1
		required_xp_for_level_up = player_level * 18
	else: 
		xp_amount += amount
