extends KinematicBody2D
class_name BlobCharacter, "res://gfx/blob/icon.png"

enum ABILITIES{
	PRECISION_JUMP,
	FLIP_GRAVITY,
	SLOWMO,
	JUMP,
	BOUNCE,
	PUNCH
}

signal stick
signal rotate(vec)
signal set_jump_count(count, player)
signal jump
signal die

export var GRAVITY_FORCE: = 64
export var GRAVITY_FACTOR: = 0.4
export var PUNCHING_POWER: = 60.0
export var JUMP_FORCE: = 7.0
export var MAX_SPEED: = 21.0
export var SLOWMO: = 3.0
export var AIR_CONTROL: = 30.0
export(Texture) var player_atlas
export(Color) var color
export var player: = 1

onready var punch_area = get_node("PunchArea")
onready var tree = $AnimationPlayer/AnimationTree["parameters/playback"]

var on_floor: = false
var to_bounce: = false
var gravity_factor: = false
var slowmo_on: = false
var velocity: = Vector2(0,0)
var initial_gravity: Vector2
var initial_position: Vector2
var newCollide: KinematicCollision2D
var ability_mapping = [
	ABILITIES.JUMP, # 0
	ABILITIES.PRECISION_JUMP, # 1
	ABILITIES.FLIP_GRAVITY, # 2
	ABILITIES.BOUNCE, # 3
	ABILITIES.PUNCH, # 4
	ABILITIES.SLOWMO # 5
]
var ability_count = {
	"jump": 5,
	"special": 5
} setget set_ability_count
var compass = {"down": Vector2(0,1), "up": Vector2(0, -1), "right": Vector2(1, 0), "left": Vector2(-1,0)} setget set_compass

func set_compass(value) -> void:
	compass = value
	ru_rotate(compass.up)
	emit_signal("rotate", compass.up)

func set_ability_count(value):
	ability_count = value
	emit_signal("set_jump_count", ability_count, player)
	pass
func init_blob(player_config):
	player = player_config.player_index if player_config.player_index >= 0 else 0
	ability_count = player_config.ability_count if player_config.ability_count else {"jump": 5, "special": 5}
	initial_position = player_config.initial_position if player_config.initial_position else Vector2(0,0)
	global_position = initial_position
	self.compass = global.get_compass("down", player_config.initial_gravity_direction)
	initial_gravity = compass.down
	color = player_config.color
	$Sprite.modulate = color

func _ready():
	emit_signal("rotate", compass.down)
	if player_atlas:
		$Sprite.texture = player_atlas
	$Sprite.modulate = color
	emit_signal("set_jump_count", ability_count, player)

func _input(event: InputEvent) -> void:
	if event.device == player:
		var ability: int
		var toggled_to_state: bool
		if event is InputEventJoypadButton:
			if event.is_action_pressed("ui_home"):
				get_tree().change_scene("res://objects/Control.tscn")
			print(event.is_action_type())
			if event.is_action_pressed("jump"):
				ability = ability_mapping[0]
				toggled_to_state = true
			if event.is_action_released("jump"):
				ability = ability_mapping[0]
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
		if player == 0:
			print(transform.basis_xform(global.left_stick(player)))

func handle_ability(ability: int, is_pressed: bool) -> void:
	match(ability):

		ABILITIES.JUMP:
			if ability_count.jump > 0 && is_pressed:
				var direction = global.left_stick(player)
				jump(direction)
			elif !is_pressed:
				print("turn off")
				gravity_factor = false

		ABILITIES.PRECISION_JUMP:
			print("precision_jump")
			if ability_count.jump > 0 && is_pressed:
				$Arrow.visible = true
			if !is_pressed:
				$Arrow.visible = false
				if on_floor:
					if ability_count.jump > 0 && global.left_stick(player).y < 0:
						precision_jump()
				else:
					if ability_count.jump > 0 && Vector2(0,0) != global.left_stick(player):
						precision_jump()

		ABILITIES.SLOWMO:
			print("slowmo")
			if is_pressed && ability_count.special > 0 && !on_floor:
				ability_count.special -= 1
				slowmo(true)
			if !is_pressed:
				slowmo(false)

		ABILITIES.FLIP_GRAVITY:
			print("flip_gravity")
			if is_pressed && ability_count.special > 0:
				flip_gravity()

		ABILITIES.PUNCH:
			print("punch")
			if is_pressed && ability_count.special > 0 && !on_floor:
				punch()
		ABILITIES.BOUNCE:
			print("bounce")
			if is_pressed && !on_floor:
				to_bounce = true
			if !is_pressed:
				to_bounce = false
	emit_signal("set_jump_count", ability_count, player)

func flip_gravity() -> void:
	self.compass = global.get_compass("up", compass.down)
	tree.travel("inAir")
	ability_count.special -= 1
	on_floor = false

func slowmo(is_pressed: bool) -> void:
	slowmo_on = is_pressed

func jump(direction: Vector2):
	print("jump")
	slowmo(false)
	var new_velocity = direction
	new_velocity.y = -1
	new_velocity = new_velocity.normalized() * JUMP_FORCE
	new_velocity = transform.basis_xform(new_velocity)
	velocity = new_velocity#(compass.up + direction.x * compass.right).normalized() * JUMP_FORCE
	on_floor = false
	ability_count.jump -= 1
	gravity_factor = true
	tree.travel("jump")

func precision_jump():
	slowmo(false)
	var direction = global.left_stick(player)* JUMP_FORCE * 2
	var jump_direction = transform.basis_xform(direction)
	ability_count.jump -= 1
	gravity_factor = false
	tree.travel("precision-jump")
	velocity = jump_direction #.normalized() * JUMP_FORCE * 2
	on_floor = false
	emit_signal("jump")

func bounce(col):
	slowmo(false)
	velocity = velocity.bounce(col.normal).normalized() * JUMP_FORCE
	tree.travel("jump")

func stick(collision):
	if !on_floor:
		slowmo(false)
		tree.travel("land")
		on_floor = true
		velocity = Vector2(0,0)
		gravity_factor = false
		self.compass = global.get_compass("up", collision.normal)
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
		ability_count.special -= 1

func get_punched(direction: Vector2, player_index: int):
	if player_index != player && !on_floor:
		slowmo(false)
		velocity = direction.normalized() * PUNCHING_POWER
		tree.travel("inAir")

func die():
	slowmo(false)
	self.compass = global.get_compass("down", initial_gravity)
	emit_signal("die", player)
	velocity = Vector2(0,0)
	global_position = initial_position
	on_floor = false

func player_input_velocity():
	var factor = 1.0
	if on_floor:
		return Vector2(0,0)
	if !is_falling_down():
		factor = 0.5
	return compass.right * global.left_stick(player).x * AIR_CONTROL * factor

func gravity_velocity():
	if is_falling_down() && gravity_factor:
		gravity_factor = false
	var g = GRAVITY_FACTOR if gravity_factor else 1.0
	return compass.down * GRAVITY_FORCE * g

func collision_handler(collision):
	if collision.collider is Planet:
		var type = collision.collider.get_type()
		if type == "bouncy" || to_bounce:
			if collision.collider.isBlobbed != player:
				bounce(collision)
			elif to_bounce && ability_count.special > 0:
				bounce(collision)
				ability_count.special -= 1
			else:
				stick(collision)
		elif type == "sticky":
			stick(collision)
		if type == "deadly":
			die()
		else:
			if collision.collider.isBlobbed == -1:
				PlayerManager.add_score_for_player(30, player)
				get_n_abilities(3)
			elif collision.collider.isBlobbed != player:
				PlayerManager.add_score_for_player(20, player)
				get_n_abilities(2)
			else:
				get_n_abilities(1)
			collision.collider.set_type("bouncy", player, color)

		emit_signal("set_jump_count", ability_count, player)

	if collision.collider is KinematicBody2D:
		if collision.collider.player != player:
			bounce(collision)

func get_n_abilities(n: int):
	ability_count.jump += 1
	if n <= 1:
		return
	randomize()
	for i in range(n):
		var r = randf()
		if r < 0.5:
			ability_count.jump += 1
		else:
			ability_count.special += 1
	pass

func ru_rotate(vec) -> void:
	emit_signal("rotate", vec)
	var angle = vec.angle()
	var rot = rotation - PI / 2
	self.rotation += global.short_angle_dist(rot, angle)

func is_falling_down():
	return compass.down.dot(velocity) > 0

func _physics_process(delta):
	if !on_floor:
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
