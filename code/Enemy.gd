extends KinematicBody2D

var health = 100
var gravity = 3000
var velocity = Vector2()
var blind = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):
		die()
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2(), Vector2.UP)

func blind():
	blind = true
	print(get_name(), ": IM BLIND!!!!!!")

func _on_HeadBox_area_entered(area):
	if area.is_in_group("projectile"):
		health -= 100

func die():
	$CPUParticles2D.emitting = true


func _on_BodyBox_area_entered(area):
	if area.is_in_group("projectile"):
		health -= 50
