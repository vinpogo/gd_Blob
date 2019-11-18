extends KinematicBody2D
class_name BlobCharacter, "res://gfx/blob/icon.png"


signal stick
signal rotate(vec)
signal set_jump_count(count, player)
signal jump
signal toggle_zoom
signal die

export var GRAVITY = 500
export var JUMP_FORCE = 30
export var JUMP_FACTOR = 1.5
export var MAX_JUMPS = 1
export var MAX_SPEED = 100
export var SLOWMO = 10
export var AIR_CONTROL = 200
export(Texture) var player_atlas
export(Color) var color
export var player = 1

var justJumped = false
var onFloor = false
var inMotion = false
var toBounce = false
var jumpFactor = 1
var jumpsLeft = 1
var air_control = 0
var timer_on = false
var jump_count = 5
var precision_count = 5
var velocity = Vector2(0,0)
var slowmo = 1.0
var visited_goals = []
var newCollide
var initial_gravity: Vector2

var ability_mapping = {
	"slot_1": "precision_jump",
	"slot_2": "flip_gravity",
	"slot_3": "precision_jump",
	"slot_4": "slowmo",
	"slot_5": "slowmo"
}

onready var global = get_node("/root/global")
onready var tween = get_node("rotation")
onready var timer = get_node("Timer")
var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)}
onready var tree = $AnimationPlayer/AnimationTree["parameters/playback"]

func init_blob(
							player_index = 1,
							initial_position = Vector2(0,0),
							initial_gravity_direction = Vector2(0,1),
							color = Color(0.2, 0.3, 0.4),
							jumps = 5,
							precisions = 5
							):
	print(initial_gravity, initial_position, jumps, precisions, color)
	player = player_index
	global_position = initial_position
	jump_count = jumps
	precision_count = precisions
	initial_gravity = initial_gravity_direction
	$Sprite.modulate = color

func _ready():
	visited_goals= []
	emit_signal("rotate", compass.down)
	if player_atlas:
		$Sprite.texture = player_atlas
	$Sprite.modulate = color
	emit_signal("set_jump_count", jump_count, precision_count, player)

func _on_InputController_slot_1(is_pressed) -> void:
	var ability = ability_mapping["slot_1"]
	handle_ability(ability, is_pressed)

func _on_InputController_slot_2(is_pressed) -> void:
	var ability = ability_mapping["slot_2"]
	handle_ability(ability, is_pressed)

func _on_InputController_slot_3(is_pressed) -> void:
	var ability = ability_mapping["slot_3"]
	handle_ability(ability, is_pressed)

func _on_InputController_slot_4(is_pressed) -> void:
	var ability = ability_mapping["slot_4"]
	handle_ability(ability, is_pressed)

func _on_InputController_slot_5(is_pressed) -> void:
	var ability = ability_mapping["slot_5"]
	handle_ability(ability, is_pressed)

func handle_ability(ability: String, is_pressed: bool) -> void:
	print("handle_ability")
	match(ability):
		"precision_jump":
			print("precision_jump")
		"slowmo":
			print("slowmo")
		"flip_gravity":
			print("flip_gravity")
	pass

func jump():
	velocity = (compass.up * JUMP_FORCE + compass.right * global.left_stick(player).x * JUMP_FORCE).normalized() * slowmo * JUMP_FORCE * (3.0 if slowmo < 1.0 else 1.0)
	onFloor = false
	timer.start()
	justJumped = true
	air_control = AIR_CONTROL

	jump_count -= 1
	emit_signal("set_jump_count", jump_count, precision_count, player)


func precision_jump():
	var direction = global.left_stick(player)
	var jump_direction = -direction.y * compass.down + direction.x * compass.down.rotated(-PI/2)
	timer.start()
	precision_count -= 1
	justJumped = true
	tree.travel("precision-jump")
	velocity = jump_direction.normalized() * JUMP_FORCE * 2.5
	onFloor = false
	air_control = AIR_CONTROL
	emit_signal("jump")
	emit_signal("set_jump_count", jump_count, precision_count, player)


func player_input_velocity():
	if onFloor:
		return Vector2(0,0)
	if Input.is_action_pressed("jump_%s"%player) && !is_falling_down():
		return compass.right * global.left_stick(player).x * AIR_CONTROL * 0.4* slowmo
	return compass.right * global.left_stick(player).x * AIR_CONTROL* slowmo

func gravity_velocity():
	if Input.is_action_pressed("jump_%s"%player) && !is_falling_down():
		return compass.down * GRAVITY * 0.4* slowmo
	return compass.down * GRAVITY* slowmo

func _physics_process(delta):
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
	velocity = velocity.bounce(col.normal).normalized() * JUMP_FORCE * 2
	toBounce = false
	tree.travel("jump")

func stick(collision):
	if !onFloor:
		tree.travel("land")
		onFloor = true
		velocity = Vector2(0,0)
		compass = global.ru_setCompass("up", collision.normal)

		ru_rotate(collision.normal)
		emit_signal("stick")
		emit_signal("rotate", collision.normal)

func ru_rotate(vec) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2
	tween.interpolate_property(self, "rotation", null, rotation + global.short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func collisionHandler(collision):
	var type = "bouncy"
	if collision.collider is Planet:
		type = collision.collider.get_type(color, player)
		collision.collider.set_type("bouncy")
	if type == "sticky":
		if visited_goals.find(collision.collider) == -1:
			jump_count += 3
			emit_signal("set_jump_count", jump_count, precision_count, player)
			visited_goals.push_back(collision.collider)
		stick(collision)
	if type == "bouncy" || toBounce:
		bounce(collision)
		if visited_goals.find(collision.collider) == -1:
			visited_goals.push_back(collision.collider)
	elif type == "goal" && !inMotion:
		if visited_goals.find(collision.collider) == -1:
			precision_count += 3
			visited_goals.push_back(collision.collider)
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
	emit_signal("die", player)
	emit_signal("rotate", compass.up)
	onFloor = false

func addJump():
	jumpsLeft += 1

func _on_Timer_timeout() -> void:
	justJumped = false

func _on_InputController_toggle_zoom() -> void:
	emit_signal("toggle_zoom")


func _on_GameZone_body_shape_exited(body_id: int, body: PhysicsBody2D, body_shape: int, area_shape: int) -> void:
	die()


func _on_InputController_flip_gravity() -> void:
	compass = global.ru_setCompass("up", compass.down)
	tree.travel("inAir")
	ru_rotate(compass.up)
	emit_signal("rotate", compass.up)
	onFloor = false


func _on_InputController_freeze() -> void:
	slowmo = 0
	velocity = Vector2(0,0)


func _on_InputController_unfreeze() -> void:
	slowmo = 1


func _on_InputController_jump() -> void:
	if jump_count > 0:
		jump()
		tree.travel("jump")


func _on_InputController_precision_jump() -> void:
	if precision_count > 0:
		precision_jump()

func start_slowmo_timer():
	timer_on = true

func stop_slowmo_timer():
	timer_on = false
func _on_InputController_slowmo(b: bool) -> void:
	print("slowmo")
	if(b):
#		$Hud/GUI.start_slowmo_timer()
		slowmo = 1.0/SLOWMO
		velocity *= (slowmo*2)
	else:
#		$Hud/GUI.stop_slowmo_timer()
		slowmo = 1.0
