extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var MAX_JUMPS = 3
export var SLOWMO = 20

var onFloor = false
var toBounce = false
var isAiming = false

var jump_direction = Vector2()
var jump_count = 0
var velocity = Vector2(0,0)
var gravity_dir = Vector2(1,0)
var slowMo = 1

var newCollide
var oldCollide

signal stick

onready var tween = get_node("Tween")
onready var aim = get_node("aim")

func is_touching():
	return onFloor

func _ready():
	tween.repeat = false
#	rotation = (-gravity_dir).angle()

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
func walkJump(dir):
	onFloor = false
	velocity = dir.normalized() * 5

func jumpHandler():
	var direction = aim.ru_getDirection()
	jump_direction = -direction.y * gravity_dir + direction.x * gravity_dir.rotated(-PI/2)
	
	if is_touching() && jump_count == 0:
		$sprite.play("ground-jump")
		firstJump(jump_direction)
		return
	if!is_touching():
		if jump_count == 1:
			$sprite.play("jump")
			secondJump(jump_direction)
			return

		elif jump_count == 2:
			$sprite.play("final-jump")
			thirdJump(jump_direction)
			return

func _physics_process(delta):
	if !onFloor:
		velocity += (gravity_dir * GRAVITY * slowMo) * delta * slowMo

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
	emit_signal("stick")

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
	print("stop tween")
	tween.interpolate_property(self, "slowMo", null, 1, 0.01, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	isAiming = false


func _on_Arrow_aim():
	print("aim")
	isAiming = true
	velocity /= SLOWMO
	tween.interpolate_property(self, "slowMo", null, 1/SLOWMO, 0.05, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	print("ENDE")


func _on_Tween_tween_completed(object, key):
	if slowMo == 1:
		jumpHandler()

func ru_walk():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = abs(x)
	var direction = -y * gravity_dir + x * gravity_dir.rotated(-PI/2)
	walkJump(direction)

func _on_aim_move():
	print("walk")
	ru_walk()
	pass # Replace with function body.
