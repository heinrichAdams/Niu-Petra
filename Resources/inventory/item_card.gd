extends Control

@onready var item_image = $item_image_background/item_image
@onready var title = $title


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_image(image: Texture2D):
	if image != null:
		item_image = image
		
func set_title(text: String):
	if text != null:
		title.text = text

func clear():
	title.text = null
	item_image = null
