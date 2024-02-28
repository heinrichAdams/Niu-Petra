extends Node
@onready var animated_sprite_2d = $Area2D/AnimatedSprite2D

signal Portal_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_area_2d_body_entered(body):
	print("<<<PORTAL ENTERED PORTAL ENTERED PORTAL ENTERED>>>")
	Portal_entered.emit()
	pass # Replace with function body.
