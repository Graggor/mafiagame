extends KinematicBody2D

var health = 100
var gravity = 3000
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):
		die()
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2(), Vector2.UP)


func _on_HeadBox_area_entered(_area):
	health -= 100

func die():
	$CPUParticles2D.emitting = true


func _on_BodyBox_area_entered(_area):
	health -= 50
