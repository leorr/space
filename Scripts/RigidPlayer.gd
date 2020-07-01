extends RigidBody2D

onready var planets = get_tree().get_nodes_in_group("Planet")
onready var animator = get_node("anim_player")

enum{
	IDLE,
	RUN,
}

onready var _transitions: = {
	IDLE:[RUN],
	RUN:[IDLE],
}

export var run_speed := 4000.0
export var air_speed := 10.0
export var jump_force := 500.0

var _state: int = IDLE
var _pstate: int = 99
var move_direction = Vector2()
var flip : bool = false

var states_strings := {
	IDLE: "idle",
	RUN: "run",
}

func _process(_delta):
	move_direction = get_move_direction()
	set_flip()
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#var grounded := state.get_contact_count() > 0
	#print("pstate:", _pstate , " state:", _state, "\n")
	rotate((get_position() - planets[0].get_position()).normalized().angle_to(Vector2(0,-1))*-1)
	match _state:
		IDLE:
			if move_direction:
				change_state(RUN)
		RUN:
			if not move_direction:
				change_state(IDLE)
			elif linear_velocity.length() < 100:
				state.apply_central_impulse(move_direction*run_speed*0.5)
		
func change_state(target_state: int) -> void:
	if (not target_state in _transitions[_state]) or _pstate == _state:
		return
	_pstate = _state
	_state = target_state
	enter_state()

func enter_state() -> void:
	match _state:
		IDLE:
			animator.play("Idle")
		RUN:
			animator.play("Walking")

func get_move_direction() -> Vector2:
	return (get_position() - planets[0].get_position()).normalized().tangent() * (
			-Input.get_action_strength("ui_right") + Input.get_action_strength("ui_left"))

func set_flip() -> void:
	if Input.is_action_pressed("ui_left"):
		flip=1
	elif Input.is_action_pressed("ui_right"): 
		flip=0
	animator.set_flip_h(flip)
	return
