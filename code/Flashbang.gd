extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export (float) var timeout = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$Light2D.enabled = false
	yield(get_tree().create_timer(1.0), "timeout")
	$Light2D.enabled = true
	flash()
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
	
func flash():
	for body in $EffectRadius.get_overlapping_bodies():
		if in_direct_sight(body):
			body.blind()
	pass
	
func in_direct_sight(body):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, body.get_node("Body/Eyes").global_position, [self, body], collision_mask)
	return !result
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass