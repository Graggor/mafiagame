tool
extends Node2D

export (NodePath) var linked

var body_present = false
var current_body
export (bool) var going_up

# Called when the node enters the scene tree for the first time.
func _ready():
	if going_up:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event.is_action_pressed("interact") && body_present:
		interact(current_body)

func interact(body):
	body.position = get_node(linked).position

func _on_Up_body_entered(body):
	$Label.visible = true
	body_present = true
	current_body = body


func _on_Up_body_exited(_body):
	$Label.visible = false
	body_present = false
	current_body = null
