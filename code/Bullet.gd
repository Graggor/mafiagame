extends Area2D

var speed = 1200
var velocity = Vector2()

func _physics_process(delta):
	position += velocity * speed * delta

func _on_Bullet_body_entered(_body):
	queue_free()
