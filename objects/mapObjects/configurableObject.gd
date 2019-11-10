extends StaticBody2D
class_name Planet

var textures = {
"bouncy": preload("res://gfx/New folder/0001.png"),
"sticky": preload("res://gfx/New folder/earth.png"),
"deadly": preload("res://gfx/New folder/sun.png"),
"goal": preload("res://gfx/New folder/moon.png")
}

var types = ["sticky", "goal", "deadly", "bouncy"]
export(String, "sticky", "goal", "deadly", "bouncy") var type = "goal"
export(Texture) var sprite

onready var tween = get_node("Tween")

func _ready() -> void:
	$AnimatedSprite.visible = false

func set_properties(planet_type = "sticky", planet_scale = 1, initial_position = null, x = 0, y = 0):
	type = planet_type
	scale = Vector2(planet_scale, planet_scale)
	global_position = initial_position if initial_position else Vector2(x, y)

func get_type():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("blobify")
	return type

func set_type(t = null):
	if t:
		type = t
	else:
		var r = randf()
		if r < 0.4:
			type = "sticky"
		elif r < 0.7:
			type = "deadly"
		else:
			type = "goal"
			print(type)
	$Sprite.texture = textures[type]
