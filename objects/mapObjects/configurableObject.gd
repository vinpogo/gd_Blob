extends StaticBody2D
class_name Planet

var textures = {
"bouncy": preload("res://gfx/New folder/0001.png"),
"sticky": preload("res://gfx/New folder/earth.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-3.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-4.png"),
"deadly": preload("res://gfx/New folder/sun.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-6.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-7.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-8.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-9.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-10.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-11.png"),
"goal": preload("res://gfx/New folder/moon.png")
}

var types = ["sticky", "goal", "deadly", "bouncy"]
export(String, "sticky", "goal", "deadly", "bouncy") var type = "goal"
export(Texture) var sprite

onready var tween = get_node("Tween")

func _ready() -> void:
	$AnimatedSprite.visible = false

func get_type():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("blobify")
	return type

func set_type(t = null):
	if t:
		type = t
		return
	var r = randf()
	if r < 0.4:
		type = "sticky"
	elif r < 0.7:
		type = "deadly"
	else:
		type = "goal"
	$Sprite.texture = textures[type]
