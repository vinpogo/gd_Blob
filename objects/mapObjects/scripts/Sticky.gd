extends StaticBody2D

export var Timeout = -0.0
onready var tween = get_node("Tween")

func get_type():

	if Timeout > 0:
		tween.interpolate_property($Gfx, "scale", null, Vector2(1,0), Timeout, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
	return "sticky"


func _on_Tween_tween_all_completed() -> void:
	queue_free()
	pass # Replace with function body.
