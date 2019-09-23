extends StaticBody2D

onready var sprite = get_node("Sprite")
export(String, "bouncy", "sticky") var type = "sticky"
var currentType
var bouncy = preload("res://gfx/standard_circle_bounce.png")
var sticky = preload("res://gfx/standard_circle.png")

func ru_setTexture(type):
	match(type):
		"sticky":
			sprite.set_texture(sticky)
			currentType = "sticky"
		"bouncy":
			sprite.set_texture(bouncy)
			currentType = "bouncy"
			
			


func _ready():
	ru_setTexture(type)

func _physics_process(delta):
	if type != currentType:
		print("switch sprite")
		ru_setTexture(type)
		
func get_type():
	return type