extends KinematicBody2D


var velocity = Vector2()
var speed
const max_speed = 400
var gravity = 2400
var health = 100.0
var ducking = false
var current_weapon = 0

export (PackedScene) var Bullet
export (PackedScene) var Flashbang
export (PackedScene) var Molotov

var target = Vector2()
var fall_damage
var flash_duration = 0
const guns = ["pistol", "sawed-off", "ak", "knife", "flashbang", "molotov"]
onready var gun = $Body/Arm/Gun
onready var arm = $Body/Arm
onready var root = get_node('/root')

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = max_speed
	equip_weapon(current_weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update()
	if flash_duration > 0:
		flash_duration -= delta
		$Camera2D/FlashEffect.modulate.a = flash_duration 
	elif flash_duration < 0:
		flash_duration = 0
		$Camera2D/FlashEffect.modulate.a = 0
		
	$Body/Arm.look_at(get_global_mouse_position())
	#$Body/Arm.rotation = get_global_mouse_position().angle_to($Body/Arm.position)
	
	if !ducking:
		speed = max_speed
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2(), Vector2.UP)
	apply_anim()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
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
	if event.is_action_pressed("switch_weapon"):
		equip_weapon((current_weapon + 1) % guns.size())
		

func apply_anim():
	var anim = "idle"
	
	if !(velocity.x < 0.8 && velocity.x > -0.8):
		if ducking:
			anim = "slide"
		else:
			anim = "walk"
	else:
		if ducking:
			anim = "duck"
	
	$AnimationPlayer.play(anim)
	
func blind():
	flash_duration = 1.0
	$Camera2D/FlashEffect.modulate.a = 255
	
func equip_weapon(id):
	current_weapon = id
	$Body/Arm/AnimationPlayer.play(guns[id])
	
func attack():
	match current_weapon:
		0:
			shoot()
		1:
			shoot()
		2:
			shoot()
		3:
			pass #knife
		4:
			throw(Flashbang)
		5:
			throw(Molotov)
		_:
			print("not implemented")

func shoot():
	var b = Bullet.instance()
	root.add_child(b)
	b.direction = Vector2(1,0).rotated(gun.global_rotation)
	b.transform = gun.global_transform
	b.rotation = b.direction.angle()

func facing_right():
	return $Body.scale.x == 1

func throw(type):
	throw_anim()
	var t = type.instance()
	root.add_child(t)
	var direction = gun.global_position.direction_to(get_global_mouse_position())
	t.transform = gun.global_transform
	t.position -= direction * 2
	if (facing_right()):
		t.rotation += PI
	t.apply_central_impulse(direction * 900 + velocity)
	
func throw_anim():
	arm.scale.x = -$Body/Arm.scale.x
	yield(get_tree().create_timer(0.1), "timeout")
	arm.scale.x = -$Body/Arm.scale.x
	
func take_damage(amount):
	print(amount)
	health -= amount
