extends CharacterBody2D

@export var speed = 80
@export var limit = 0.5
@export var world_end_point : Marker2D 

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_level = $health_level
@onready var hit_timer = $hit_timer


var start_point
var end_point
var isAlive = true
var max_health = 3
var current_health = max_health

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
		update_health_meter()
		update_velocity()
		move_and_slide()
		update_animation()


func _on_hurtbox_area_entered(area):
	if area == $hitbox: return
	if (current_health - 1) > 0:
		current_health -= 1
		hit_timer.start()
		animated_sprite_2d.modulate = Color(1,0,0,0.5)
		await hit_timer.timeout
		animated_sprite_2d.modulate = Color(1,1,1,1)
		return
	isAlive = false
	animated_sprite_2d.modulate = Color(1,0,0,0.5)
	animated_sprite_2d.play("left_die")
	
	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "left_die":
		queue_free()

func update_health_meter():
	var health_str = str(current_health)
	var max_health_str = str(max_health)
	health_level.text = health_str + " / " + max_health_str
	
