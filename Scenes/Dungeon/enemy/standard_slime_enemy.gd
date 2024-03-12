extends CharacterBody2D

@export var speed = 80
@export var limit = 0.5
@export var world_end_point : Marker2D 

@onready var animated_sprite_2d = $AnimatedSprite2D

var start_point
var end_point
var isAlive = true

func _ready():
	start_point = position
	end_point = Vector2(world_end_point.global_position.x,position.y)
	
func update_velocity():
	var move_direction = end_point - position
	if move_direction.length() < limit:
		change_direction()
		
	velocity = move_direction.normalized() * speed
	
func update_animation():
	animated_sprite_2d.flip_h = false
	var animation_direction = "left_move"
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
		animation_direction = "right_move"
	
	animated_sprite_2d.play(animation_direction)
	
func change_direction():
	var temp_end_point = end_point
	end_point = start_point
	start_point = temp_end_point
	
func _physics_process(delta):
	if isAlive:
		update_velocity()
		move_and_slide()
		update_animation()


func _on_hurtbox_area_entered(area):
	if area == $hitbox: return
	isAlive = false
	animated_sprite_2d.play("left_die")
	
	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "left_die":
		queue_free()
