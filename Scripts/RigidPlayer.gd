extends RigidBody2D

onready var planets = get_tree().get_nodes_in_group("Planet")
onready var animator = get_node("anim_player")
onready var timer = get_node("Timer")

enum{
	IDLE,
	RUN,
	JUMP,
}

onready var _transitions: = {
	IDLE:[RUN],
	RUN:[IDLE,JUMP],
	JUMP:[RUN],
}

export var impulse_speed := 4000.0
export var max_speed := 100.0
export var air_speed := 10.0
export var jump_force := 20000.0

var _state: int = IDLE
var _pstate: int = 99
var move_direction = Vector2()
var flip : bool = false

var states_strings := {
	IDLE: "idle",
	RUN: "run",
	JUMP: "jump",
}

func _process(_delta) -> void:
	move_direction = get_move_direction()
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var grounded := state.get_contact_count() > 0
	#print("pstate:", _pstate , " state:", _state, "\n")
	rotate((get_position() - planets[0].get_position()).normalized().angle_to(Vector2(0,-1))*-1)
	match _state:
		IDLE:
			if move_direction:
				change_state(RUN)
		RUN:
			set_flip()
			if not move_direction:
				change_state(IDLE)
			if (grounded) and Input.is_action_just_pressed("ui_jump"):
				state.apply_central_impulse( (get_linear_velocity().normalized()*0.3 + (get_position() - planets[0].get_position()).normalized()) *jump_force)
				timer.start()
				change_state(JUMP)
				#current grounded is unreliable
				pass
			elif linear_velocity.length() < max_speed:
				state.apply_central_impulse(move_direction*impulse_speed)
		JUMP:
			if grounded && timer.is_stopped():
				change_state(RUN)
		
func change_state(target_state: int) -> void:
	#change state only to diferent states
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
		flip=true
	elif Input.is_action_pressed("ui_right"): 
		flip=false
	animator.set_flip_h(flip)
	return
