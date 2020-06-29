extends "res://Scripts/State_Machine.gd"

var flip = 0
onready var animator = parent.get_node("anim_player")

func _ready():
	add_state("idle")
	add_state("walking")
	call_deferred("set_state",states.idle)


func _refresh(_delta):
	parent.set_z_index(parent.get_position().y)

func _update_state(_delta):
	match state:
		states.idle:
			parent._handle_move_input()
			if parent.motion.x != 0 || parent.motion.y !=0 :
				return states.walking

		states.walking:
			parent._handle_move_input()
			if parent.motion.x == 0 && parent.motion.y ==0 :
				parent._handle_move_input()
				return states.idle
			else:
				if  Input.is_action_pressed("ui_right"):
					flip = 1
				elif Input.is_action_pressed("ui_left"):
					flip = 0
				return states.walking
		
func _enter_state(new_state,_old_state):
	match new_state:
		states.idle:
				animator.play("Idle")

		states.walking:
			match flip:
				0:
					animator.play("Walking")
					animator.set_flip_h(true)
				1:
					animator.play("Walking")
					animator.set_flip_h(false)
