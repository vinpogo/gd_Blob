extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30
# warning-ignore:unused_class_variable
export var JUMP_FACTOR = 1.5
export var MAX_JUMPS = 1
export var MAX_SPEED = 100
export var SLOWMO = 10

var justJumped = false
var onFloor = false
var inMotion = false
var toBounce = false
var jumpFactor = 1
var jumpsLeft = 1

var jump_count = 0
var velocity = Vector2(0,0)
var slowMo = 1

var newCollide

signal stick

onready var aim = get_node("aim")
onready var timer = get_node("Timer")
var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)}

func ru_setCompass(dir: String, vec: Vector2 ):
	var v = vec.normalized()
	match(dir):
		"up":
			compass.up = v
			compass.down = -v
			compass.right = v.rotated(PI/4)
			compass.left = -compass.right
		"down":
			compass.up = -v
			compass.down = v
			compass.right = v.rotated(PI/4)
			compass.left = -compass.right
		"right":
			compass.up = v.rotated(PI/4)
			compass.down = -compass.up
			compass.right = v
			compass.left = -v
		"left":
			compass.up = v.rotated(PI/4)
			compass.down = -compass.up
			compass.right = -v
			compass.left = v



func _on_ready():
	ru_setCompass("down", Vector2(0,1))


func jump(dir):
	onFloor = false
	timer.start()
	justJumped = true
	jump_count += 1
	velocity = dir.normalized() * JUMP_FORCE * jumpFactor


func jumpHandler():
	var direction = aim.ru_getDirection()
	var jump_direction = -direction.y * compass.down + direction.x * compass.down.rotated(-PI/2)
	if onFloor && jump_count == 0:
		$sprite.play("ground-jump")
	elif!onFloor:
		if jump_count == 1:
			$sprite.play("jump")
		elif jump_count == 2:
			$sprite.play("final-jump")
	jump(jump_direction)

func _physics_process(delta):
#	if !onFloor:
	velocity = velocity + compass.down * GRAVITY * slowMo * delta
	velocity = velocity if velocity.length() < MAX_SPEED else velocity.normalized()*MAX_SPEED
	if !justJumped:
		newCollide = move_and_collide(velocity)
		if newCollide:
			collisionHandler(newCollide)
	else:
		 move_and_collide(velocity, false)


func bounce(col):
	$sprite.play("final-jump")
	velocity = velocity.bounce(col.normal)
	toBounce = false

func stick(collision):
	if !onFloor:
		print("stick")
		$sprite.play("idle")
		onFloor = true
		jump_count = 0
		ru_setCompass("up", collision.normal)
		emit_signal("stick", collision.normal)

func collisionHandler(collision):
	var type = collision.collider.get_type() if collision.collider.has_method("get_type") else null
	if type == "goal":
		print("finish")
		stick(collision)
#		get_tree().reload_current_scene()
	if type == "bouncy" || toBounce:
		bounce(collision)
	elif type == "sticky" && !inMotion:
		stick(collision)
	elif type == "deadly":
		die()

func ru_position():
	return self.position

func canJump():
	if jump_count < MAX_JUMPS: return true
	return false

func is_falling_down():
	return compass.down.dot(velocity) < 0

func _on_BounceArea_bounce():
	toBounce = true

func _on_Arrow_jump():
	jumpHandler()
	slowMo = 1



func _on_Arrow_aim():
	print("aim")
	velocity = velocity.normalized() / SLOWMO
	slowMo = 1/SLOWMO


func ru_walk():
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = abs(x) *2
	var direction = y * compass.up + x * compass.down.normalized().rotated(-PI/2)
	print(x)
	walkJump(direction)
	inMotion = true

func walkJump(dir):
	if !inMotion:
		print("step")

		onFloor = false
		velocity = dir.normalized() * 3
func _on_aim_move():
	print("move")
	ru_walk()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	pass # Replace with function body.


func _on_aim_stopAim() -> void:
	slowMo = 1
func die():
	get_tree().reload_current_scene()

func addJump():
	jumpsLeft += 1


func _on_Timer_timeout() -> void:
	justJumped = false
