#TODO motion needs to do ONLY the tangent to the gravity vector, chaging the sides
#and then i can make x do jump, being the oposite vector to gravity
extends RigidBody2D

var motion = Vector2()
var speed = 400
var planets = []
var current_gravity = Vector2()

func _ready():
	planets = get_tree().get_nodes_in_group("Planet")

func _process(_delta):
	_handle_move_input()

func _physics_process(_delta):
	current_gravity = get_position() - planets[0].get_position()
	#i should only do those after i check if the player is landed
	set_linear_velocity(motion)
	rotate(current_gravity.angle_to(Vector2(0,-1))*-1)
	
func _handle_move_input():
	motion = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		motion = current_gravity.tangent().normalized() * -1
	if Input.is_action_pressed("ui_left"):
		motion = current_gravity.tangent().normalized() 
	if Input.is_key_pressed(KEY_X):
		#should inform physics_process to perform a impulse oposite to gravity
		pass
	#if Input.is_action_pressed("ui_down"):
	#	motion.y += 1
	motion= motion.normalized() * speed
