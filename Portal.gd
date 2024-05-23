extends Node

@onready var teleport = $teleport

signal Portal_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_area_2d_body_entered(body):
	print("<<<PORTAL ENTERED PORTAL ENTERED PORTAL ENTERED>>>")
	teleport.play()
	Portal_entered.emit()
	pass # Replace with function body.
