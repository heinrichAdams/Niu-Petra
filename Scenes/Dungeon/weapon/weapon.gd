extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

func enable():
	collision_shape_2d.disabled = false
	
func disable():
	collision_shape_2d.disabled = true
	
