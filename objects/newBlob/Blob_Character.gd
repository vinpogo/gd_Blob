extends KinematicBody2D

class_name BlobCharacter, "res://objects/newBlob/animations/idle/0001.png"
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
var air_control = 0

var jump_count = 0
var velocity = Vector2(0,0)
var slowmo = 1.0

var ability = {
	"jump": 3,
}
var visited_goals = []

var newCollide
signal stick
signal rotate(vec)
signal jump
signal toggle_zoom

onready var utils = get_node("/root/global")
#onready var aim = get_node("InputController")
onready var tween = get_node("rotation")
onready var timer = get_node("Timer")
var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)}

func _ready():
	visited_goals= []
	global.jump_count = 3
	global.precision_count = 5
	global.slowmo_duration = 5.0
	$Hud/GUI.update_jump_count()
	utils.ru_setCompass("down", Vector2(0,1))

func jump():
	velocity = (compass.up * JUMP_FORCE + compass.right * utils.controller_input().left_stick.x * JUMP_FORCE).normalized() * slowmo * JUMP_FORCE * (3 if slowmo < 1.0 else 1)
	onFloor = false
	timer.start()
	justJumped = true
	air_control = AIR_CONTROL

	global.jump_count -= 1
	$Hud/GUI.update_jump_count()
	$Sprite.play("ground-jump")


func precision_jump():
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
	global.precision_count -= 1
	$Hud/GUI.update_jump_count()
	justJumped = true

	velocity = jump_direction.normalized() * JUMP_FORCE * (jumpFactor if onFloor else 2)
	onFloor = false
	air_control = AIR_CONTROL
	emit_signal("jump")

func player_input_velocity():
	if onFloor:
		return Vector2(0,0)
	if Input.is_action_pressed("jump") && !is_falling_down():
		return compass.right * utils.controller_input().left_stick.x * AIR_CONTROL * 0.4* slowmo
	return compass.right * utils.controller_input().left_stick.x * AIR_CONTROL* slowmo

func gravity_velocity():
	if Input.is_action_pressed("jump") && !is_falling_down():
		return compass.down * GRAVITY * 0.4* slowmo
	return compass.down * GRAVITY* slowmo

func _physics_process(delta):
	if global.slowmo_duration < 0.5:
		slowmo = 1.0
	if !onFloor:
		velocity = velocity + (player_input_velocity() + gravity_velocity())  * delta
		if is_falling_down() && velocity.length() > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	else:
		velocity = Vector2(0,0)
	var oldCollide = newCollide
	newCollide = move_and_collide(velocity)
	if newCollide && !justJumped:
		if newCollide != oldCollide:
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

		ru_rotate(collision.normal)
		emit_signal("stick")

func ru_rotate(vec) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2
	tween.interpolate_property(self, "rotation", null, rotation + utils.short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func collisionHandler(collision):
	var type = collision.collider.get_type() if collision.collider is Planet else "deadly"
	if type == "goal":
		if visited_goals.find(collision.collider) == -1:
			global.jump_count += 3
			visited_goals.push_back(collision.collider)
			$Hud/GUI.update_jump_count()
		stick(collision)
	if type == "bouncy" || toBounce:
		bounce(collision)
		if visited_goals.find(collision.collider) == -1:
			global.slowmo_duration += 3.0
			visited_goals.push_back(collision.collider)
			$Hud/GUI.update_jump_count()
	elif type == "sticky" && !inMotion:
		if visited_goals.find(collision.collider) == -1:
			global.precision_count += 3
			visited_goals.push_back(collision.collider)
			$Hud/GUI.update_jump_count()
		stick(collision)
	elif type == "deadly":
		die()

func ru_position():
	return self.position

func canJump():
	if jump_count < MAX_JUMPS: return true
	return false

func is_falling_down():
	return compass.down.dot(velocity) > 0

func _on_BounceArea_bounce():
	toBounce = true

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
	ru_rotate(compass.up)
	onFloor = false


func _on_InputController_freeze() -> void:
	slowmo = 0
	velocity = Vector2(0,0)


func _on_InputController_unfreeze() -> void:
	slowmo = 1


func _on_InputController_jump() -> void:
	if global.jump_count > 0:
		jump()


func _on_InputController_precision_jump() -> void:
	if global.precision_count > 0:
		precision_jump()


func _on_InputController_slowmo(b: bool) -> void:
	print("slowmo")
	if(b):
		$Hud/GUI.start_slowmo_timer()
		if global.slowmo_duration > 0.5:
			slowmo = 1.0/SLOWMO
			velocity *= (slowmo*2)
	else:
		$Hud/GUI.stop_slowmo_timer()
		slowmo = 1.0

