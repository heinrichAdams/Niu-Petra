extends CharacterBody2D


const JUMP_VELOCITY = -600.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# ENUMS
enum STATE{
	RUN,
	IDLE
}
enum DIRECTION{
	LEFT,
	RIGHT
}
# ENDOF ENUMS

# GLOBAL VARS
const speed : int = 200
var state : STATE = STATE.IDLE
var direction : DIRECTION = DIRECTION.LEFT
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var selected_item = $Camera2D/selected_item
# ENDOF GLOBAL VARS


### _physics_process ###
func _physics_process(delta):
	player_movement(delta)
	player_animation()
	move_and_slide()
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

### ENDOF player_animation ###

func set_temporary_hotbar_label(new_text):
	selected_item.text = new_text
