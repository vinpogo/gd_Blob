extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var JUMP_FACTOR = 0.5
export var MAX_JUMPS = 3

var onFloor = true

var jump_direction = Vector2()
var jump_count = 0
var velocity = Vector2(0,0)
var gravity_dir = Vector2(0,1)

var newCollide
var oldCollide

signal switchGravity

func is_touching():
	return onFloor

func _ready():
	newCollide = move_and_collide(Vector2(0.1,0))
	oldCollide = move_and_collide(Vector2(-0.1,0))

func jump(dir):
	onFloor = false
	jump_count += 1
	velocity = dir.normalized() * JUMP_FORCE


func jumpHandler():
	if is_touching() && jump_count == 0:
		$AnimatedSprite.play("jump")
		jump_direction = get_global_mouse_position() - position
		jump(jump_direction)
	if!is_touching() && jump_count <= MAX_JUMPS:
		jump_direction = get_global_mouse_position() - position
		jump(jump_direction)

func gravityFactor():
	if Input.is_action_pressed("jump") && !is_falling_down():
		return JUMP_FACTOR
	else:
		return 1

func is_falling_down():
	return velocity.normalized().dot(gravity_dir.normalized()) > 0

func _process(delta):
	inputHandler()
	velocity += (gravity_dir * GRAVITY * gravityFactor()) * delta
	newCollide = move_and_collide(velocity)
	if (newCollide != oldCollide):
		if newCollide:
			land()
		oldCollide = newCollide
		
func land():
	$AnimatedSprite.play("idle")
	onFloor = true
	jump_count = 0
	velocity = Vector2(0,0)
	emit_signal("switchGravity", -gravity_dir,  Vector2(round(newCollide.normal.x), round(newCollide.normal.y)))
	rotate(gravity_dir.angle_to( Vector2(-round(newCollide.normal.x), -round(newCollide.normal.y))))

	gravity_dir.x = round(-newCollide.normal.x)
	gravity_dir.y = round(-newCollide.normal.y)

func inputHandler():
	if Input.is_action_just_pressed("jump"):
		jumpHandler()
	if Input.is_action_just_pressed("ui_accept"):
		print(gravity_dir)
