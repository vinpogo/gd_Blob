extends StaticBody2D
class_name Planet

var textures = {
"bouncy": preload("res://gfx/Planets/planet-4.png"),
"sticky": preload("res://gfx/Planets/planet-14.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-3.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-4.png"),
"deadly": preload("res://gfx/Planets/planet-7.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-6.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-7.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-8.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-9.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-10.png"),
#preload("res://gfx/Planets-Atmosphere-pngs/planet-11.png"),
"goal": preload("res://gfx/Planets/planet-12.png")
}

var types = ["sticky", "goal", "deadly", "bouncy"]
export(String, "sticky", "goal", "deadly", "bouncy") var type = "goal"
export(Texture) var sprite

onready var tween = get_node("Tween")

func _ready() -> void:
	$Sprite2.visible = false

func get_type():
	$Sprite2.visible = true
	return type

func set_type():
	var r = randf()
	if r < 0.3:
		type = types[2]
	elif r < 0.6:
		type = types[0]
	elif r < 0.9:
		type = types[1]
	else:
		type = types[3]
	$Sprite.texture = textures[type]
