extends StaticBody2D

onready var light = get_node("Light2D")
onready var tween = get_node("Tween")

func get_type():
	tween.interpolate_property(light, "texture_scale", null, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	return "sticky"