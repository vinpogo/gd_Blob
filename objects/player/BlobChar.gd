extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30.0
export var JUMP_FACTOR = 1.5
export var MAX_JUMPS = 3
export var SLOWMO = 10

var onFloor = false
var inMotion = false
var toBounce = false
var jumpFactor = 1

var jump_count = 0
var velocity = Vector2(0,0)
var slowMo = 1

var newCollide
var oldCollide

signal stick

onready var aim = get_node("aim")
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
	jump_count += 1
	velocity = dir.normalized() * JUMP_FORCE * jumpFactor


func jumpHandler():
	var direction = aim.ru_getDirection()
	var jump_direction = -direction.y * compass.down + direction.x * compass.down.rotated(-PI/2)
	jump(jump_direction)
	if onFloor && jump_count == 0:
		$sprite.play("ground-jump")
	elif!onFloor:
		if jump_count == 1:
			$sprite.play("jump")
		elif jump_count == 2:
			$sprite.play("final-jump")

func _physics_process(delta):
	if !onFloor:
		velocity += (compass.down * GRAVITY * slowMo) * delta * slowMo
		newCollide = move_and_collide(velocity)

	if newCollide != oldCollide:
		oldCollide = newCollide
		if newCollide:
			if newCollide.position.distance_to(position) > 10 && !onFloor:
				collisionHandler(newCollide)

func bounce(col):
	$sprite.play("final-jump")
	velocity = velocity.bounce(col.normal)*0.5
	toBounce = false

func stick(collision):
	if !onFloor:
		print("stick")
		$sprite.play("idle")
		onFloor = true
		jump_count = 0
		velocity = Vector2(0,0)
		ru_setCompass("up", collision.normal)
		emit_signal("stick")

func collisionHandler(collision):
	var type
	
	if collision.collider.has_method("get_type"):
		type = collision.collider.get_type()
	if type == "bouncy" || toBounce:
		print("jump")
		
		bounce(collision)
	elif type == "sticky" && !inMotion:
		stick(collision)

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
	pass # Replace with function body.
