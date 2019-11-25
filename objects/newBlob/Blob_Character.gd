extends KinematicBody2D
class_name BlobCharacter, "res://gfx/blob/icon.png"

signal stick
signal rotate(vec)
signal set_jump_count(count, player)
signal jump
signal die

export var GRAVITY_FORCE = 64
export var GRAVITY_FACTOR = 0.4
export var PUNCHING_POWER = 60
export var JUMP_FORCE = 7
export var MAX_JUMPS = 1
export var MAX_SPEED = 21
export var SLOWMO = 3.0
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
var gravity_factor = false
var visited_goals = []
var newCollide
var initial_gravity: Vector2
var initial_position: Vector2
var slowmo_on = false
var punch_count = 5
var ability_mapping = [
	"jump", # 0
	"precision_jump", # 1
	"flip_gravity", # 2
	"precision_jump", # 3
	"punch", # 4
	"slowmo" # 5 
]

#{
#	"slot_1": "precision_jump",
#	"slot_2": "flip_gravity",
#	"slot_3": "precision_jump",
#	"slot_4": "punch",
#	"slot_5": "slowmo"
#}

var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)}


onready var punch_area = get_node("PunchArea")
onready var tween = get_node("rotation")
onready var timer = get_node("Timer")
onready var tree = $AnimationPlayer/AnimationTree["parameters/playback"]

func init_blob(player_config):
	player = player_config.player_index
	global_position = player_config.initial_position
	jump_count = player_config.jump_count
	precision_count = player_config.precision_count
	initial_position = player_config.initial_position
	initial_gravity = player_config.initial_gravity_direction
	compass = global.ru_setCompass("down", player_config.initial_gravity_direction)
	ru_rotate(player_config.initial_gravity_direction)
	color = player_config.color
	$Sprite.modulate = player_config.color

func _ready():
	print(player)
	visited_goals= []
	emit_signal("rotate", compass.down)
	if player_atlas:
		$Sprite.texture = player_atlas
	$Sprite.modulate = color
	emit_signal("set_jump_count", jump_count, precision_count, player)

func _input(event: InputEvent) -> void:
	if event.device == player:
		var ability: String
		var toggled_to_state: bool
		if event is InputEventJoypadButton:

			if event.is_action_pressed("ui_home"):
				get_tree().change_scene("res://objects/Control.tscn")

			if event.is_action_pressed("jump"):
				ability = "jump"
				toggled_to_state = true
			if event.is_action_released("jump"):
				ability = "jump"
				toggled_to_state = false

			if event.is_action_pressed("slot_1"):
				ability = ability_mapping[1]
				toggled_to_state = true
			if event.is_action_pressed("slot_2"):
				ability = ability_mapping[2]
				toggled_to_state = true
			if event.is_action_pressed("slot_3"):
				ability = ability_mapping[3]
				toggled_to_state = true
			if event.is_action_pressed("slot_4"):
				ability = ability_mapping[4]
				toggled_to_state = true
			if event.is_action_pressed("slot_5"):
				ability = ability_mapping[5]
				toggled_to_state = true
			if event.is_action_released("slot_1"):
				ability = ability_mapping[1]
				toggled_to_state = false
			if event.is_action_released("slot_2"):
				ability = ability_mapping[2]
				toggled_to_state = false
			if event.is_action_released("slot_3"):
				ability = ability_mapping[3]
				toggled_to_state = false
			if event.is_action_released("slot_4"):
				ability = ability_mapping[4]
				toggled_to_state = false
			if event.is_action_released("slot_5"):
				ability = ability_mapping[5]
				toggled_to_state = false
			handle_ability(ability, toggled_to_state)

func handle_ability(ability: String, is_pressed: bool) -> void:
	match(ability):
		"jump":
			if jump_count > 0 && is_pressed:
				var direction = global.left_stick(player)
				jump(direction)
			elif !is_pressed:
				print("turn off")
				gravity_factor = false
		"precision_jump":
			print("precision_jump")
			if precision_count > 0 && is_pressed:
				$InputController.visible = true
			if precision_count > 0 && !is_pressed:
				$InputController.visible = false
#				if global.left_stick(player).y <= 0 && onFloor:
				precision_jump()
				
		"slowmo":
			print("slowmo")
			slowmo(is_pressed)
		"flip_gravity":
			print("flip_gravity")
			if is_pressed:
				flip_gravity()
		"punch":
			print("punch")
			if punch_count > 0 && is_pressed:
				punch()

func flip_gravity() -> void:
	compass = global.ru_setCompass("up", compass.down)
	tree.travel("inAir")
	ru_rotate(compass.up)
	onFloor = false

func slowmo(is_pressed: bool) -> void:
	slowmo_on = is_pressed

func jump(direction: Vector2):
	print("jump", global_transform)
	velocity = (compass.up + direction.x * compass.right).normalized() * JUMP_FORCE
	onFloor = false
	timer.start()
	justJumped = true
	jump_count -= 1
	gravity_factor = true
	tree.travel("jump")
	emit_signal("set_jump_count", jump_count, precision_count, player)

func precision_jump():
	var direction = global.left_stick(player)
	var jump_direction = direction.y * compass.up + direction.x * compass.right
	timer.start()
	precision_count -= 1
	justJumped = true
	gravity_factor = false
	tree.travel("precision-jump")
	velocity = jump_direction.normalized() * JUMP_FORCE * 2
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

func punch():
	var opponents = punch_area.get_overlapping_bodies()
	var hit = false
	for opponent in opponents:
		if opponent is KinematicBody2D:
			hit = true
			var pos = opponent.global_position
			opponent.get_punched(pos - global_position, player)
	if hit:
		punch_count -= 1

func get_punched(direction: Vector2, player_index: int):
	if player_index != player && !onFloor:
		velocity = direction.normalized() * PUNCHING_POWER
		tree.travel("inAir")

func die():
	emit_signal("die", player)
	emit_signal("rotate", compass.up)
	velocity = Vector2(0,0)
	global_position = initial_position
	onFloor = false

func player_input_velocity():
	var factor = 1.0
	if onFloor:
		return Vector2(0,0)
	if !is_falling_down():
		factor = 0.5
	return compass.right * global.left_stick(player).x * AIR_CONTROL * factor

func gravity_velocity():
	if is_falling_down() && gravity_factor:
		print("turn off")
		gravity_factor = false
	var g = GRAVITY_FACTOR if gravity_factor else 1.0
	return compass.down * GRAVITY_FORCE * g

func collision_handler(collision):
	print("collide")
	if collision.collider is Planet:
		var type = collision.collider.get_type()
		if type == "sticky":
			stick(collision)
			get_n_abilities(2)
		if type == "bouncy" || toBounce:
			if collision.collider.isBlobbed != player:
				bounce(collision)
			else:
				stick(collision)
		if type == "deadly":
			die()
		if collision.collider.isBlobbed != player && type != "deadly":
			if collision.collider.isBlobbed != -1:
				get_n_abilities(1)
			collision.collider.set_type("bouncy", player, color)
		
		emit_signal("set_jump_count", jump_count, precision_count, player)
		
	if collision.collider is KinematicBody2D:
		if collision.collider.player != player:
			bounce(collision)
			
func get_n_abilities(n: int):
	for i in range(n):
		randomize()
		var r = randf()
		if r < 0.5:
			jump_count += 1
		else:
			precision_count += 1
	pass

func ru_rotate(vec) -> void:
	emit_signal("rotate", vec)
	var angle = vec.angle()
	var rot = rotation - PI / 2
	if tween:
		tween.interpolate_property(self, "rotation", null, rotation + global.short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func is_falling_down():
	return compass.down.dot(velocity) > 0

func _physics_process(delta):
	if !onFloor:
		velocity = velocity + (player_input_velocity() + gravity_velocity()) * delta
		if is_falling_down() && velocity.length() > MAX_SPEED:
			velocity = velocity.normalized() * MAX_SPEED
	var oldCollide = newCollide
	if slowmo_on:
		newCollide = move_and_collide(velocity / SLOWMO)
	else:
		newCollide = move_and_collide(velocity)

	if newCollide:
		if newCollide != oldCollide:
			collision_handler(newCollide)
