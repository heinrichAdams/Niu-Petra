extends CharacterBody2D

# ENUMS
enum STATE{
	RUN,
	IDLE
}
enum DIRECTION{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
# ENDOF ENUMS

# GLOBAL VARS
const speed : int = 200
var state : STATE = STATE.IDLE
var direction : DIRECTION = DIRECTION.DOWN
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
		velocity.y = 0
	elif(Input.is_action_pressed("ui_left")):
		direction = DIRECTION.LEFT
		state = STATE.RUN
		velocity.x = -speed
		velocity.y = 0
	elif(Input.is_action_pressed("ui_up")):
		direction = DIRECTION.UP
		state = STATE.RUN
		velocity.x = 0
		velocity.y = -speed
	elif(Input.is_action_pressed("ui_down")):
		direction = DIRECTION.DOWN
		state = STATE.RUN
		velocity.x = 0
		velocity.y = speed
	else: 
		state = STATE.IDLE
		velocity.x = 0
		velocity.y = 0
	# ENDOF INPUT
### ENDOF player_movement ###	

### player_animation ###
func player_animation():
	match state:
		STATE.RUN:
			match direction:
				DIRECTION.UP:
					animated_sprite_2d.play("run_up")
				DIRECTION.DOWN:
					animated_sprite_2d.play("run_down")
				DIRECTION.LEFT:
					animated_sprite_2d.play("run_left")
				DIRECTION.RIGHT:
					animated_sprite_2d.play("run_right")
		STATE.IDLE:
			match direction:
				DIRECTION.UP:
					animated_sprite_2d.play("idle_up")
				DIRECTION.DOWN:
					animated_sprite_2d.play("idle_down")
				DIRECTION.LEFT:
					animated_sprite_2d.play("idle_left")
				DIRECTION.RIGHT:
					animated_sprite_2d.play("idle_right")

### ENDOF player_animation ###

func set_temporary_hotbar_label(new_text):
	selected_item.text = new_text
