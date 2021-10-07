extends Area2D

var speed = 1200
var direction = Vector2()
enum {REGULAR, SHOTGUN}
var type = REGULAR

func _physics_process(delta):
	if type == REGULAR:
		position += direction * speed * delta
	else:
		position += direction * (speed*.8) * delta

func _on_Bullet_body_entered(_body):
	queue_free()

func change_type(new_type):
	type = new_type
	if new_type == SHOTGUN:
		$Sprite.visible = false
		$Sprite2.visible = true
		yield(get_tree().create_timer(0.2), "timeout")
		queue_free()
