extends Camera2D

onready var tween = get_node("Tween")
#func _on_ready():
#	rotation = $"../Blob".gravity_dir.angle()-PI/2

func _process(delta):
	position = $"../Blob".ru_position()
	if (($"../Blob".rotation-PI/2) != rotation):
		ru_set_rotation($"../Blob".gravity_dir.angle() - PI/2)


func ru_set_rotation(angle):
	tween.interpolate_property(self, "rotation", null, angle, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if !tween.is_active():
		tween.start()
