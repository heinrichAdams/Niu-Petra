extends CharacterBody2D

@onready var attack_timer = $attack_timer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $hitbox
@onready var hit_timer = $hit_timer
@onready var health_level = $health_level

enum DIRECTION{
	LEFT,
	RIGHT
}

var direction : DIRECTION = DIRECTION.RIGHT
var player : Area2D = null
var can_see_player : bool = false
var should_wait : bool = false
var isAlive : bool = true

var max_health = 3
var current_health = 3

func _ready():
	pass

func _physics_process(delta):
	if !isAlive:
		queue_free()
	update_health_meter()
	animate()


func face_player(player_position : Vector2):
	if player_position.x > position.x:
		direction = DIRECTION.RIGHT
	else:
		direction = DIRECTION.LEFT
	pass

func try_to_attack(within_range : bool):
	if within_range:
		can_see_player = true 
	else:
		can_see_player = false
		
func animate():
	match direction:
		DIRECTION.RIGHT:
			# can see player
			if can_see_player and !should_wait:
				animated_sprite_2d.play("hit_right")
				hitbox.set_collision_layer_value(1,true)
				hitbox.set_collision_mask_value(1,true)
				await animated_sprite_2d.animation_finished
				hitbox.set_collision_layer_value(1,false)
				hitbox.set_collision_mask_value(1,false)
				attack_timer.start()
				should_wait = true
			if can_see_player and should_wait:
				animated_sprite_2d.play("idle_right")
				if attack_timer.is_stopped():
					should_wait = false
			# cant see player
			if !can_see_player:
				animated_sprite_2d.play("idle_right")
		DIRECTION.LEFT:
			# can see player
			if can_see_player and !should_wait:
				animated_sprite_2d.play("hit_left")
				hitbox.set_collision_layer_value(1,true)
				hitbox.set_collision_mask_value(1,true)
				await animated_sprite_2d.animation_finished
				hitbox.set_collision_layer_value(1,false)
				hitbox.set_collision_mask_value(1,false)
				attack_timer.start()
				should_wait = true
			if can_see_player and should_wait:
				animated_sprite_2d.play("idle_left")
				if attack_timer.is_stopped():
					should_wait = false
			# cant see player
			if !can_see_player:
				animated_sprite_2d.play("idle_left")


#func _on_player_detection_area_entered(area):
	#if area == $hitbox: return
	#if area.global_position.x > global_position.x:
		#direction = DIRECTION.RIGHT
	#else:
		#direction = DIRECTION.LEFT
	#can_see_player = true


#func _on_player_detection_area_exited(area):
	#player = null
	#can_see_player = false

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

func update_health_meter():
	var health_str = str(current_health)
	var max_health_str = str(max_health)
	health_level.text = health_str + " / " + max_health_str
	
