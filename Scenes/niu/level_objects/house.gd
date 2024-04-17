extends Node2D

@onready var animation_player = $Area2D/AnimationPlayer
@export var house_image : Texture
@onready var sprite_2d = $Area2D/Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = house_image
	animation_player.play("interpolate_light")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
