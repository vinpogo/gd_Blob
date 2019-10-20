extends Camera2D

onready var blobChar = get_parent().get_node("Map/Blob")
onready var tween = get_node("rotation")


func _physics_process(delta):
	if Input.is_action_just_pressed("slot_5"):
		zoom = zoom*2 if zoom == Vector2(1, 1) else Vector2(1, 1)
	if blobChar:
		position = blobChar.global_position


func _on_Blob_rotate(vec: Vector2) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2

	tween.interpolate_property(self, "rotation", null, rotation + short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func lerp_angle(from, to, weight):
		return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
		var max_angle = PI * 2
		var difference = fmod(to - from, max_angle)
		return fmod(2 * difference, max_angle) - difference

func _on_Blob_toggle_zoom() -> void:
	zoom = zoom*2 if zoom == Vector2(1, 1) else Vector2(1, 1)
