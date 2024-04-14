extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0


func _ready():
	animated_sprite_2d.play("grow")

func _physics_process(delta):


	


	move_and_slide()
