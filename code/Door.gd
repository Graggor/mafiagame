extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_interact = false
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer
	$Label.visible = false
	set_collision_layer_bit(0, true)

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if is_open:
			close()
		else:
			open()

func _on_Area2D_body_entered(_body):
	$Label.visible = true
	can_interact = true

func _on_Area2D_body_exited(_body):
	$Label.visible = false
	can_interact = false

func open():
	set_collision_layer_bit(0, false)
	$AnimationPlayer.play("open")
	$Label.text = "Press \"E\" to close the door."
	is_open = true
	#yield($AnimationPlayer, "animation_finished")
	$LightOccluder2D.visible = false
	

func close():
	$AnimationPlayer.play_backwards("open")
	$Label.text = "Press \"E\" to open the door."
	is_open = false
	yield($AnimationPlayer, "animation_finished")
	set_collision_layer_bit(0, true)
	$LightOccluder2D.visible = true
	
