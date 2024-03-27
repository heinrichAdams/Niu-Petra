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
var selected_hotbar_slot : int 
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var selected_item = $Camera2D/selected_item

@onready var hotbar_slot_1 = $Camera2D/hotbar/hotbar_slot_1
@onready var hotbar_slot_2 = $Camera2D/hotbar/hotbar_slot_2
@onready var hotbar_slot_3 = $Camera2D/hotbar/hotbar_slot_3
@onready var hotbar_slot_4 = $Camera2D/hotbar/hotbar_slot_4

@onready var updated_hotbar = $updated_hotbar


@export var inventory: Inventory

# ENDOF GLOBAL VARS

func _ready():
	inventory.update.connect(update_hotbar_contents)

func set_selected_slot(_selected_slot):
	var selected_slot : int = _selected_slot
	selected_hotbar_slot = _selected_slot
	updated_hotbar.selected_slot(_selected_slot)
	
	match selected_slot:
		1:
			hotbar_slot_1.self_modulate = Color(0,1,0)
			hotbar_slot_2.self_modulate = Color(1,1,1)
			hotbar_slot_3.self_modulate = Color(1,1,1)
			hotbar_slot_4.self_modulate = Color(1,1,1)
		2:
			hotbar_slot_1.self_modulate = Color(1,1,1)
			hotbar_slot_2.self_modulate = Color(0,1,0)
			hotbar_slot_3.self_modulate = Color(1,1,1)
			hotbar_slot_4.self_modulate = Color(1,1,1)
		3:
			hotbar_slot_1.self_modulate = Color(1,1,1)
			hotbar_slot_2.self_modulate = Color(1,1,1)
			hotbar_slot_3.self_modulate = Color(0,1,0)
			hotbar_slot_4.self_modulate = Color(1,1,1)
		4:
			hotbar_slot_1.self_modulate = Color(1,1,1)
			hotbar_slot_2.self_modulate = Color(1,1,1)
			hotbar_slot_3.self_modulate = Color(1,1,1)
			hotbar_slot_4.self_modulate = Color(0,1,0)

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
	
func collect(item: InventoryItem):
	inventory.insert(item)

func get_item_at_selected_slot():
	return inventory.get_item_at_slot(selected_hotbar_slot)

func update_hotbar_contents():
	print("UPDATE SUCCESFULLY DETECTED, NO IDEA WHY THIS SHIT DONT WORK")
	updated_hotbar.update_hotbar_slots()
