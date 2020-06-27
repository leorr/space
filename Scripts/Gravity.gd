extends Area2D

#var objects = []
#var d_sqrd
#
#func _physics_process(_delta):
#	if objects.size() >= 2:
#		d_sqrd = pow((get_position() - objects[0].get_position()).length(),2)
#		print((get_position() - objects[0].get_position()))
#
#
#
#func _on_Gravity_body_entered(body):
#	objects.append(body)
func _ready():
	set_gravity(20000)
	set_gravity_distance_scale(0.0001)
