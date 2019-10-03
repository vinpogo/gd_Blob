extends Camera2D

onready var tween = get_child(0)
onready var blob = get_parent().get_child(0)
#func _on_ready():
#	rotation = $"../Blob".gravity_dir.angle()-PI/2

func _physics_process(delta):
	global_position = blob.global_position
	
	if ((blob.gravity_dir.angle() - PI/2) != rotation):
		ru_set_rotation(blob.gravity_dir.angle() - PI/2)


func ru_set_rotation(angle):
	if !tween.is_active():
		tween.interpolate_property(self, "rotation", null, angle, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
#		tween.start()


func _on_Tween_tween_completed(object, key):
	tween.stop_all()

