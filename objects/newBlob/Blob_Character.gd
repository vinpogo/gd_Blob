extends KinematicBody2D

export var GRAVITY = 500
export var JUMP_FORCE = 30
# warning-ignore:unused_class_variable
export var JUMP_FACTOR = 1.5
export var MAX_JUMPS = 1
export var MAX_SPEED = 100
export var SLOWMO = 10
export var AIR_CONTROL = 200
var justJumped = false
var onFloor = false
var inMotion = false
var toBounce = false
var jumpFactor = 1
var jumpsLeft = 1

var jump_count = 0
var velocity = Vector2(0,0)
var slowMo = 1

var ability = {
	"slot_1": "jump",
	"slot_2": "jump",
	"slot_3": "zoom",
	"slot_4": "jump",
}

var newCollide

signal stick
signal rotate(vec)
signal jump
signal toggle_zoom

onready var utils = get_node("/root/global")
onready var aim = get_node("InputController")
onready var timer = get_node("Timer")
var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)}

func _on_ready():
	utils.ru_setCompass("down", Vector2(0,1))

func jump():
	var direction = utils.left_stick()
	var jump_direction = -direction.y * compass.down + direction.x * compass.down.rotated(-PI/2)
	if onFloor && jump_count == 0:
		$Sprite.play("ground-jump")
	elif!onFloor:
		if jump_count == 1:
			$Sprite.play("jump")
		elif jump_count == 2:
			$Sprite.play("final-jump")
	timer.start()
	justJumped = true
	jump_count += 1
	velocity = jump_direction.normalized() * JUMP_FORCE * (jumpFactor if onFloor else 2)
	onFloor = false
	emit_signal("jump")

func _physics_process(delta):
	if !onFloor:
		velocity = velocity + (compass.down * GRAVITY + compass.right * utils.controller_input().left_stick.x * AIR_CONTROL) * slowMo * delta
		velocity = velocity if velocity.length() < MAX_SPEED else velocity.normalized()*MAX_SPEED
	else:
		velocity = Vector2(0,0)
	newCollide = move_and_collide(velocity)
	if newCollide && !justJumped:
		collisionHandler(newCollide)

func bounce(col):
	$Sprite.play("final-jump")
	velocity = velocity.bounce(col.normal)
	toBounce = false

func stick(collision):
	if !onFloor:

		$Sprite.play("idle")
		onFloor = true
		velocity = Vector2(0,0)
		jump_count = 0
		compass = utils.ru_setCompass("up", collision.normal)
		var angle = collision.normal.angle()
		var rot = rotation - PI / 2
		rotation = rotation + utils.short_angle_dist(rot, angle)
		emit_signal("rotate", collision.normal)
		emit_signal("stick")

func collisionHandler(collision):
	var type = collision.collider.get_type() if collision.collider.has_method("get_type") else null
	if type == "goal":
		print("finish")
		stick(collision)
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
	jump()

func _on_Arrow_aim():
	print("aim")

func _on_aim_stopAim() -> void:
	pass

func die():
	get_tree().reload_current_scene()

func addJump():
	jumpsLeft += 1

func _on_Timer_timeout() -> void:
	justJumped = false

func _on_InputController_toggle_zoom() -> void:
	emit_signal("toggle_zoom")


func _on_GameZone_body_shape_exited(body_id: int, body: PhysicsBody2D, body_shape: int, area_shape: int) -> void:
	die()


func _on_InputController_flip_gravity() -> void:
	compass = utils.ru_setCompass("up", compass.down)
	emit_signal("rotate", compass.up)
	onFloor = false
	var angle = compass.up.angle()
	var rot = rotation - PI / 2
	rotation = rotation + utils.short_angle_dist(rot, angle)


func _on_InputController_freeze() -> void:
	slowMo = 0
	velocity = Vector2(0,0)


func _on_InputController_unfreeze() -> void:
	slowMo = 1
