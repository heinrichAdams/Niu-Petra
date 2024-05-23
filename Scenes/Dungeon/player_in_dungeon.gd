extends CharacterBody2D

const JUMP_VELOCITY = -770
const KNOCKBACK_VELOCITY = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# ENUMS
enum STATE{
	RUN,
	IDLE,
	ATTACK,
	JUMP,
	FALL
}
enum DIRECTION{
	LEFT,
	RIGHT
}
# ENDOF ENUMS

# GLOBAL VARS
@export var inventory: Inventory
var max_health : int = 18 * PersistentPlayerData.get_player_level()
var current_health : int = max_health
const speed : int = 200
var state : STATE = STATE.IDLE
var direction : DIRECTION = DIRECTION.LEFT
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var selected_item = $Camera2D/selected_item
@onready var animation_player = $AnimationPlayer
@onready var weapon = $Weapon
@onready var stamina_bar = $stamina_bar
@onready var health_bar = $health_bar
var isAttacking : bool = false
var currently_regenerating_stamina : bool = false
var max_stamina : int = 36
var current_stamina : int = max_stamina
@onready var hurtbox = $hurtbox
@onready var hit_timer = $hit_timer
@onready var stamina_regen_timer = $stamina_regen_timer
@onready var step = $step
@onready var step_timer = $step_timer
@onready var jump = $jump
@onready var attack = $attack

# ENDOF GLOBAL VARS


func _ready():
	weapon.disable()
	max_stamina = 18
	current_stamina = max_stamina
	max_health= 18 * PersistentPlayerData.get_player_level()
	current_health = max_health
	

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
	if(Input.is_action_pressed("ui_right") and !isAttacking):
		direction = DIRECTION.RIGHT
		state = STATE.RUN
		velocity.x = speed

	elif(Input.is_action_pressed("ui_left") and !isAttacking):
		direction = DIRECTION.LEFT
		state = STATE.RUN
		velocity.x = -speed

	else: 
		if !isAttacking:
			state = STATE.IDLE
		velocity.x = 0

		
	if(not is_on_floor()):
		state = STATE.FALL
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and current_stamina > 1 and is_on_floor()  and !isAttacking:
		state = STATE.JUMP
		jump.play()
		velocity.y += JUMP_VELOCITY
		current_stamina -= 1
		regenerate_stamina()
		
	if(Input.is_action_just_pressed("LMB_click") and (current_stamina > 4)):
		isAttacking = true
		attack.play()
		state = STATE.ATTACK
		current_stamina -= 2
		regenerate_stamina()
		
	
	stamina_bar.set_stamina_level(current_stamina, max_stamina)
	health_bar.set_health_level(current_health, max_health)
	
	if current_stamina > max_stamina:
		current_stamina = max_stamina
	
	if hit_timer.is_stopped():
		animated_sprite_2d.modulate = Color(1,1,1,1)
	
	
	
	# ENDOF INPUT
### ENDOF player_movement ###	

### player_animation ###
func player_animation():
	match state:
		STATE.RUN:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("walk_left")
					if step_timer.is_stopped():
						step.play()
						step_timer.start()
				DIRECTION.RIGHT:
					animated_sprite_2d.play("walk_right")
					if step_timer.is_stopped():
						step.play()
						step_timer.start()
		STATE.IDLE:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("left_idle")
				DIRECTION.RIGHT:
					animated_sprite_2d.play("right_idle")
		STATE.ATTACK:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("attack_left")
					hurtbox.set_collision_layer_value(3,true)
					await animated_sprite_2d.animation_finished
					state = STATE.IDLE
					isAttacking = false
					hurtbox.set_collision_layer_value(3,false)
					
				DIRECTION.RIGHT:
					animated_sprite_2d.play("attack_right")
					hurtbox.set_collision_layer_value(3,true)
					await animated_sprite_2d.animation_finished
					state = STATE.IDLE
					isAttacking = false
					hurtbox.set_collision_layer_value(3,false)
					
		STATE.JUMP:
			match direction:
				DIRECTION.LEFT:
					animated_sprite_2d.play("jump_left")
					await animated_sprite_2d.animation_finished
					state = STATE.FALL
				DIRECTION.RIGHT:
					animated_sprite_2d.play("jump_right")
					await animated_sprite_2d.animation_finished
					state = STATE.FALL
### ENDOF player_animation ###


func set_temporary_hotbar_label(new_text):
	selected_item.text = new_text

func handle_enemy_collison():
	pass

func _on_hurtbox_area_entered(area):
	if !isAttacking:
		if area.name == "hitbox":
			current_health -= 1
			knockback()
			hit_timer.start()
			animated_sprite_2d.modulate = Color(1,0,0,0.5)

			
		if current_health <= 0:
			get_tree().change_scene_to_file("res://Scenes/Dungeon/player_death/death_screen.tscn")
		
		print(current_health)

func knockback():
	var knockback_direction = - velocity
	velocity = knockback_direction * KNOCKBACK_VELOCITY
	move_and_slide()
	
func regenerate_stamina():
	if !currently_regenerating_stamina:
		currently_regenerating_stamina = true
		while(current_stamina < max_stamina):
				stamina_regen_timer.start()
				await stamina_regen_timer.timeout
				current_stamina += 1
		currently_regenerating_stamina = false

func collect(item: InventoryItem):
	inventory.insert(item)
