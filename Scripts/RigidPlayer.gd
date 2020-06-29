extends RigidBody2D

onready var planets = get_tree().get_nodes_in_group("Planet")


enum{
	IDLE,
	RUN,
	AIR,
}

onready var _transitions: = {
	IDLE:[RUN,AIR],
	RUN:[IDLE,AIR],
	AIR:[IDLE],
}

export var run_speed := 400.0
export var air_speed := 10.0
export var jump_force := 500.0

var _state: int = IDLE

var states_strings := {
	IDLE: "idle",
	RUN: "run",
	AIR: "air",
}

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var grounded := state.get_contact_count() > 0
	var gravity = (get_position() - planets[0].get_position()).normalized()
	var move_direction := get_move_direction()
	
	match _state:
		IDLE:
			if move_direction:
				change_state(RUN)
			elif grounded && Input.is_action_just_pressed("ui_jump"):
				change_state(AIR)
		RUN:
			if not move_direction:
				change_state(IDLE)
			elif state.get_contact_count() == 0:
				change_state(AIR)
			elif grounded and Input.is_action_just_pressed("ui_jump"):
				apply_central_impulse(gravity * jump_force)
				change_state(AIR)
			else:
				state.linear_velocity= move_direction * run_speed
		AIR:
			if move_direction:
				state.linear_velocity += move_direction * air_speed 
			if grounded:
				change_state(IDLE)

func change_state(target_state: int) -> void:
	if not target_state is _transitions(_state):
		return
	_state = target_state
	enter_state()

func enter_state() -> void:
	match _state:
		IDLE:
			linear_velocity=0
		AIR:
			pass
		_:
			return
func get_move_direction() -> Vector2:
	return Vector2(1,1)
	#here i need to get the vector tangent to the gravity.

