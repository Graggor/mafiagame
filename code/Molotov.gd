extends RigidBody2D

export (PackedScene) var Liquid
export (int) var liquid_volume = 80
var exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	mode = RigidBody2D.MODE_STATIC
	yield(get_tree().create_timer(1.0), "timeout")
	explode()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if collides():
		explode()
	
func explode():
	if exploded:
		return
	mode = RigidBody2D.MODE_STATIC
	exploded = true
	$Explosion.emitting = true
	for i in range(liquid_volume):
		var l = Liquid.instance()
		get_node('/root').add_child(l)
		l.position = global_position
		l.apply_central_impulse(linear_velocity)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	
func collides():
	var bodies=get_colliding_bodies()
#	if (bodies.size() > 0):
#		print(bodies[0])
	return bodies.size() > 0
