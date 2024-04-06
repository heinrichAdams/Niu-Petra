extends Control

var menu_visible : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if menu_visible:
			close()
		else:
			open()

func close():
	visible = false
	menu_visible = false
	get_tree().paused = false
	pass
	
func open():
	visible = true
	menu_visible = true
	get_tree().paused = true
	pass


func _on_no_button_pressed():
	close()


func _on_yes_button_pressed():
	get_tree().quit()
