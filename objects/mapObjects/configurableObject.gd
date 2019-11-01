extends StaticBody2D

export(String, "sticky", "goal") var type = "goal"
onready var tween = get_node("Tween")
onready var light = get_node("Light2D")


func get_type():
	tween.interpolate_property(light, "texture_scale", null, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if type == "goal":
		tween.start()
	return type