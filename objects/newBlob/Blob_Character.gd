extends KinematicBody2D
class_name BlobCharacter, "res://gfx/blob/icon.png"


signal stick
signal rotate(vec)
signal set_jump_count(count, player)
signal jump
signal toggle_zoom
signal die

export var GRAVITY_FORCE = 42
export var GRAVITY_FACTOR = 0.4
export var JUMP_FORCE = 7
export var MAX_JUMPS = 1
export var MAX_SPEED = 21
export var SLOWMO = 10
export var AIR_CONTROL = 30
export(Texture) var player_atlas
export(Color) var color
export var player = 1

var justJumped = false
var onFloor = false
var toBounce = false
var timer_on = false
var jump_count = 5
var precision_count = 5
var velocity = Vector2(0,0)
var slowmo_factor = 1.0
var gravity_factor = false
var visited_goals = []
var newCollide
var initial_gravity: Vector2
var initial_position: Vector2
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
	player = player_index
	global_position = initial_position
	jump_count = jumps
	precision_count = precisions
	initial_position = initial_position
	initial_gravity = initial_gravity_direction
	$Sprite.modulate = color

func _ready():
	visited_goals= []
	emit_signal("rotate", compass.down)
	if player_atlas:
		$Sprite.texture = player_atlas
	$Sprite.modulate = color
	emit_signal("set_jump_count", jump_count, precision_count, player)

func _on_InputController_jump(is_pressed) -> void:
	handle_ability("jump", is_pressed)
	tree.travel("jump")

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
	match(ability):
		"jump":
			if jump_count > 0 && is_pressed:
				jump()
			elif !is_pressed:
				print("turn off")
				gravity_factor = false
		"precision_jump":
			print("precision_jump")
			if precision_count > 0 && !is_pressed:
				precision_jump()
		"slowmo":
			print("slowmo")
			if !is_pressed:
				slowmo(is_pressed)
		"flip_gravity":
			print("flip_gravity")
			if is_pressed:
				flip_gravity()
	pass
func flip_gravity() -> void:
	compass = global.ru_setCompass("up", compass.down)
	tree.travel("inAir")
	ru_rotate(compass.up)
	emit_signal("rotate", compass.up)
	onFloor = false

func slowmo(is_pressed: bool) -> void:
	if(is_pressed):
		slowmo_factor = 1.0/SLOWMO
		velocity *= (slowmo_factor*2)
	else:
		slowmo_factor = 1.0

func jump():
	print("jump")
	velocity = compass.up * slowmo_factor * JUMP_FORCE + global.left_stick(player) * compass.right * AIR_CONTROL
	onFloor = false
	timer.start()
	justJumped = true
	jump_count -= 1
	gravity_factor = true
	emit_signal("set_jump_count", jump_count, precision_count, player)


func precision_jump():
	var direction = global.left_stick(player)
	var jump_direction = -direction.y * compass.down + direction.x * compass.down.rotated(-PI/2)
	timer.start()
	precision_count -= 1
	justJumped = true
	tree.travel("precision-jump")
	velocity = jump_direction.normalized() * JUMP_FORCE
	onFloor = false
	emit_signal("jump")
	emit_signal("set_jump_count", jump_count, precision_count, player)

func bounce(col):
	velocity = velocity.bounce(col.normal).normalized() * JUMP_FORCE
	toBounce = false
	tree.travel("jump")

func stick(collision):
	if !onFloor:
		tree.travel("land")
		onFloor = true
		velocity = Vector2(0,0)
		gravity_factor = false
		compass = global.ru_setCompass("up", collision.normal)

		ru_rotate(collision.normal)
		emit_signal("stick")
		emit_signal("rotate", collision.normal)

func die():
	emit_signal("die", player)
	emit_signal("rotate", compass.up)
	velocity = Vector2(0,0)
	global_position = initial_position
	onFloor = false

func player_input_velocity():
	if onFloor:
		return Vector2(0,0)
	return compass.right * global.left_stick(player).x * AIR_CONTROL * slowmo_factor

func gravity_velocity():
	if is_falling_down() && gravity_factor:
		print("turn off")
		gravity_factor = false
	var g = GRAVITY_FACTOR if gravity_factor else 1.0
	return compass.down * GRAVITY_FORCE * slowmo_factor * g

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
	elif type == "goal":
		if visited_goals.find(collision.collider) == -1:
			precision_count += 3
			visited_goals.push_back(collision.collider)
		stick(collision)
	elif type == "deadly":
		die()

func ru_rotate(vec) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2
	tween.interpolate_property(self, "rotation", null, rotation + global.short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func canJump():
	if jump_count < MAX_JUMPS: return true
	return false

func is_falling_down():
	return compass.down.dot(velocity) > 0

func _on_Timer_timeout() -> void:
	justJumped = false

func start_slowmo_timer():
	timer_on = true

func stop_slowmo_timer():
	timer_on = false

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

