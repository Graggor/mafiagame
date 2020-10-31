extends KinematicBody2D


var velocity = Vector2()
var speed
const max_speed = 400
var gravity = 2400
var health = 100.0
var ducking = false

export (PackedScene) var Bullet

var target = Vector2()
var fall_damage


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = max_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !ducking:
		speed = max_speed
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2(), Vector2.UP)
	apply_anim()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if !is_on_floor():
		fall_damage = velocity.y
	if is_on_floor() && fall_damage > 400:
		take_damage(fall_damage / 1000)
		fall_damage = 0
	if ducking && speed > 0:
		speed -= 600 * delta

func get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, speed * move_direction, 0.4)
	if move_direction != 0:
		$Body.scale.x = move_direction
		
func _input(event):
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -450
	if event.is_action_pressed("duck"):
		ducking = true
	elif event.is_action_released("duck"):
		ducking = false

func apply_anim():
	var anim = "idle"
	
	if !(velocity.x < 0.8 && velocity.x > -0.8) && !ducking:
		anim = "walk"
	elif ducking:
		anim = "duck"
	
	$AnimationPlayer.play(anim)
	
func shoot():
	var b = Bullet.instance()
	owner.add_child(b)
	b.transform = $Body/Gun.global_transform
	b.velocity = $Body/Gun.global_position.direction_to(get_global_mouse_position())
	b.rotation = b.velocity.angle()
	
func take_damage(amount):
	print(amount)
	health -= amount
