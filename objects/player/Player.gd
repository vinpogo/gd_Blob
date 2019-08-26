extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30
export var JUMP_FACTOR = 0.5

var onFloor = true

var jump_direction = Vector2()
var velocity = Vector2(0,0)
var gravity_dir = Vector2(0,0)

signal switchGravity

func is_touching():
	return onFloor

func _ready():
	pass
	
func jump(dir):
	onFloor = false
	velocity = dir.normalized() * JUMP_FORCE
	

func jumpHandler():
	if is_touching():
		jump_direction = get_global_mouse_position() - position
		jump(jump_direction)
	
func gravityFactor():

	if Input.is_action_pressed("jump") && !is_falling_down():
		return JUMP_FACTOR
	elif is_touching():
		velocity = Vector2(0,0)
		return 1
	else: 
		return 1

func is_falling_down():
	return velocity.normalized().dot(gravity_dir.normalized()) > 0


	
func _process(delta):
	inputHandler()
	velocity += (gravity_dir * GRAVITY * gravityFactor()) * delta
	
	
	var collide = move_and_collide(velocity)
	
	if collide:
		emit_signal("switchGravity", collide.normal)
		gravity_dir = -collide.normal
		onFloor = true
	

func inputHandler():
	if Input.is_action_just_pressed("jump"):
		jumpHandler()