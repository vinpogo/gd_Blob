extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var JUMP_FACTOR = 0.5
export var MAX_JUMPS = 3

var onFloor = true
var toBounce = false
var isAiming = false

var jump_direction = Vector2()
var jump_count = 0
var velocity = Vector2(0,0)
var gravity_dir = Vector2(0,1)

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
	newCollide = move_and_collide(Vector2(0.1,0))
	oldCollide = move_and_collide(Vector2(-0.1,0))
	
func thirdJump(dir):
	onFloor = false
	jump_count += 1
	if dir.normalized().dot(gravity_dir.normalized()) > 0:
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
		jump_direction = get_global_mouse_position() - position
		firstJump(jump_direction)
		return
	if!is_touching():
		if jump_count == 1:
			$AnimatedSprite.play("jump")
			jump_direction = get_global_mouse_position() - position
			secondJump(jump_direction)
			return
			
		elif jump_count == 2:
			$AnimatedSprite.play("final-jump")
			jump_direction = get_global_mouse_position() - position
			thirdJump(jump_direction)
			return

func gravityFactor():
	if !is_falling_down():
		return JUMP_FACTOR
	else:
		return 1

func is_falling_down():
	return velocity.normalized().dot(gravity_dir.normalized()) > 0

func _process(delta):
		
	if isAiming:
		velocity = Vector2(0,0)
	else:
		velocity += (gravity_dir * GRAVITY) * delta
		
	if !(onFloor || isAiming):
		rotation = velocity.angle() + PI/2
	newCollide = move_and_collide(velocity)
	if (newCollide != oldCollide):
		if newCollide:
			if toBounce:
				bounce(newCollide)
			else:
				land()
		oldCollide = newCollide
		
func bounce(col):
	velocity = velocity.bounce(col.normal)*0.5
	toBounce = false
	
func land():
	$AnimatedSprite.play("idle")
	onFloor = true
	jump_count = 0
	velocity = Vector2(0,0)
	emit_signal("switchGravity", gravity_dir.angle_to( Vector2(-round(newCollide.normal.x), -round(newCollide.normal.y))))
	gravity_dir.x = round(-newCollide.normal.x)
	gravity_dir.y = round(-newCollide.normal.y)
	rotation = gravity_dir.angle() - PI/2

#func _input(event):
#	if event.is_action_pressed("jump"):
#		jumpHandler()

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


func _on_Arrow_aim():
	isAiming = true