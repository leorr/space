extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _integrate_forces(state):
		state.apply_central_impulse(get_move_direction()*100)

func get_move_direction() -> Vector2:

	return Vector2((Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")),
	(-Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
