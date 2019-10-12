extends Camera2D

onready var blobChar = get_parent().get_node("Blob/BlobCharacter")
onready var tween = get_node("rotation")


func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		zoom = zoom*2 if zoom == Vector2(1, 1) else Vector2(1, 1)
	if blobChar:
		position = blobChar.global_position
	

func _on_Blob_rotate(angle) -> void:
	tween.interpolate_property(self, "rotation", null, angle, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	pass # Replace with function body.
