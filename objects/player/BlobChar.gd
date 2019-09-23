extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var MAX_JUMPS = 3

var onFloor = false
var toBounce = false
var isAiming = false

var jump_direction = Vector2()
var jump_count = 0
var velocity = Vector2(0,0)
var gravity_dir = Vector2(1,0)

var newCollide
var oldCollide

onready var tween = get_node("Tween")
onready var blob = get_parent()

func is_touching():
	return onFloor

func _ready():
	tween.repeat = false
	rotation = (-gravity_dir).angle()

func thirdJump(dir):
	onFloor = false
	jump_count += 1
	if gravity_dir.dot(dir) > 0:
		velocity += dir.normalized() * JUMP_FORCE
	else:
		velocity = dir.normalized() * JUMP_FORCE * 1.5

func secondJump(dir):
	onFloor = false
	jump_count += 1
	if gravity_dir.dot(dir) > 0:
		velocity += dir.normalized() * JUMP_FORCE
	else:
		velocity = dir.normalized() * JUMP_FORCE * 1.25

func firstJump(dir):
	onFloor = false
	jump_count += 1
	velocity = dir.normalized() * JUMP_FORCE

func jumpHandler():
	if is_touching() && jump_count == 0:
		$sprite.play("ground-jump")
		jump_direction = get_global_mouse_position() - global_position
		firstJump(jump_direction)
		return
	if!is_touching():
		if jump_count == 1:
			$sprite.play("jump")
			jump_direction = get_global_mouse_position() - global_position
			secondJump(jump_direction)
			return

		elif jump_count == 2:
			$sprite.play("final-jump")
			jump_direction = get_global_mouse_position() - global_position
			thirdJump(jump_direction)
			return

func _physics_process(delta):
	var size = 2-Engine.time_scale
	scale = Vector2(size, size)
	
	if !onFloor:
		velocity += (gravity_dir * GRAVITY) * delta
		if isAiming:
			rotation = (get_global_mouse_position() - global_position).angle()
		else:
			rotation = velocity.angle()

	newCollide = move_and_collide(velocity)

	if newCollide != oldCollide:
		oldCollide = newCollide
		if newCollide:
			if newCollide.position.distance_to(position) > 10:
				collisionHandler(newCollide)

func bounce(col):
	$sprite.play("final-jump")
	velocity = velocity.bounce(col.normal)*0.5
	toBounce = false

func stick(collision):
	$sprite.play("idle")
	onFloor = true
	jump_count = 0
	velocity = Vector2(0,0)
	gravity_dir = -collision.normal
	rotation = (-gravity_dir).angle()

func collisionHandler(collision):
	var type
	
	if collision.collider.has_method("get_type"):
		type = collision.collider.get_type()
	if type == "bouncy" || toBounce:
		print("jump")
		
		bounce(collision)
	elif type == "sticky" && !onFloor:
		stick(collision)

func ru_position():
	return self.position

func canJump():
	if jump_count < MAX_JUMPS: return true
	return false

func is_falling_down():
	return gravity_dir.dot(velocity) < 0

func _on_BounceArea_bounce():
	toBounce = true

func _on_Arrow_jump():
	tween.stop_all()
	tween.interpolate_property(Engine, "time_scale", null, 1, 0.01, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	jumpHandler()
	isAiming = false


func _on_Arrow_aim():
	print("aim")
	isAiming = true
	velocity /= 1000
	tween.interpolate_property(Engine, "time_scale", 1, 0.001, 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()