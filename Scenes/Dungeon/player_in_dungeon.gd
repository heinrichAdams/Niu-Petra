extends CharacterBody2D



const JUMP_VELOCITY = -800.0
const KNOCKBACK_VELOCITY = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# ENUMS
enum STATE{
	RUN,
	IDLE,
	ATTACK
}
enum DIRECTION{
	LEFT,
	RIGHT
}
# ENDOF ENUMS

# GLOBAL VARS
@export var max_health : int = 3
@onready var current_health : int = max_health
const speed : int = 200
var state : STATE = STATE.IDLE
var direction : DIRECTION = DIRECTION.LEFT
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var selected_item = $Camera2D/selected_item
@onready var animation_player = $AnimationPlayer
@onready var weapon = $Weapon
# ENDOF GLOBAL VARS


func _ready():
	weapon.visible = false

### _physics_process ###
func _physics_process(delta):
	player_movement(delta)
	player_animation()
	move_and_slide()
	handle_enemy_collison()
### ENDOF _physics_process ###
	
### player_movement ###
func player_movement(delta):
	
	# INPUT
	if(Input.is_action_pressed("ui_right")):
		direction = DIRECTION.RIGHT
		state = STATE.RUN
		velocity.x = speed

	elif(Input.is_action_pressed("ui_left")):
		direction = DIRECTION.LEFT
		state = STATE.RUN
		velocity.x = -speed

	else: 
		state = STATE.IDLE
		velocity.x = 0

		
	if(not is_on_floor()):
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if(Input.is_action_just_pressed("LMB_click")):
		state = STATE.ATTACK
	

	# ENDOF INPUT
### ENDOF player_movement ###	

### player_animation ###
func player_animation():
	match state:
		STATE.RUN:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("walk_left")
				DIRECTION.RIGHT:
					animated_sprite_2d.play("walk_right")
		STATE.IDLE:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("left_idle")
				DIRECTION.RIGHT:
					animated_sprite_2d.play("right_idle")
		STATE.ATTACK:
			match direction:
				DIRECTION.LEFT:
					animation_player.play("attack_left")
				DIRECTION.RIGHT:
					animation_player.play("attack_right")
### ENDOF player_animation ###


func set_temporary_hotbar_label(new_text):
	selected_item.text = new_text

func handle_enemy_collison():
	pass

func _on_hurtbox_area_entered(area):
	if area.name == "hitbox":
		current_health -= 1
		knockback()
	if current_health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Dungeon/player_death/death_screen.tscn")
		
	print(current_health)

func knockback():
	var knockback_direction = - velocity
	velocity = knockback_direction * KNOCKBACK_VELOCITY
	move_and_slide()
	
	
