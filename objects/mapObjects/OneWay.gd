extends StaticBody2D
onready var sprite = get_node("Sprite")
export(String, "bouncy", "sticky") var type = "sticky"
var bouncy = preload("res://gfx/ow_platform_bounce.png")
var sticky = preload("res://gfx/ow_platform.png")
func _ready():
	if(type == "bouncy"):
		sprite.set_texture(bouncy)
	else:
		sprite.texture = sticky



func get_type():
	return type