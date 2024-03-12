extends Node2D

var weapon: Area2D

func _ready():
	if get_children().is_empty(): return
	
	weapon = get_children()[0]

func enable():
	if weapon:
		visible = true 
		weapon.enable()
	
func disable():
	if weapon:
		visible = false
		weapon.disable()
