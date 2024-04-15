extends CharacterBody2D

# ENUMS
enum STATE{
	RUN,
	IDLE,
	PLANT,
	MINE
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
var menu_visible : bool = false

@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var selected_item = $Camera2D/selected_item

@onready var hotbar_slot_1 = $Camera2D/hotbar/hotbar_slot_1
@onready var hotbar_slot_2 = $Camera2D/hotbar/hotbar_slot_2
@onready var hotbar_slot_3 = $Camera2D/hotbar/hotbar_slot_3
@onready var hotbar_slot_4 = $Camera2D/hotbar/hotbar_slot_4

@onready var action_timer = $action_timer

@onready var updated_hotbar = $updated_hotbar

@onready var xp_bar = $xp_bar

@onready var level_number = $level_number


@export var inventory: Inventory

var isMiningAnimationFinished : bool = true

var isPlantingAnimationFinished : bool = true

# ENDOF GLOBAL VARS

func _ready():
	inventory.update.connect(update_hotbar_contents)
	inventory.update
	updated_hotbar.update_hotbar_slots()


func set_selected_slot(_selected_slot):
	var selected_slot : int = _selected_slot
	selected_hotbar_slot = _selected_slot
	updated_hotbar.selected_slot(_selected_slot)
	

### _physics_process ###
func _physics_process(delta):
	player_movement(delta)
	player_animation()
	move_and_slide()
### ENDOF _physics_process ###
	
func play_mining_animation():
	state = STATE.MINE
	match direction:
		DIRECTION.UP:
			animated_sprite_2d.play("mine_up")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.DOWN:
			animated_sprite_2d.play("mine_down")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.LEFT:
			animated_sprite_2d.play("mine_left")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.RIGHT:
			animated_sprite_2d.play("mine_right")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE

func play_planting_animation():
	state = STATE.PLANT
	match direction:
		DIRECTION.UP:
			animated_sprite_2d.play("plant_up")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.DOWN:
			animated_sprite_2d.play("plant_down")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.LEFT:
			animated_sprite_2d.play("plant_left")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE
		DIRECTION.RIGHT:
			animated_sprite_2d.play("plant_right")
			action_timer.start()
			await action_timer.timeout
			state = STATE.IDLE

### player_movement ###
func player_movement(delta):
	
	# INPUT
	if(Input.is_action_pressed("ui_right") and (state != STATE.MINE) and (state != STATE.PLANT)):
		direction = DIRECTION.RIGHT
		state = STATE.RUN
		velocity.x = speed
		velocity.y = 0
	elif(Input.is_action_pressed("ui_left") and (state != STATE.MINE) and (state != STATE.PLANT)):
		direction = DIRECTION.LEFT
		state = STATE.RUN
		velocity.x = -speed
		velocity.y = 0
	elif(Input.is_action_pressed("ui_up") and (state != STATE.MINE) and (state != STATE.PLANT)):
		direction = DIRECTION.UP
		state = STATE.RUN
		velocity.x = 0
		velocity.y = -speed
	elif(Input.is_action_pressed("ui_down") and (state != STATE.MINE) and (state != STATE.PLANT)):
		direction = DIRECTION.DOWN
		state = STATE.RUN
		velocity.x = 0
		velocity.y = speed
	else: 
		if (state != STATE.MINE) and (state != STATE.PLANT):
			state = STATE.IDLE
		velocity.x = 0
		velocity.y = 0
	# ENDOF INPUT
	
	level_number.text = str(PersistentPlayerData.get_player_level())
	xp_bar.set_xp_level()
	

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

func remove(item: InventoryItem):
	inventory.remove(item)

func get_item_at_selected_slot():
	return inventory.get_item_at_slot(selected_hotbar_slot)

func update_hotbar_contents():
	print("UPDATE SUCCESFULLY DETECTED, NO IDEA WHY THIS SHIT DONT WORK")
	updated_hotbar.update_hotbar_slots()


func _on_animated_sprite_2d_animation_finished():
	pass
