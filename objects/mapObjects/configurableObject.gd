tool
extends StaticBody2D

class_name Planet

var textures = {
"bouncy": preload("res://gfx/New folder/0001.png"),
"sticky": preload("res://gfx/New folder/earth.png"),
"deadly": preload("res://gfx/New folder/sun.png"),
"goal": preload("res://gfx/New folder/moon.png")
}

var types = ["sticky", "goal", "deadly", "bouncy"]
var isBlobbed = 0
export(String, "sticky", "goal", "deadly", "bouncy") var type = "goal"

onready var tween = get_node("Tween")

func _ready() -> void:
	$Sprite.texture = textures[type]
	$AnimatedSprite.visible = false

func set_properties(planet_type = "sticky", planet_scale = 1, initial_position = null, x = 0, y = 0) -> void:
	type = planet_type if planet_type != "random" else get_random_type()
	scale = Vector2(planet_scale, planet_scale)
	global_position = initial_position if initial_position else Vector2(x, y)
	$Sprite.texture = textures[type]

func _process(delta: float) -> void:
	$Sprite.texture = textures[type]

func get_type(color, player):
	$AnimatedSprite.modulate = color
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("blobify")
	isBlobbed = player
	return type

func set_type(planet_type: String):
	type = planet_type

func get_random_type() -> String:
	var r = randf()
	if r < 0.4:
		return "sticky"
	elif r < 0.7:
		return "deadly"
	else:
		return "goal"
