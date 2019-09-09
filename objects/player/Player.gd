extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var JUMP_FACTOR = 0.5
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

signal switchGravity

func is_touching():
	return onFloor
func canJump():
	if jump_count < MAX_JUMPS:
		return true
	return false

func _ready():
	rotation = (-gravity_dir).angle()
	pass

func thirdJump(dir):
	onFloor = false
	jump_count += 1
	if dir.normalized().cross(gravity_dir.normalized()) > 0:
		velocity += dir.normalized() * JUMP_FORCE
	else:
		velocity = dir.normalized() * JUMP_FORCE * 1.5

func secondJump(dir):
	onFloor = false
	jump_count += 1
	if dir.normalized().dot(gravity_dir.normalized()) > 0:
		velocity += dir.normalized() * JUMP_FORCE
	else:
		velocity = dir.normalized() * JUMP_FORCE * 1.25

func firstJump(dir):
	onFloor = false
	jump_count += 1
	velocity = dir.normalized() * JUMP_FORCE


func jumpHandler():
	if is_touching() && jump_count == 0:
		$AnimatedSprite.play("ground-jump")
		jump_direction = get_global_mouse_position() - global_position
		firstJump(jump_direction)
		return
	if!is_touching():
		if jump_count == 1:
			$AnimatedSprite.play("jump")
			jump_direction = get_global_mouse_position() - global_position
			secondJump(jump_direction)
			return

		elif jump_count == 2:
			$AnimatedSprite.play("final-jump")
			jump_direction = get_global_mouse_position() - global_position
			thirdJump(jump_direction)
			return

func gravityFactor():
	if !is_falling_down():
		return JUMP_FACTOR
	else:
		return 1

func is_falling_down():
	return velocity.project(gravity_dir).dot(gravity_dir) > 0

func _process(delta):

	if onFloor:
		$"../MainCamera/Tween".stop_all()

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
				if toBounce:
					bounce(oldCollide)
				elif !onFloor:
					land()


func bounce(col):
	$AnimatedSprite.play("final-jump")
	velocity = velocity.bounce(col.normal)*0.5
	toBounce = false

func land():
	$AnimatedSprite.play("idle")
	onFloor = true
	jump_count = 0
	velocity = Vector2(0,0)
	gravity_dir = -newCollide.normal
	rotation = (-gravity_dir).angle()


func ru_position():
	return self.position


func _on_BounceArea_bounce():
	toBounce = true

func _on_BounceArea_stopBounce():
	return
	toBounce = false

func _on_Arrow_jump():
	jumpHandler()
	isAiming = false
	Engine.time_scale = 1

func _on_Arrow_aim():
	isAiming = true
	velocity /= 10
	Engine.time_scale = 0.1