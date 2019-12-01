tool
extends StaticBody2D

class_name Planet

var textures = {
"bouncy": preload("res://gfx/New folder/moon.png"),
"sticky": preload("res://gfx/New folder/moon.png"),
"deadly": preload("res://gfx/New folder/sun.png"),
"goal": preload("res://gfx/New folder/moon.png")
}

var types = ["sticky", "deadly", "bouncy"]
var isBlobbed = -1
export(String, "sticky","deadly", "bouncy") var type = "sticky"
export var radius = 190.0
onready var tween = get_node("Tween")

func _ready() -> void:
	$Textures/Sprite.texture = textures[type]
	$Textures/AnimatedSprite.visible = false

func set_properties(planet_type = "sticky", planet_scale = 1, initial_position = null, x = 0, y = 0) -> void:
	type = planet_type if planet_type != "random" else "sticky"
	scale = Vector2(planet_scale, planet_scale)
	global_position = initial_position if initial_position else Vector2(x, y)
	$Textures/Sprite.texture = textures[type]

func _process(delta: float) -> void:
	$Textures/Sprite.texture = textures[type]
	$Textures/Sprite.scale = Vector2(radius / 190.0, radius / 190.0)
	$Textures/AnimatedSprite.scale = Vector2(radius / 190.0, radius / 190.0)
	$CollisionShape2D.shape.radius = radius

func get_type():
	return type

func set_type(planet_type: String, player, color):
	$Textures/AnimatedSprite.modulate = color
	$Textures/AnimatedSprite.visible = true
	$Textures/AnimatedSprite.play("blobify")
	isBlobbed = player
	type = planet_type

func get_random_type() -> String:
	var r = randf()
	if r < 0.7:
		return "sticky"
	else:
		return "deadly"
