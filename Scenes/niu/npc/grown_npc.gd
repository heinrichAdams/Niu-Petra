extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var indicator = $Area2D/indicator

@onready var dialogue_box = $Area2D/dialogue_box
@onready var dialogue_text = $Area2D/dialogue_box/dialogue_text
@onready var next = $Area2D/dialogue_box/next
@onready var back = $Area2D/dialogue_box/back
@onready var exit = $Area2D/dialogue_box/exit


signal mouse_over_npc
signal mouse_left_npc

var dialogue_option_selected = 0

const dialogue_list = [
	"Mushi Ho! Thankee for rescue me!",
	"What you want for, Mushi?", 
	"Mushi Moo, what have the world 
	come to?",
	"The hole was dark, alone was me."
]

const SPEED = 300.0

var origin_point : Vector2

enum STATE{
	IDLE,
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN
}

enum HIT_DIRECTION{
	UP,
	DOWN,
	LEFT,
	RIGHT, 
	NONE
}

var should_return_left : bool = false
var should_return_right : bool = false
var should_return_up : bool = false
var should_return_down : bool = false

var state : STATE = STATE.IDLE
var hit_direction : HIT_DIRECTION = HIT_DIRECTION.NONE

func _ready():
	dialogue_box.visible = false
	dialogue_text.text = dialogue_list[dialogue_option_selected]
	animated_sprite_2d.play("grow")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
	origin_point = global_position
	


func _physics_process(delta):
	choose_behaviour()
	npc_move(delta)
	npc_play_animation()
	move_and_slide()

func choose_behaviour():
	pass
	
func npc_move(delta):
	pass
	
func npc_play_animation():
	pass


func _on_area_2d_mouse_entered():
	indicator.visible = true
	mouse_over_npc.emit()
	print("mouse entered npc")

func _on_area_2d_mouse_exited():
	indicator.visible = false
	mouse_left_npc.emit()
	print("mouse exit npc")


func _on_exit_pressed():
	dialogue_box.visible = false


func _on_dialogue_box_visibile_button_pressed():
	dialogue_box.visible = true


func _on_dialogue_box_visibile_button_mouse_entered():
	indicator.visible = true
	mouse_over_npc.emit()
	print("mouse entered npc")


func _on_dialogue_box_visibile_button_mouse_exited():
	indicator.visible = false
	mouse_left_npc.emit()
	print("mouse exit npc")


func _on_next_pressed():
	if (dialogue_option_selected + 1) >= dialogue_list.size():
		dialogue_option_selected = 0
		dialogue_text.text = dialogue_list[dialogue_option_selected]
		return
	dialogue_option_selected += 1
	dialogue_text.text = dialogue_list[dialogue_option_selected]


func _on_back_pressed():
	if (dialogue_option_selected - 1) > 0:
		dialogue_option_selected = dialogue_list.size() - 1
		dialogue_text.text = dialogue_list[dialogue_option_selected]
		return
	dialogue_option_selected -= 1
	dialogue_text.text = dialogue_list[dialogue_option_selected]
