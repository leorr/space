#TODO motion needs to do ONLY the tangent to the gravity vector, chaging the sides
#and then i can make x do jump, being the oposite vector to gravity
extends RigidBody2D

var motion = Vector2()
var speed = 50
var planets = []
var current_gravity = Vector2()

func _ready():
	planets = get_tree().get_nodes_in_group("Planet")
	current_gravity = (get_position() - planets[0].get_position())

func _physics_process(_delta):
		current_gravity = (get_position() - planets[0].get_position()).normalized()


func _integrate_forces(state: Physics2DDirectBodyState):
	rotate(current_gravity.angle_to(Vector2(0,-1))*-1)
	
func _handle_move_input():
	motion = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
			motion = current_gravity.tangent().normalized() * -1
		#motion.x+=-1
	if Input.is_action_pressed("ui_left"):
		#motion.x+=1
		motion = current_gravity.tangent().normalized()
#	if Input.is_action_just_pressed("ui_jump"):
		#should inform physics_process to perform a impulse oposite to gravity
#		motion=(current_gravity+motion.normalized()*1.5)*speed*10
#		return
	#if Input.is_action_pressed("ui_down"):
	#	motion.y += 1
	motion= motion.normalized() * speed

func _check_gravityu():
	for i in planets:
		if abs(current_gravity.length()) <= abs((get_position() - i.get_position()).length()):
			current_gravity = (get_position() - i.get_position()).normalized()
