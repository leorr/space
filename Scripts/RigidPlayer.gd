extends RigidBody2D

onready var planets = get_tree().get_nodes_in_group("Planet")
onready var gravity = (get_position() - planets[0].get_position()).normalized()
onready var animator = get_node("anim_player")

enum{
	IDLE,
	RUN,
}

onready var _transitions: = {
	IDLE:[RUN],
	RUN:[IDLE],
}

export var run_speed := 400.0
export var air_speed := 10.0
export var jump_force := 500.0

var _state: int = IDLE
var _pstate: int = 99

var states_strings := {
	IDLE: "idle",
	RUN: "run",
}

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#var grounded := state.get_contact_count() > 0
	var move_direction := get_move_direction()
	
	print("pstate:", _pstate , " state:", _state, "\n")
	match _state:
		IDLE:
			if move_direction:
				change_state(RUN)
		RUN:
			if not move_direction:
				change_state(IDLE)
			else:
				state.linear_velocity = move_direction * run_speed
		
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
	return (get_position() - planets[0].get_position()).normalized().tangent() * (-Input.get_action_strength("ui_right") +Input.get_action_strength("ui_left"))
	#here i need to get the vector tangent to the gravity.

